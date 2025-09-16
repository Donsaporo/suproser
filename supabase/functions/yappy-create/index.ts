import { createClient } from 'npm:@supabase/supabase-js@2';
import { createHmac } from "node:crypto";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

interface CreatePaymentRequest {
  orderId: string;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    console.log('yappy:create:start');

    // Get environment variables
    const YAPPY_ENV = 'uat';
    const YAPPY_MERCHANT_ID = '6452918b8fe27ca367cbc3e9ef269659';
    const YAPPY_SECRET = 'QkdfMjY2ZjY1ZjZkNjRkZGM2ZGU0ZjcuR2IzVU5tTUdVQjZvcjIzcG8wNVJpNlZKRkw0MEN4VGc5dkpUazNVRg==';
    const YAPPY_DOMAIN = 'https://suproser.obzide.com';
    const YAPPY_ALIAS = '63499962';

    if (!YAPPY_MERCHANT_ID || !YAPPY_SECRET || !YAPPY_DOMAIN || !YAPPY_ALIAS) {
      throw new Error('Missing Yappy configuration');
    }

    // Parse request
    const { orderId } = await req.json() as CreatePaymentRequest;

    if (!orderId) {
      throw new Error('Order ID is required');
    }

    console.log('yappy:create:order', orderId);

    // Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    // Get order details
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .select('id, total, status')
      .eq('id', orderId)
      .single();

    if (orderError || !order) {
      throw new Error(`Order not found: ${orderId}`);
    }

    if (order.total <= 0) {
      throw new Error('Order total must be greater than 0');
    }

    console.log('yappy:create:order-found', { total: order.total, status: order.status });

    // Select API base URL
    const API_BASE = YAPPY_ENV === 'prod' 
      ? 'https://apipagosbg.bgeneral.cloud'
      : 'https://api-comecom-uat.yappycloud.com';

    // Step 1: Validate merchant to get session token
    console.log('yappy:create:validating-merchant');
    const validateResponse = await fetch(`${API_BASE}/payments/validate/merchant`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        merchantId: YAPPY_MERCHANT_ID,
        urlDomain: YAPPY_DOMAIN
      })
    });

    if (!validateResponse.ok) {
      throw new Error(`Merchant validation failed: ${validateResponse.status}`);
    }

    const validateData = await validateResponse.json();
    const sessionToken = validateData.token;

    if (!sessionToken) {
      throw new Error('No session token received from Yappy');
    }

    console.log('yappy:create:token-ok');

    // Step 2: Create payment
    console.log('yappy:create:creating-payment');
    
    // Generate short order ID (max 15 chars)
    const shortOrderId = orderId.replace(/-/g, '').slice(-12).toUpperCase();
    const paymentDate = Math.floor(Date.now() / 1000); // Unix timestamp
    
    // Format amounts as strings with 2 decimals
    const total = order.total.toFixed(2);
    const subtotal = order.total.toFixed(2); // Assuming no taxes for now
    
    const paymentPayload = {
      merchantId: YAPPY_MERCHANT_ID,
      orderId: shortOrderId,
      domain: YAPPY_DOMAIN,
      paymentDate: paymentDate,
      aliasYappy: YAPPY_ALIAS,
      ipnUrl: `${YAPPY_DOMAIN}/api/payments/yappy/ipn`,
      discount: "0.00",
      taxes: "0.00",
      subtotal: subtotal,
      total: total
    };

    console.log('yappy:create:payload', { 
      ...paymentPayload, 
      merchantId: YAPPY_MERCHANT_ID.slice(0, 8) + '...' 
    });

    const createResponse = await fetch(`${API_BASE}/payments/payment-wc`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${sessionToken}`
      },
      body: JSON.stringify(paymentPayload)
    });

    const createResponseText = await createResponse.text();
    console.log('yappy:create:response', { 
      status: createResponse.status,
      response: createResponseText.slice(0, 200) + '...'
    });

    if (!createResponse.ok) {
      throw new Error(`Payment creation failed: ${createResponse.status} ${createResponseText}`);
    }

    let paymentData;
    try {
      paymentData = JSON.parse(createResponseText);
    } catch (parseError) {
      throw new Error(`Invalid JSON response: ${createResponseText}`);
    }

    const { transactionId, token, documentName } = paymentData;

    if (!transactionId || !token || !documentName) {
      throw new Error('Incomplete payment data from Yappy');
    }

    console.log('yappy:create:payment-ok', { 
      transactionId,
      documentName 
    });

    // Step 3: Store in payments table
    console.log('yappy:create:storing-payment');
    const { error: paymentError } = await supabase
      .from('payments')
      .upsert({
        order_id: orderId,
        method: 'yappy',
        status: 'pending',
        amount: order.total,
        provider_ref: transactionId,
        raw: {
          creation: paymentData,
          shortOrderId,
          paymentDate,
          sessionToken: sessionToken.slice(0, 8) + '...' // Truncated for security
        }
      }, {
        onConflict: 'order_id'
      });

    if (paymentError) {
      console.error('yappy:create:storage-error', paymentError);
      throw new Error(`Failed to store payment: ${paymentError.message}`);
    }

    console.log('yappy:create:stored-ok');

    // Return data needed for frontend
    return new Response(
      JSON.stringify({
        success: true,
        transactionId,
        token,
        documentName,
        shortOrderId,
        total: order.total
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    );

  } catch (error) {
    console.error('yappy:create:error', error);
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