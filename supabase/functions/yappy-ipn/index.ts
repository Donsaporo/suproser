import { createClient } from 'npm:@supabase/supabase-js@2';
import { createHmac } from "node:crypto";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

interface YappyIPNParams {
  orderId: string;
  status: 'E' | 'R' | 'C' | 'X'; // E=approved, R=declined, C=cancelled, X=expired
  hash: string;
  domain: string;
  confirmationNumber?: string;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    console.log('yappy:ipn:start');

    // Parse query parameters
    const url = new URL(req.url);
    const params: YappyIPNParams = {
      orderId: url.searchParams.get('orderId') || '',
      status: (url.searchParams.get('status') as 'E' | 'R' | 'C' | 'X') || 'X',
      hash: url.searchParams.get('hash') || '',
      domain: url.searchParams.get('domain') || '',
      confirmationNumber: url.searchParams.get('confirmationNumber') || undefined
    };

    console.log('yappy:ipn:params', { 
      orderId: params.orderId, 
      status: params.status, 
      domain: params.domain,
      hasHash: !!params.hash
    });

    // Validate required parameters
    if (!params.orderId || !params.status || !params.hash || !params.domain) {
      console.error('yappy:ipn:missing-params', params);
      return new Response(
        JSON.stringify({ success: false, error: 'Missing required parameters' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      );
    }

    // Get configuration
    const YAPPY_SECRET = 'QkdfMjY2ZjY1ZjZkNjRkZGM2ZGU0ZjcuR2IzVU5tTUdVQjZvcjIzcG8wNVJpNlZKRkw0MEN4VGc5dkpUazNVRg==';
    const YAPPY_DOMAIN = 'https://suproser.obzide.com';

    if (!YAPPY_SECRET || !YAPPY_DOMAIN) {
      throw new Error('Missing Yappy configuration');
    }

    // Validate domain
    if (params.domain !== YAPPY_DOMAIN) {
      console.error('yappy:ipn:domain-mismatch', { 
        expected: YAPPY_DOMAIN, 
        received: params.domain 
      });
      return new Response(
        JSON.stringify({ success: false, error: 'Domain mismatch' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      );
    }

    // Validate HASH
    console.log('yappy:ipn:validating-hash');
    
    // Decode base64 secret and get first segment (before '.')
    const decodedSecret = atob(YAPPY_SECRET);
    const hmacKey = decodedSecret.split('.')[0];
    
    // Calculate expected hash: HMAC-SHA256(orderId + status + domain)
    const hashInput = (params.orderId + params.status + params.domain).toLowerCase();
    const expectedHash = createHmac('sha256', hmacKey)
      .update(hashInput)
      .digest('hex')
      .toLowerCase();
    
    const receivedHash = params.hash.toLowerCase();
    
    console.log('yappy:ipn:hash-check', { 
      input: hashInput,
      expected: expectedHash.slice(0, 8) + '...',
      received: receivedHash.slice(0, 8) + '...',
      valid: expectedHash === receivedHash
    });

    if (expectedHash !== receivedHash) {
      console.error('yappy:ipn:invalid-hash');
      
      // Store invalid hash attempt
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
      );

      await supabase
        .from('webhook_events')
        .insert({
          source: 'yappy',
          event_type: 'ipn_invalid_hash',
          payload: { params, hashInput, expectedHash, receivedHash }
        });

      return new Response(
        JSON.stringify({ success: false, error: 'Invalid hash' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      );
    }

    // Hash is valid, process the payment
    console.log('yappy:ipn:hash-valid');

    // Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Find payment record by orderId pattern
    console.log('yappy:ipn:finding-payment', params.orderId);
    const { data: payments, error: searchError } = await supabase
      .from('payments')
      .select('id, order_id, status, raw')
      .eq('method', 'yappy')
      .like('raw->>shortOrderId', `%${params.orderId}%`);

    if (searchError) {
      throw new Error(`Error searching payments: ${searchError.message}`);
    }

    const payment = payments?.[0];
    if (!payment) {
      console.error('yappy:ipn:payment-not-found', params.orderId);
      return new Response(
        JSON.stringify({ success: false, error: 'Payment not found' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      );
    }

    console.log('yappy:ipn:payment-found', { 
      paymentId: payment.id, 
      orderId: payment.order_id,
      currentStatus: payment.status 
    });

    // Map Yappy status to our status
    const statusMap: { [key: string]: string } = {
      'E': 'approved',  // Exitoso
      'R': 'declined',  // Rechazado
      'C': 'declined',  // Cancelado
      'X': 'declined'   // Expirado
    };

    const newStatus = statusMap[params.status] || 'error';
    
    console.log('yappy:ipn:status-mapping', { 
      yappyStatus: params.status, 
      newStatus 
    });

    // Update payment record
    const updatedRaw = {
      ...payment.raw,
      ipn: {
        ...params,
        receivedAt: new Date().toISOString(),
        hashValidated: true
      }
    };

    const { error: updateError } = await supabase
      .from('payments')
      .update({
        status: newStatus,
        raw: updatedRaw
      })
      .eq('id', payment.id);

    if (updateError) {
      throw new Error(`Failed to update payment: ${updateError.message}`);
    }

    console.log('yappy:ipn:payment-updated');

    // Update order status if payment was approved
    if (newStatus === 'approved') {
      console.log('yappy:ipn:updating-order-status');
      const { error: orderUpdateError } = await supabase
        .from('orders')
        .update({ 
          status: 'pagado',
          updated_at: new Date().toISOString()
        })
        .eq('id', payment.order_id);

      if (orderUpdateError) {
        console.error('yappy:ipn:order-update-error', orderUpdateError);
        // Don't fail IPN if order update fails
      } else {
        console.log('yappy:ipn:order-updated-to-pagado');
      }
    }

    // Log IPN event
    await supabase
      .from('webhook_events')
      .insert({
        source: 'yappy',
        event_type: `ipn_${newStatus}`,
        payload: { 
          params, 
          paymentId: payment.id, 
          orderId: payment.order_id,
          newStatus 
        }
      });

    console.log('yappy:ipn:success', { 
      paymentId: payment.id, 
      newStatus,
      orderId: payment.order_id 
    });

    return new Response(
      JSON.stringify({ success: true }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    );

  } catch (error) {
    console.error('yappy:ipn:error', error);

    // Log error event
    try {
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
      );

      await supabase
        .from('webhook_events')
        .insert({
          source: 'yappy',
          event_type: 'ipn_error',
          payload: { 
            error: error instanceof Error ? error.message : 'Unknown error',
            url: req.url
          }
        });
    } catch (logError) {
      console.error('yappy:ipn:log-error', logError);
    }

    return new Response(
      JSON.stringify({ 
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error' 
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    );
  }
});