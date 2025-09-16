```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    let anonymousUser;
    let userProfile;

    // Create an anonymous user
    const { data, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: `anonymous_${crypto.randomUUID()}@example.com`, // Unique dummy email
      password: crypto.randomUUID(), // Random password
      email_confirm: true, // Auto-confirm
      is_anonymous: true, // Mark as anonymous
    });

    if (authError) {
      console.error('Error creating anonymous user:', authError.message);
      throw new Error(`Failed to create anonymous user: ${authError.message}`);
    }

    anonymousUser = data.user;

    // Create a profile for the anonymous user
    const { data: profileData, error: profileError } = await supabaseAdmin
      .from('user_profiles')
      .upsert({
        user_id: anonymousUser.id,
        display_name: 'Guest User',
        role_app: null, // No specific role for guests
        phone: null,
      })
      .select()
      .single();

    if (profileError) {
      console.error('Error creating profile for anonymous user:', profileError.message);
      // Optionally, delete the created auth user if profile creation fails
      await supabaseAdmin.auth.admin.deleteUser(anonymousUser.id);
      throw new Error(`Failed to create profile for anonymous user: ${profileError.message}`);
    }

    userProfile = profileData;

    return new Response(
      JSON.stringify({ user_id: anonymousUser.id, profile: userProfile }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    );
  } catch (error: any) {
    console.error('Edge Function error:', error.message);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      },
    );
  }
});
```