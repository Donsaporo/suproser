import React, { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { Filter, Grid, List } from 'lucide-react';
import ProductCard from '../components/UI/ProductCard';
import LoadingSpinner from '../components/UI/LoadingSpinner';
import { useProducts } from '../hooks/useProducts';
import { useCategories } from '../hooks/useCategories';

export default function Products() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState(searchParams.get('categoria') || '');
  const [currentPage, setCurrentPage] = useState(1);
  const [viewMode, setViewMode] = useState<'grid' | 'list'>('grid');
  
  const productsPerPage = 12;

  // Fetch categories for filter dropdown
  const { categories, isLoading: categoriesLoading } = useCategories();
  
  // Fetch products with current filters
  const { data: products, count: totalProducts, isLoading: productsLoading, error } = useProducts({
    categorySlug: selectedCategory || undefined,
    search: searchQuery || undefined,
    page: currentPage,
    limit: productsPerPage
  });

  // Reset page when filters change
  useEffect(() => {
    setCurrentPage(1);
  }, [selectedCategory, searchQuery]);

  const totalPages = Math.ceil(totalProducts / productsPerPage);

  const handleCategoryChange = (category: string) => {
    setSelectedCategory(category);
    if (category) {
      setSearchParams({ categoria: category });
    } else {
      setSearchParams({});
    }
  };

  const handleSearchChange = (value: string) => {
    setSearchQuery(value);
    setCurrentPage(1);
  };

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Catálogo de Productos</h1>
        <p className="text-lg text-gray-600">Encuentra la solución perfecta para tus necesidades de limpieza.</p>
      </div>

      {/* Filters */}
      <div className="bg-white p-6 rounded-lg shadow-md mb-8">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between space-y-4 lg:space-y-0">
          <div className="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
            <div className="flex items-center space-x-2">
              <Filter className="h-5 w-5 text-gray-400" />
              <select
                value={selectedCategory}
                onChange={(e) => handleCategoryChange(e.target.value)}
                className="border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                disabled={categoriesLoading}
              >
                <option value="">Todas las categorías</option>
                {categoriesLoading ? (
                  <option disabled>Cargando...</option>
                ) : (
                  categories.map((category) => (
                    <option key={category.id} value={category.slug}>
                      {category.name}
                    </option>
                  ))
                )}
              </select>
            </div>
            
            <div className="flex-1 sm:max-w-xs">
              <input
                type="text"
                placeholder="Buscar productos..."
                value={searchQuery}
                onChange={(e) => handleSearchChange(e.target.value)}
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <button
              onClick={() => setViewMode('grid')}
              className={`p-2 rounded-md transition-colors duration-200 ${
                viewMode === 'grid' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:text-blue-600'
              }`}
            >
              <Grid className="h-5 w-5" />
            </button>
            <button
              onClick={() => setViewMode('list')}
              className={`p-2 rounded-md transition-colors duration-200 ${
                viewMode === 'list' ? 'bg-blue-600 text-white' : 'text-gray-600 hover:text-blue-600'
              }`}
            >
              <List className="h-5 w-5" />
            </button>
          </div>
        </div>
      </div>

      {/* Products Grid */}
      {productsLoading ? (
        <div className="flex justify-center py-12">
          <LoadingSpinner size="lg" />
        </div>
      ) : error ? (
        <div className="text-center py-12">
          <div className="text-red-400 mb-4">
            <Filter className="h-16 w-16 mx-auto" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar productos</h3>
          <p className="text-gray-600 mb-4">{error}</p>
          <button
            onClick={() => window.location.reload()}
            className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
          >
            Intentar de nuevo
          </button>
        </div>
      ) : products.length > 0 ? (
        <>
          <div className={`grid gap-6 mb-8 ${
            viewMode === 'grid' 
              ? 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4'
              : 'grid-cols-1'
          }`}>
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
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
        <div className="text-center py-12">
          <div className="text-gray-400 mb-4">
            <Filter className="h-16 w-16 mx-auto" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">No se encontraron productos</h3>
          <p className="text-gray-600 mb-4">Intenta ajustar los filtros o términos de búsqueda</p>
          <button
            onClick={() => {
              setSelectedCategory('');
              handleSearchChange('');
              setSearchParams({});
            }}
            className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
          >
            Limpiar Filtros
          </button>
        </div>
      )}
    </div>
  );
}