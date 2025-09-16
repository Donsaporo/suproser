export interface UserProfile {
  user_id: string;
  display_name: string | null;
  role_app: 'admin' | 'cliente_master' | 'cliente_gerente_sucursal' | null;
  phone: string | null;
  created_at: string | null;
}

export interface ClientUser {
  id: string;
  client_id: string;
  branch_id: string | null;
  user_id: string;
  role_in_client: 'master' | 'gerente_sucursal' | null;
  created_at: string | null;
}

export interface Client {
  id: string;
  name: string;
  tax_id: string | null;
  billing_email: string | null;
  created_at: string | null;
}

export interface ClientBranch {
  id: string;
  client_id: string;
  name: string;
  code: string | null;
  address: string | null;
  created_at: string | null;
}