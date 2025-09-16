const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    console.log('yappy:validate:start');

    // Get environment variables
    const YAPPY_ENV = 'uat'; // Force UAT for development
    const YAPPY_MERCHANT_ID = '6452918b8fe27ca367cbc3e9ef269659';
    const YAPPY_DOMAIN = 'https://suproser.obzide.com';

    if (!YAPPY_MERCHANT_ID || !YAPPY_DOMAIN) {
      throw new Error('Missing Yappy configuration');
    }

    // Select API base URL based on environment
    const API_BASE = YAPPY_ENV === 'prod' 
      ? 'https://apipagosbg.bgeneral.cloud'
      : 'https://api-comecom-uat.yappycloud.com';

    console.log('yappy:validate:config', { 
      env: YAPPY_ENV, 
      merchant: YAPPY_MERCHANT_ID.slice(0, 8) + '...', 
      domain: YAPPY_DOMAIN 
    });

    // Validate merchant with Yappy
    const validatePayload = {
      merchantId: YAPPY_MERCHANT_ID,
      urlDomain: YAPPY_DOMAIN
    };

    const response = await fetch(`${API_BASE}/payments/validate/merchant`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(validatePayload)
    });

    const responseText = await response.text();
    console.log('yappy:validate:response', { 
      status: response.status, 
      response: responseText.slice(0, 200) + '...' 
    });

    if (!response.ok) {
      throw new Error(`Yappy validation failed: ${response.status} ${responseText}`);
    }

    let responseData;
    try {
      responseData = JSON.parse(responseText);
    } catch (parseError) {
      throw new Error(`Invalid JSON response: ${responseText}`);
    }

    console.log('yappy:validate:ok', { token: responseData.token ? 'present' : 'missing' });

    return new Response(
      JSON.stringify({
        success: true,
        token: responseData.token,
        merchant: YAPPY_MERCHANT_ID,
        domain: YAPPY_DOMAIN
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    );

  } catch (error) {
    console.error('yappy:validate:error', error);
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