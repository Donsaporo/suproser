import { useState, useEffect } from 'react';
import { getCategories } from '../services/categories';
import type { Category } from '../lib/supabase';

// Fallback categories in case Supabase is not available
const FALLBACK_CATEGORIES: Category[] = [
  { id: '1', name: 'Hogar', slug: 'hogar', created_at: new Date().toISOString() },
  { id: '2', name: 'Hospitales y Clínicas', slug: 'hospitales-clinicas', created_at: new Date().toISOString() },
  { id: '3', name: 'Cocinas y Restaurantes', slug: 'cocinas-restaurantes', created_at: new Date().toISOString() },
  { id: '4', name: 'Escuelas/Gimnasios', slug: 'escuelas-gimnasios', created_at: new Date().toISOString() },
];

export function useCategories() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;

    const fetchCategories = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('categories:fetch:start');
        const data = await getCategories();
        console.debug('categories:fetch:ok', data.length);
        if (isMounted) {
          setCategories(data);
        }
      } catch (err) {
        console.error('categories:fetch:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading categories');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchCategories();

    return () => {
      isMounted = false;
    };
  }, []);

  return { categories, isLoading, error };
}