import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL!;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    flowType: 'pkce'
  }
});

// Database types
export interface Database {
  public: {
    Tables: {
      categories: {
        Row: {
          id: string;
          name: string;
          slug: string;
          created_at: string | null;
        };
      };
      products: {
        Row: {
          id: string;
          category_id: string;
          name: string;
          slug: string;
          description: string | null;
          unit: string | null;
          list_price: number;
          active: boolean | null;
          created_at: string | null;
        };
      };
      product_images: {
        Row: {
          id: string;
          product_id: string;
          url: string;
          alt: string | null;
          sort: number | null;
          created_at: string | null;
        };
      };
    };
  };
}

// Type exports for use in components
export type Category = Database['public']['Tables']['categories']['Row'];
export type Product = Database['public']['Tables']['products']['Row'];
export type ProductImage = Database['public']['Tables']['product_images']['Row'];