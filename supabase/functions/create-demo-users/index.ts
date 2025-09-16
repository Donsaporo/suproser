import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

interface DemoUser {
  email: string;
  password: string;
  role_app: 'admin' | 'cliente_master' | 'cliente_gerente_sucursal';
  display_name: string;
}

interface CreateResult {
  role: string;
  status: 'created' | 'exists' | 'error';
  message?: string;
  user_id?: string;
}

const DEMO_USERS: DemoUser[] = [
  {
    email: 'admin.demo@suproser.app',
    password: 'Demo123$!',
    role_app: 'admin',
    display_name: 'Admin Demo'
  },
  {
    email: 'master.demo@clientedemo.app',
    password: 'Demo123$!',
    role_app: 'cliente_master',
    display_name: 'Master Demo'
  },
  {
    email: 'gerente.rioabajo.demo@clientedemo.app',
    password: 'Demo123$!',
    role_app: 'cliente_gerente_sucursal',
    display_name: 'Gerente Río Abajo Demo'
  }
];

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    console.log('Starting create-demo-users function');
    
    // Use service role for admin operations
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    );

    console.log('Supabase client created');

    const results: CreateResult[] = [];
    let clientId: string | null = null;
    let branchId: string | null = null;

    // Step 1: Ensure demo client exists
    console.log('Step 1: Checking for existing client');
    const { data: existingClient } = await supabaseAdmin
      .from('clients')
      .select('id')
      .eq('name', 'Cliente Demo S.A.')
      .single();

    if (existingClient) {
      clientId = existingClient.id;
      console.log('Client exists:', clientId);
    } else {
      console.log('Creating new client');
      const { data: newClient, error: clientError } = await supabaseAdmin
        .from('clients')
        .insert({
          name: 'Cliente Demo S.A.',
          tax_id: '8-123-4567',
          billing_email: 'facturacion@clientedemo.com'
        })
        .select('id')
        .single();

      if (clientError) {
        console.error('Client creation error:', clientError);
        throw new Error(`Error creating demo client: ${clientError.message}`);
      }
      clientId = newClient.id;
      console.log('Client created:', clientId);
    }

    // Step 2: Ensure demo branch exists
    console.log('Step 2: Checking for existing branch');
    const { data: existingBranch } = await supabaseAdmin
      .from('client_branches')
      .select('id')
      .eq('client_id', clientId)
      .eq('code', 'RIO001')
      .single();

    if (existingBranch) {
      branchId = existingBranch.id;
      console.log('Branch exists:', branchId);
    } else {
      console.log('Creating new branch');
      const { data: newBranch, error: branchError } = await supabaseAdmin
        .from('client_branches')
        .insert({
          client_id: clientId,
          name: 'Río Abajo',
          code: 'RIO001',
          address: 'Río Abajo, Ciudad de Panamá'
        })
        .select('id')
        .single();

      if (branchError) {
        console.error('Branch creation error:', branchError);
        throw new Error(`Error creating demo branch: ${branchError.message}`);
      }
      branchId = newBranch.id;
      console.log('Branch created:', branchId);
    }

    // Step 3: Create/ensure demo users
    console.log('Step 3: Processing demo users');
    for (const demoUser of DEMO_USERS) {
      try {
        console.log(`Processing user: ${demoUser.email}`);
        let userId: string | null = null;
        let userExists = false;

        // Try to create user directly, handle existing user case
        console.log(`Creating/checking user: ${demoUser.email}`);
        const { data: newUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
          email: demoUser.email,
          password: demoUser.password,
          email_confirm: true, // Auto-confirm email
        });

        if (authError) {
          // Check if user already exists
          if (authError.message?.includes('already registered') || authError.message?.includes('already exists')) {
            console.log(`User already exists: ${demoUser.email}, looking up user ID`);
            userExists = true;
            
            // Get user by listing all users and finding by email
            const { data: listResult, error: listError } = await supabaseAdmin.auth.admin.listUsers();
            if (listError) {
              console.error(`Error listing users: ${listError.message}`);
              results.push({
                role: demoUser.role_app,
                status: 'error',
                message: `Error listing users: ${listError.message}`
              });
              continue;
            }
            
            const existingUser = listResult.users?.find(u => u.email === demoUser.email);
            if (existingUser) {
              userId = existingUser.id;
              console.log(`Found existing user: ${demoUser.email} -> ${userId}`);
            } else {
              console.error(`User should exist but not found in list: ${demoUser.email}`);
              results.push({
                role: demoUser.role_app,
                status: 'error',
                message: `User exists but could not be found`
              });
              continue;
            }
          } else {
            console.error(`Auth error for ${demoUser.email}:`, authError);
            results.push({
              role: demoUser.role_app,
              status: 'error',
              message: `Auth error: ${authError.message}`
            });
            continue;
          }
        } else {
          // User was created successfully
          userId = newUser.user.id;
          console.log(`User created: ${demoUser.email} -> ${userId}`);
        }

        // Upsert user profile
        console.log(`Upserting profile for: ${userId}`);
        const { error: profileError } = await supabaseAdmin
          .from('user_profiles')
          .upsert({
            user_id: userId,
            role_app: demoUser.role_app,
            display_name: demoUser.display_name
          }, {
            onConflict: 'user_id'
          });

        if (profileError) {
          console.error(`Profile error for ${demoUser.email}:`, profileError);
          results.push({
            role: demoUser.role_app,
            status: 'error',
            message: `Profile error: ${profileError.message}`
          });
          continue;
        }

        // Create client_users assignments (not for admin)
        if (demoUser.role_app !== 'admin') {
          console.log(`Creating client user assignment for: ${demoUser.email}`);
          const clientUserData: any = {
            user_id: userId,
            client_id: clientId,
            role_in_client: demoUser.role_app === 'cliente_master' ? 'master' : 'gerente_sucursal'
          };

          // Add branch_id for gerente
          if (demoUser.role_app === 'cliente_gerente_sucursal') {
            clientUserData.branch_id = branchId;
          }

          const { error: clientUserError } = await supabaseAdmin
            .from('client_users')
            .upsert(clientUserData, {
              onConflict: 'user_id'
            });

          if (clientUserError) {
            console.error(`Client user error for ${demoUser.email}:`, clientUserError);
            results.push({
              role: demoUser.role_app,
              status: 'error',
              message: `Client user error: ${clientUserError.message}`
            });
            continue;
          }
        }

        console.log(`Successfully processed: ${demoUser.email}`);
        results.push({
          role: demoUser.role_app,
          status: userExists ? 'exists' : 'created',
          user_id: userId
        });

      } catch (error) {
        console.error(`Error processing user ${demoUser.email}:`, error);
        results.push({
          role: demoUser.role_app,
          status: 'error',
          message: error instanceof Error ? error.message : 'Unknown error'
        });
      }
    }

    console.log('Function completed successfully', { results, client_id: clientId, branch_id: branchId });
    return new Response(
      JSON.stringify({ results, client_id: clientId, branch_id: branchId }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      }
    );

  } catch (error) {
    console.error('Error in create-demo-users function:', error);
    return new Response(
      JSON.stringify({ 
        error: error instanceof Error ? error.message : 'Unknown error occurred',
        stack: error instanceof Error ? error.stack : undefined
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    );
  }
});