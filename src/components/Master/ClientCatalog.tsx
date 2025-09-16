import React, { useState, useEffect } from 'react';
import { Search, Filter, Plus } from 'lucide-react';
import { useCategories } from '../../hooks/useCategories';
import { getProducts } from '../../services/products';
import { getEffectivePrices } from '../../services/orders';
import type { ProductWithImages } from '../../services/products';
import { formatPrice } from '../../utils/format';
import LoadingSpinner from '../UI/LoadingSpinner';

interface ClientCatalogProps {
  clientId: string;
  onAddToOrder: (product: ProductWithImages & { effectivePrice: number }, quantity: number) => void;
}

interface ProductWithPrice extends ProductWithImages {
  effectivePrice: number;
}

export default function ClientCatalog({ clientId, onAddToOrder }: ClientCatalogProps) {
  const [products, setProducts] = useState<ProductWithPrice[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalProducts, setTotalProducts] = useState(0);
  const [quantities, setQuantities] = useState<{[key: string]: number}>({});
  
  const { categories } = useCategories();
  const productsPerPage = 12;

  useEffect(() => {
    loadProducts();
  }, [clientId, searchQuery, selectedCategory, currentPage]);

  const loadProducts = async () => {
    if (!clientId) return;

    try {
      setIsLoading(true);
      setError(null);

      // Get products with pagination and filters
      const { data: productsData, count } = await getProducts({
        categorySlug: selectedCategory || undefined,
        search: searchQuery || undefined,
        page: currentPage,
        limit: productsPerPage
      });

      // Get effective prices for all products
      const productIds = productsData.map(p => p.id);
      const effectivePrices = await getEffectivePrices(clientId, productIds);
      
      // Create price lookup map
      const priceMap = new Map(
        effectivePrices.map(ep => [ep.product_id, ep.effective_price])
      );

      // Combine products with effective prices
      const productsWithPrices: ProductWithPrice[] = productsData.map(product => ({
        ...product,
        effectivePrice: priceMap.get(product.id) || product.list_price
      }));

      setProducts(productsWithPrices);
      setTotalProducts(count);
    } catch (err) {
      console.error('Error loading client catalog:', err);
      setError(err instanceof Error ? err.message : 'Error loading catalog');
    } finally {
      setIsLoading(false);
    }
  };

  const handleQuantityChange = (productId: string, quantity: number) => {
    setQuantities(prev => ({
      ...prev,
      [productId]: Math.max(1, quantity)
    }));
  };

  const handleAddProduct = (product: ProductWithPrice) => {
    const quantity = quantities[product.id] || 1;
    onAddToOrder(product, quantity);
    // Reset quantity after adding
    setQuantities(prev => ({
      ...prev,
      [product.id]: 1
    }));
  };

  const totalPages = Math.ceil(totalProducts / productsPerPage);

  return (
    <div className="space-y-6">
      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Buscar productos
            </label>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <input
                type="text"
                placeholder="Buscar por nombre..."
                value={searchQuery}
                onChange={(e) => {
                  setSearchQuery(e.target.value);
                  setCurrentPage(1);
                }}
                className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Categoría
            </label>
            <select
              value={selectedCategory}
              onChange={(e) => {
                setSelectedCategory(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todas las categorías</option>
              {categories.map((category) => (
                <option key={category.id} value={category.slug}>
                  {category.name}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Products Grid */}
      {isLoading ? (
        <div className="flex justify-center py-12">
          <LoadingSpinner size="lg" />
        </div>
      ) : error ? (
        <div className="text-center py-12 bg-white rounded-lg shadow-md">
          <div className="text-red-400 mb-4">
            <Filter className="h-16 w-16 mx-auto" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar catálogo</h3>
          <p className="text-gray-600 mb-4">{error}</p>
          <button
            onClick={loadProducts}
            className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
          >
            Intentar de nuevo
          </button>
        </div>
      ) : products.length > 0 ? (
        <>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6" data-testid="product-grid">
            {products.map((product) => {
              const quantity = quantities[product.id] || 1;
              const primaryImage = product.images?.[0]?.url || 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800';
              
              return (
                <div key={product.id} className="bg-white rounded-lg shadow-md overflow-hidden">
                  <div className="aspect-square overflow-hidden">
                    <img
                      src={primaryImage}
                      alt={product.name}
                      className="w-full h-full object-cover"
                      loading="lazy"
                    />
                  </div>
                  
                  <div className="p-4">
                    <h3 className="font-semibold text-gray-900 mb-2 line-clamp-2">
                      {product.name}
                    </h3>
                    
                    <div className="mb-3">
                      <span className="text-lg font-bold text-blue-600">
                        {formatPrice(product.effectivePrice)}
                      </span>
                      <span className="text-sm text-gray-500 ml-1">
                        / {product.unit || 'Unidad'}
                      </span>
                      {product.effectivePrice !== product.list_price && (
                        <div className="text-xs text-gray-400 line-through">
                          {formatPrice(product.list_price)}
                        </div>
                      )}
                    </div>
                    
                    <div className="flex items-center space-x-2">
                      <input
                        type="number"
                        min="1"
                        value={quantity}
                        onChange={(e) => handleQuantityChange(product.id, parseInt(e.target.value) || 1)}
                        className="w-16 border border-gray-300 rounded px-2 py-1 text-sm focus:ring-1 focus:ring-blue-500 focus:border-transparent"
                      />
                      <button
                        onClick={() => handleAddProduct(product)}
                        className="flex-1 bg-blue-600 text-white px-3 py-1 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center justify-center space-x-1 text-sm"
                      >
                        <Plus className="h-4 w-4" />
                        <span>Agregar</span>
                      </button>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          {/* Pagination */}
          {totalPages > 1 && (
            <div className="flex justify-center items-center space-x-2">
              <button
                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                disabled={currentPage === 1}
                className="px-4 py-2 rounded-md border border-gray-300 text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
              >
                Anterior
              </button>
              
              {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                <button
                  key={page}
                  onClick={() => setCurrentPage(page)}
                  className={`px-4 py-2 rounded-md transition-colors duration-200 ${
                    currentPage === page
                      ? 'bg-blue-600 text-white'
                      : 'border border-gray-300 text-gray-700 hover:bg-gray-50'
                  }`}
                >
                  {page}
                </button>
              ))}
              
              <button
                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                disabled={currentPage === totalPages}
                className="px-4 py-2 rounded-md border border-gray-300 text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors duration-200"
              >
                Siguiente
              </button>
            </div>
          )}
        </>
      ) : (
        <div className="text-center py-12 bg-white rounded-lg shadow-md">
          <div className="text-gray-400 mb-4">
            <Filter className="h-16 w-16 mx-auto" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">No se encontraron productos</h3>
          <p className="text-gray-600">Intenta ajustar los filtros de búsqueda</p>
        </div>
      )}
    </div>
  );
}