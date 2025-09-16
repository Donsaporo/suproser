import { useState, useEffect } from 'react';
import { getProductBySlug, getRelatedProducts, type ProductWithImages } from '../services/products';

export function useProduct(slug: string) {
  const [product, setProduct] = useState<ProductWithImages | null>(null);
  const [relatedProducts, setRelatedProducts] = useState<ProductWithImages[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let isMounted = true;

    const fetchProduct = async () => {
      if (!slug) return;

      try {
        setIsLoading(true);
        setError(null);
        
        const productData = await getProductBySlug(slug);
        
        if (isMounted) {
          if (!productData) {
            setError('Product not found');
            setProduct(null);
            setRelatedProducts([]);
          } else {
            setProduct(productData);
            
            // Fetch related products
            try {
              const relatedData = await getRelatedProducts(productData.category_id, productData.id);
              if (isMounted) {
                setRelatedProducts(relatedData);
              }
            } catch (relatedError) {
              console.error('Error fetching related products:', relatedError);
              // Don't set error state for related products failure
              setRelatedProducts([]);
            }
          }
        }
      } catch (err) {
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Failed to fetch product');
          console.error('Error fetching product:', err);
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchProduct();

    return () => {
      isMounted = false;
    };
  }, [slug]);

  return { product, relatedProducts, isLoading, error };
}