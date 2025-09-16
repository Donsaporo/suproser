import React from 'react';
import { Link } from 'react-router-dom';
import { ShoppingCart } from 'lucide-react';
import type { ProductWithImages } from '../../services/products';
import { useCart } from '../../hooks/useCart';
import { formatPrice } from '../../utils/format';
import { showSuccess, showError } from '../../utils/toast';

interface ProductCardProps {
  product: ProductWithImages;
  showAddToCart?: boolean;
}

export default function ProductCard({ product, showAddToCart = true }: ProductCardProps) {
  const { addItem } = useCart();

  // Get the first image or use a placeholder
  const primaryImage = product.images?.[0]?.url || 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800';
  const imageAlt = product.images?.[0]?.alt || product.name;

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    
    try {
      console.debug('ProductCard: Adding to cart', product.name);
      
      // Convert to the format expected by the cart
      const cartProduct = {
        id: product.id,
        slug: product.slug,
        name: product.name,
        description: product.description || '',
        price: product.list_price,
        unit: product.unit || 'Unidad',
        image: primaryImage,
        images: product.images?.map(img => img.url) || [primaryImage],
        category: product.category.slug,
        featured: false
      };
      
      console.debug('ProductCard: Calling addItem', cartProduct);
      const success = addItem(cartProduct);
      
      console.debug('ProductCard: addItem result:', success);
      
      if (success === true) {
        console.debug('ProductCard: Showing success toast');
        showSuccess('Producto agregado', `${product.name} agregado al carrito`);
      } else {
        console.error('ProductCard: addItem failed');
        showError('Error', 'No se pudo agregar el producto al carrito');
      }
    } catch (error) {
      console.error('Error adding to cart:', error);
      showError('Error', 'No se pudo agregar el producto al carrito');
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-all duration-300 group">
      <Link to={`/productos/${product.slug}`}>
        <div className="aspect-square overflow-hidden">
          <img
            src={primaryImage}
            alt={imageAlt}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
            loading="lazy"
          />
        </div>
        
        <div className="p-4">
          <h3 className="font-semibold text-gray-900 mb-2 line-clamp-2 group-hover:text-blue-600 transition-colors duration-200">
            {product.name}
          </h3>
          
          <p className="text-sm text-gray-600 mb-3 line-clamp-2">
            {product.description}
          </p>
          
          <div className="flex items-center justify-between">
            <div>
              <span className="text-lg font-bold text-blue-600">
                {formatPrice(product.list_price)}
              </span>
              <span className="text-sm text-gray-500 ml-1">
                / {product.unit || 'Unidad'}
              </span>
            </div>
            
            {showAddToCart && (
              <button
                onClick={handleAddToCart}
                className="bg-blue-600 text-white p-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
                title="Agregar al carrito"
              >
                <ShoppingCart className="h-4 w-4" />
              </button>
            )}
          </div>
        </div>
      </Link>
    </div>
  );
}