import { supabase, type Product, type ProductImage, type Category } from '../lib/supabase';

// Fallback products when Supabase is not available
const FALLBACK_PRODUCTS: ProductWithImages[] = [
  {
    id: '1',
    category_id: '1',
    name: 'Detergente Multiusos Profesional',
    slug: 'detergente-multiusos-profesional',
    description: 'Detergente concentrado ideal para limpieza general en espacios comerciales y residenciales. Fórmula biodegradable y de alta efectividad.',
    unit: 'Galón',
    list_price: 25000,
    active: true,
    created_at: new Date().toISOString(),
    images: [
      { 
        id: '1', 
        url: 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800', 
        alt: 'Detergente Multiusos', 
        sort: 0 
      }
    ],
    category: { id: '1', name: 'Hogar', slug: 'hogar', created_at: new Date().toISOString() }
  },
  {
    id: '2',
    category_id: '2', 
    name: 'Desinfectante Hospitalario',
    slug: 'desinfectante-hospitalario',
    description: 'Desinfectante de grado hospitalario, elimina 99.9% de bacterias y virus. Ideal para centros de salud y espacios que requieren alta desinfección.',
    unit: 'Litro',
    list_price: 35000,
    active: true,
    created_at: new Date().toISOString(),
    images: [
      { 
        id: '2', 
        url: 'https://images.pexels.com/photos/5729023/pexels-photo-5729023.jpeg?auto=compress&cs=tinysrgb&w=800', 
        alt: 'Desinfectante Hospitalario', 
        sort: 0 
      }
    ],
    category: { id: '2', name: 'Hospitales y Clínicas', slug: 'hospitales-clinicas', created_at: new Date().toISOString() }
  },
  {
    id: '3',
    category_id: '3',
    name: 'Desengrasante Cocina Industrial',
    slug: 'desengrasante-cocina-industrial',
    description: 'Potente desengrasante formulado especialmente para cocinas comerciales. Remueve grasa carbonizada y residuos difíciles.',
    unit: 'Galón',
    list_price: 28000,
    active: true,
    created_at: new Date().toISOString(),
    images: [
      { 
        id: '3', 
        url: 'https://images.pexels.com/photos/4207707/pexels-photo-4207707.jpeg?auto=compress&cs=tinysrgb&w=800', 
        alt: 'Desengrasante Cocina Industrial', 
        sort: 0 
      }
    ],
    category: { id: '3', name: 'Cocinas y Restaurantes', slug: 'cocinas-restaurantes', created_at: new Date().toISOString() }
  }
];

export interface ProductWithImages extends Product {
  images: ProductImage[];
  category: Category;
}

export interface ProductsResponse {
  data: ProductWithImages[];
  count: number;
}

export interface ProductFilters {
  categorySlug?: string;
  search?: string;
  page?: number;
  limit?: number;
}

export async function getProducts(filters: ProductFilters = {}): Promise<ProductsResponse> {
  const { categorySlug, search, page = 1, limit = 12 } = filters;
  
  try {
    const from = (page - 1) * limit;
    const to = from + limit - 1;

    let query = supabase
      .from('products')
      .select(`
        *,
        categories!inner(id, name, slug),
        product_images(id, url, alt, sort)
      `, { count: 'exact' })
      .eq('active', true)
      .order('created_at', { ascending: false });

    // Apply category filter
    if (categorySlug) {
      query = query.eq('categories.slug', categorySlug);
    }

    // Apply search filter
    if (search) {
      query = query.ilike('name', `%${search}%`);
    }

    // Apply pagination
    query = query.range(from, to);

    const { data, error, count } = await query;

    if (error) {
      return applyFiltersToFallback(filters);
    }

    // Transform the data to match our interface
    const transformedData: ProductWithImages[] = (data || []).map(item => ({
      id: item.id,
      category_id: item.category_id,
      name: item.name,
      slug: item.slug,
      description: item.description,
      unit: item.unit,
      list_price: item.list_price,
      active: item.active,
      created_at: item.created_at,
      images: (item.product_images || []).sort((a, b) => (a.sort || 0) - (b.sort || 0)),
      category: item.categories
    }));

    return {
      data: transformedData,
      count: count || 0
    };
  } catch (error) {
    return applyFiltersToFallback(filters);
  }
}

function applyFiltersToFallback(filters: ProductFilters): ProductsResponse {
  const { categorySlug, search, page = 1, limit = 12 } = filters;
  let filteredProducts = [...FALLBACK_PRODUCTS];
  
  if (categorySlug) {
    filteredProducts = filteredProducts.filter(p => p.category.slug === categorySlug);
  }
  
  if (search) {
    filteredProducts = filteredProducts.filter(p => 
      p.name.toLowerCase().includes(search.toLowerCase())
    );
  }
  
  // Apply pagination
  const start = (page - 1) * limit;
  const paginatedProducts = filteredProducts.slice(start, start + limit);
  
  return {
    data: paginatedProducts,
    count: filteredProducts.length
  };
}

export async function getProductBySlug(slug: string): Promise<ProductWithImages | null> {
  try {
    const { data, error } = await supabase
      .from('products')
      .select(`
        *,
        categories!inner(id, name, slug),
        product_images(id, url, alt, sort)
      `)
      .eq('slug', slug)
      .eq('active', true)
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        return null; // Product not found
      }
      // Use fallback
      return FALLBACK_PRODUCTS.find(p => p.slug === slug) || null;
    }

    // Transform the data to match our interface
    return {
      id: data.id,
      category_id: data.category_id,
      name: data.name,
      slug: data.slug,
      description: data.description,
      unit: data.unit,
      list_price: data.list_price,
      active: data.active,
      created_at: data.created_at,
      images: (data.product_images || []).sort((a, b) => (a.sort || 0) - (b.sort || 0)),
      category: data.categories
    };
  } catch (error) {
    // Use fallback
    return FALLBACK_PRODUCTS.find(p => p.slug === slug) || null;
  }
}

export async function getRelatedProducts(categoryId: string, excludeId: string, limit: number = 4): Promise<ProductWithImages[]> {
  try {
    const { data, error } = await supabase
      .from('products')
      .select(`
        *,
        categories!inner(id, name, slug),
        product_images(id, url, alt, sort)
      `)
      .eq('category_id', categoryId)
      .eq('active', true)
      .neq('id', excludeId)
      .limit(limit)
      .order('created_at', { ascending: false });

    if (error) {
      // Use fallback
      return FALLBACK_PRODUCTS
        .filter(p => p.category_id === categoryId && p.id !== excludeId)
        .slice(0, limit);
    }

    // Transform the data to match our interface
    return (data || []).map(item => ({
      id: item.id,
      category_id: item.category_id,
      name: item.name,
      slug: item.slug,
      description: item.description,
      unit: item.unit,
      list_price: item.list_price,
      active: item.active,
      created_at: item.created_at,
      images: (item.product_images || []).sort((a, b) => (a.sort || 0) - (b.sort || 0)),
      category: item.categories
    }));
  } catch (error) {
    // Use fallback
    return FALLBACK_PRODUCTS
      .filter(p => p.category_id === categoryId && p.id !== excludeId)
      .slice(0, limit);
  }
}