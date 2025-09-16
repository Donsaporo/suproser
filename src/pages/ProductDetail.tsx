import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, Plus, Minus, ShoppingCart } from 'lucide-react';
import { useProduct } from '../hooks/useProduct';
import { useCart } from '../hooks/useCart';
import ProductCard from '../components/UI/ProductCard';
import LoadingSpinner from '../components/UI/LoadingSpinner';
import { formatPrice } from '../utils/format';
import { showSuccess, showError } from '../utils/toast';

export default function ProductDetail() {
  const { slug } = useParams<{ slug: string }>();
  const { product, relatedProducts, isLoading, error } = useProduct(slug!);
  const [selectedImage, setSelectedImage] = useState(0);
  const [quantity, setQuantity] = useState(1);
  const { addItem } = useCart();

  useEffect(() => {
    if (product && product.images.length > 0) {
      setSelectedImage(0);
    }
  }, [product]);

  useEffect(() => {
    // Update page title with product name
    if (product) {
      document.title = `${product.name} - SUPROSER`;
    }
    return () => {
      document.title = 'SUPROSER B2B Website Framework';
    };
  }, [product]);

  if (isLoading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-center items-center h-64">
          <LoadingSpinner size="lg" />
        </div>
      </div>
    );
  }

  if (error || !product) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            {error === 'Product not found' ? 'Producto no encontrado' : 'Error al cargar el producto'}
          </h1>
          <p className="text-gray-600 mb-6">{error}</p>
          <Link
            to="/productos"
            className="text-blue-600 hover:text-blue-700 transition-colors duration-200"
          >
            Volver al catálogo
          </Link>
        </div>
      </div>
    );
  }

  // Use first image or placeholder if no images
  const images = product.images.length > 0 ? product.images : [
    { 
      url: 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800',
      alt: product.name 
    }
  ];

  const handleAddToCart = () => {
    try {
      console.log('ProductDetail: Adding to cart', { name: product.name, quantity });
      
      // Convert to cart format
      const cartProduct = {
        id: product.id,
        slug: product.slug,
        name: product.name,
        description: product.description || '',
        price: product.list_price,
        unit: product.unit || 'Unidad',
        image: images[selectedImage]?.url || images[0].url,
        images: images.map(img => img.url),
        category: product.category.slug,
        featured: false
      };
      
      console.log('ProductDetail: Calling addItem', { cartProduct, quantity });
      const success = addItem(cartProduct, quantity);
      
      console.log('ProductDetail: addItem result:', success);
      
      if (success === true) {
        console.log('ProductDetail: Showing success toast');
        setQuantity(1);
        showSuccess(
          'Producto agregado',
          `${quantity} x ${product.name} agregado al carrito`
        );
      } else {
        console.error('ProductDetail: addItem failed');
        showError('Error', 'No se pudo agregar el producto al carrito');
      }
    } catch (error) {
      console.error('Error adding to cart:', error);
      showError('Error', 'No se pudo agregar el producto al carrito');
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Breadcrumb */}
      <div className="mb-8">
        <Link
          to="/productos"
          className="inline-flex items-center text-blue-600 hover:text-blue-700 transition-colors duration-200"
        >
          <ArrowLeft className="h-4 w-4 mr-2" />
          Volver al catálogo
        </Link>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-12">
        {/* Image Gallery */}
        <div className="space-y-4">
          <div className="aspect-square overflow-hidden rounded-lg bg-gray-100">
            <img
              src={images[selectedImage]?.url || images[0].url}
              alt={images[selectedImage]?.alt || product.name}
              className="w-full h-full object-cover"
              loading="lazy"
            />
          </div>
          
          {images.length > 1 && (
            <div className="grid grid-cols-4 gap-4">
              {images.map((image, index) => (
                <button
                  key={index}
                  onClick={() => setSelectedImage(index)}
                  className={`aspect-square rounded-lg overflow-hidden border-2 transition-all duration-200 ${
                    selectedImage === index
                      ? 'border-blue-600 ring-2 ring-blue-200'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <img
                    src={image.url}
                    alt={image.alt || `${product.name} - Vista ${index + 1}`}
                    className="w-full h-full object-cover"
                    loading="lazy"
                  />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Product Info */}
        <div className="space-y-6">
          <div>
            <div className="mb-2">
              <Link 
                to={`/productos?categoria=${product.category.slug}`}
                className="text-sm text-blue-600 hover:text-blue-700 transition-colors duration-200"
              >
                {product.category.name}
              </Link>
            </div>
            <h1 className="text-3xl font-bold text-gray-900 mb-4">{product.name}</h1>
            {product.description && (
              <p className="text-lg text-gray-600 leading-relaxed">{product.description}</p>
            )}
          </div>

          <div className="border-t border-gray-200 pt-6">
            <div className="flex items-center space-x-4 mb-6">
              <span className="text-3xl font-bold text-blue-600">
                {formatPrice(product.list_price)}
              </span>
              <span className="text-lg text-gray-500">/ {product.unit || 'Unidad'}</span>
            </div>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Cantidad
                </label>
                <div className="flex items-center space-x-3">
                  <button
                    onClick={() => setQuantity(Math.max(1, quantity - 1))}
                    className="p-2 border border-gray-300 rounded-md hover:bg-gray-50 transition-colors duration-200"
                  >
                    <Minus className="h-4 w-4" />
                  </button>
                  <span className="text-lg font-semibold w-12 text-center">{quantity}</span>
                  <button
                    onClick={() => setQuantity(quantity + 1)}
                    className="p-2 border border-gray-300 rounded-md hover:bg-gray-50 transition-colors duration-200"
                  >
                    <Plus className="h-4 w-4" />
                  </button>
                </div>
              </div>

              <button
                onClick={handleAddToCart}
                className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-blue-700 transition-all duration-200 flex items-center justify-center space-x-2"
              >
                <ShoppingCart className="h-5 w-5" />
                <span>Agregar al Carrito</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Related Products */}
      {relatedProducts.length > 0 && (
        <section className="mt-16">
          <h2 className="text-2xl font-bold text-gray-900 mb-8">También te puede interesar</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {relatedProducts.map((relatedProduct) => (
              <ProductCard key={relatedProduct.id} product={relatedProduct} />
            ))}
          </div>
        </section>
      )}
    </div>
  );
}