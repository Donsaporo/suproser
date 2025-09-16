import { supabase, type Category } from '../lib/supabase';

// Fallback categories in case Supabase is not available
const FALLBACK_CATEGORIES: Category[] = [
  { id: '1', name: 'Hogar', slug: 'hogar', created_at: new Date().toISOString() },
  { id: '2', name: 'Hospitales y Clínicas', slug: 'hospitales-clinicas', created_at: new Date().toISOString() },
  { id: '3', name: 'Cocinas y Restaurantes', slug: 'cocinas-restaurantes', created_at: new Date().toISOString() },
  { id: '4', name: 'Escuelas/Gimnasios', slug: 'escuelas-gimnasios', created_at: new Date().toISOString() },
];

export async function getCategories(): Promise<Category[]> {
  try {
    console.debug('categories:fetch:start');
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .order('name', { ascending: true });

    if (error) {
      console.debug('categories:fetch:fallback', error.code);
      return FALLBACK_CATEGORIES;
    }
    
    console.debug('categories:fetch:ok', data?.length || 0);

    return data || FALLBACK_CATEGORIES;
  } catch (error) {
    return FALLBACK_CATEGORIES;
  }
}

export async function getCategoryBySlug(slug: string): Promise<Category | null> {
  try {
    const { data, error } = await supabase
      .from('categories')
      .select('*')
      .eq('slug', slug)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return null; // Category not found
      }
      // Use fallback
      return FALLBACK_CATEGORIES.find(c => c.slug === slug) || null;
    }

    return data;
  } catch (error) {
    // Use fallback
    return FALLBACK_CATEGORIES.find(c => c.slug === slug) || null;
  }
}