import { useState, useEffect } from 'react';
import { getProducts, type ProductsResponse, type ProductFilters } from '../services/products';
import type { ProductWithImages } from '../services/products';

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

export function useProducts(filters: ProductFilters = {}) {
  const [products, setProducts] = useState<ProductsResponse>({ data: [], count: 0 });
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;

    const fetchProducts = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('products:fetch:start', filters);
        const data = await getProducts(filters);
        console.debug('products:fetch:ok', data.data.length);
        if (isMounted) {
          setProducts(data);
        }
      } catch (err) {
        console.debug('products:fetch:fallback', err);
        if (isMounted) {
          // Apply filters to fallback products
          let filteredProducts = [...FALLBACK_PRODUCTS];
          
          if (filters.categorySlug) {
            filteredProducts = filteredProducts.filter(p => p.category.slug === filters.categorySlug);
          }
          
          if (filters.search) {
            filteredProducts = filteredProducts.filter(p => 
              p.name.toLowerCase().includes(filters.search!.toLowerCase())
            );
          }
          
          // Apply pagination
          const limit = filters.limit || 12;
          const page = filters.page || 1;
          const start = (page - 1) * limit;
          const paginatedProducts = filteredProducts.slice(start, start + limit);
          
          setProducts({
            data: paginatedProducts,
            count: filteredProducts.length
          });
          setError(null); // Don't show error since we have fallback
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchProducts();

    return () => {
      isMounted = false;
    };
  }, [filters.categorySlug, filters.search, filters.page, filters.limit]);

  return { ...products, isLoading, error };
}