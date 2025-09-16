import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Plus, Search, Filter, Edit, Trash2, Eye, X, Upload } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import { useCategories } from '../../hooks/useCategories';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';

interface Product {
  id: string;
  name: string;
  slug: string;
  description: string;
  unit: string;
  list_price: number;
  active: boolean;
  created_at: string;
  category_id: string;
  categories: {
    name: string;
  };
  product_images: Array<{
    id: string;
    url: string;
    alt: string | null;
    sort: number;
  }>;
}

interface ProductFormData {
  name: string;
  slug: string;
  description: string;
  unit: string;
  list_price: number;
  active: boolean;
  category_id: string;
  images: Array<{
    id?: string;
    url: string;
    alt: string;
    sort: number;
  }>;
}

export default function AdminProducts() {
  const [products, setProducts] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('');
  const [activeFilter, setActiveFilter] = useState<'all' | 'active' | 'inactive'>('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  
  // Modal states
  const [showModal, setShowModal] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [formData, setFormData] = useState<ProductFormData>({
    name: '',
    slug: '',
    description: '',
    unit: '',
    list_price: 0,
    active: true,
    category_id: '',
    images: []
  });
  
  const { categories } = useCategories();
  const productsPerPage = 10;

  useEffect(() => {
    let isMounted = true;

    const fetchProducts = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:productos:fetch:start', { searchQuery, selectedCategory, activeFilter, currentPage });
        
        const data = await loadProductsData();
        console.debug('admin:productos:fetch:ok', data.products.length);
        
        if (isMounted) {
          setProducts(data.products);
          setTotalCount(data.count);
        }
      } catch (error) {
        console.error('admin:productos:fetch:err', error);
        if (isMounted) {
          setError(error instanceof Error ? error.message : 'Error loading products');
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
  }, [searchQuery, selectedCategory, activeFilter, currentPage]);

  const loadProductsData = async () => {
    let query = supabase
      .from('products')
      .select(`
        id,
        name,
        slug,
        description,
        unit,
        list_price,
        active,
        created_at,
        category_id,
        categories!inner(name),
        product_images(id, url, alt, sort)
      `, { count: 'exact' })
      .order('created_at', { ascending: false });

    // Apply filters
    if (searchQuery) {
      query = query.ilike('name', `%${searchQuery}%`);
    }

    if (selectedCategory) {
      query = query.eq('category_id', selectedCategory);
    }

    if (activeFilter !== 'all') {
      query = query.eq('active', activeFilter === 'active');
    }

    // Apply pagination
    const from = (currentPage - 1) * productsPerPage;
    const to = from + productsPerPage - 1;
    query = query.range(from, to);

    const { data, error, count } = await query;

    if (error) throw error;

    return {
      products: data || [],
      count: count || 0
    };
  };

  const generateSlug = (name: string) => {
    return name
      .toLowerCase()
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-')
      .trim();
  };

  const resetForm = () => {
    setFormData({
      name: '',
      slug: '',
      description: '',
      unit: '',
      list_price: 0,
      active: true,
      category_id: '',
      images: []
    });
  };

  const openCreateModal = () => {
    setEditingProduct(null);
    resetForm();
    setShowModal(true);
  };

  const openEditModal = (product: Product) => {
    setEditingProduct(product);
    setFormData({
      name: product.name,
      slug: product.slug,
      description: product.description || '',
      unit: product.unit || '',
      list_price: product.list_price,
      active: product.active,
      category_id: product.category_id,
      images: product.product_images.map(img => ({
        id: img.id,
        url: img.url,
        alt: img.alt || '',
        sort: img.sort
      })).sort((a, b) => a.sort - b.sort)
    });
    setShowModal(true);
  };

  const handleFormChange = (field: keyof ProductFormData, value: any) => {
    setFormData(prev => {
      const updated = { ...prev, [field]: value };
      
      // Auto-generate slug from name
      if (field === 'name' && !editingProduct) {
        updated.slug = generateSlug(value);
      }
      
      return updated;
    });
  };

  const handleImageChange = (index: number, field: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      images: prev.images.map((img, i) => 
        i === index ? { ...img, [field]: value } : img
      )
    }));
  };

  const addImage = () => {
    setFormData(prev => ({
      ...prev,
      images: [...prev.images, { url: '', alt: '', sort: prev.images.length }]
    }));
  };

  const removeImage = (index: number) => {
    setFormData(prev => ({
      ...prev,
      images: prev.images.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;

    // Validations
    if (!formData.name.trim()) {
      alert('El nombre es obligatorio');
      return;
    }
    if (!formData.slug.trim()) {
      alert('El slug es obligatorio');
      return;
    }
    if (!formData.category_id) {
      alert('La categoría es obligatoria');
      return;
    }
    if (formData.list_price <= 0) {
      alert('El precio debe ser mayor a 0');
      return;
    }

    try {
      setIsSubmitting(true);
      console.debug('admin:productos:save:start', editingProduct ? 'edit' : 'create');

      const productData = {
        name: formData.name.trim(),
        slug: formData.slug.trim(),
        description: formData.description.trim() || null,
        unit: formData.unit.trim() || null,
        list_price: formData.list_price,
        active: formData.active,
        category_id: formData.category_id
      };

      let productId: string;

      if (editingProduct) {
        // Update existing product
        const { error } = await supabase
          .from('products')
          .update(productData)
          .eq('id', editingProduct.id);

        if (error) throw error;
        productId = editingProduct.id;
      } else {
        // Create new product
        const { data, error } = await supabase
          .from('products')
          .insert([productData])
          .select('id')
          .single();

        if (error) throw error;
        productId = data.id;
      }

      // Handle images
      if (editingProduct) {
        // Delete existing images
        await supabase
          .from('product_images')
          .delete()
          .eq('product_id', productId);
      }

      // Insert new images
      if (formData.images.length > 0) {
        const imageData = formData.images
          .filter(img => img.url.trim())
          .map((img, index) => ({
            product_id: productId,
            url: img.url.trim(),
            alt: img.alt.trim() || null,
            sort: index
          }));

        if (imageData.length > 0) {
          const { error: imageError } = await supabase
            .from('product_images')
            .insert(imageData);

          if (imageError) throw imageError;
        }
      }

      console.debug('admin:productos:save:ok', productId);
      setShowModal(false);
      setEditingProduct(null);
      resetForm();
      
      // Reload products
      const data = await loadProductsData();
      setProducts(data.products);
      setTotalCount(data.count);

    } catch (error: any) {
      console.error('admin:productos:save:err', error);
      if (error.code === '23505') {
        alert('Ya existe un producto con ese slug');
      } else {
        alert('Error al guardar el producto: ' + error.message);
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('¿Estás seguro de que quieres eliminar este producto?')) return;

    try {
      console.debug('admin:productos:delete:start', id);
      
      const { error } = await supabase
        .from('products')
        .delete()
        .eq('id', id);

      if (error) throw error;

      console.debug('admin:productos:delete:ok', id);
      
      // Reload products
      const data = await loadProductsData();
      setProducts(data.products);
      setTotalCount(data.count);
    } catch (error) {
      console.error('admin:productos:delete:err', error);
      alert('Error al eliminar el producto');
    }
  };

  const totalPages = Math.ceil(totalCount / productsPerPage);
  const firstImageUrl = (product: Product) => {
    const sortedImages = product.product_images.sort((a, b) => a.sort - b.sort);
    return sortedImages[0]?.url || 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=200';
  };

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <Filter className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar productos</h3>
        <p className="text-gray-600 mb-4">{error}</p>
        <button
          onClick={() => window.location.reload()}
          className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
        >
          Reintentar
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Gestión de Productos</h1>
          <p className="text-gray-600">Administra el catálogo de productos</p>
        </div>
        <button
          onClick={openCreateModal}
          className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
        >
          <Plus className="h-4 w-4" />
          <span>Nuevo Producto</span>
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Buscar
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
                <option key={category.id} value={category.id}>
                  {category.name}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Estado
            </label>
            <select
              value={activeFilter}
              onChange={(e) => {
                setActiveFilter(e.target.value as 'all' | 'active' | 'inactive');
                setCurrentPage(1);
              }}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="all">Todos</option>
              <option value="active">Activos</option>
              <option value="inactive">Inactivos</option>
            </select>
          </div>
        </div>
      </div>

      {/* Products Table */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        {isLoading ? (
          <div className="flex justify-center items-center h-64">
            <LoadingSpinner size="lg" />
          </div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Producto
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Categoría
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Precio
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Estado
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Acciones
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {products.map((product) => (
                    <tr key={product.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <img
                            src={firstImageUrl(product)}
                            alt={product.name}
                            className="h-12 w-12 rounded-lg object-cover mr-4"
                            loading="lazy"
                          />
                          <div>
                            <div className="text-sm font-medium text-gray-900">
                              {product.name}
                            </div>
                            <div className="text-sm text-gray-500">
                              {product.unit || 'Sin unidad'}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {product.categories.name}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {formatPrice(product.list_price)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          product.active
                            ? 'bg-green-100 text-green-800'
                            : 'bg-red-100 text-red-800'
                        }`}>
                          {product.active ? 'Activo' : 'Inactivo'}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                        <Link
                          to={`/productos/${product.slug}`}
                          className="text-blue-600 hover:text-blue-900 inline-flex items-center"
                          target="_blank"
                          title="Ver en tienda"
                        >
                          <Eye className="h-4 w-4" />
                        </Link>
                        <button
                          onClick={() => openEditModal(product)}
                          className="text-indigo-600 hover:text-indigo-900 inline-flex items-center"
                          title="Editar"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(product.id)}
                          className="text-red-600 hover:text-red-900 inline-flex items-center"
                          title="Eliminar"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
              <div className="bg-white px-4 py-3 border-t border-gray-200 sm:px-6">
                <div className="flex justify-between items-center">
                  <div className="text-sm text-gray-700">
                    Mostrando {(currentPage - 1) * productsPerPage + 1} a {Math.min(currentPage * productsPerPage, totalCount)} de {totalCount} productos
                  </div>
                  <div className="flex space-x-2">
                    <button
                      onClick={() => setCurrentPage(Math.max(currentPage - 1, 1))}
                      disabled={currentPage === 1}
                      className="px-3 py-1 border border-gray-300 rounded-md text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      Anterior
                    </button>
                    <button
                      onClick={() => setCurrentPage(Math.min(currentPage + 1, totalPages))}
                      disabled={currentPage === totalPages}
                      className="px-3 py-1 border border-gray-300 rounded-md text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      Siguiente
                    </button>
                  </div>
                </div>
              </div>
            )}

            {products.length === 0 && !isLoading && (
              <div className="text-center py-12">
                <div className="text-gray-400 mb-4">
                  <Filter className="h-16 w-16 mx-auto" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No se encontraron productos</h3>
                <p className="text-gray-600">Intenta ajustar los filtros de búsqueda</p>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
            <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-gray-900">
                {editingProduct ? 'Editar Producto' : 'Nuevo Producto'}
              </h3>
              <button
                onClick={() => setShowModal(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Nombre *
                  </label>
                  <input
                    type="text"
                    value={formData.name}
                    onChange={(e) => handleFormChange('name', e.target.value)}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Slug *
                  </label>
                  <input
                    type="text"
                    value={formData.slug}
                    onChange={(e) => handleFormChange('slug', e.target.value)}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Categoría *
                  </label>
                  <select
                    value={formData.category_id}
                    onChange={(e) => handleFormChange('category_id', e.target.value)}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                  >
                    <option value="">Seleccionar categoría</option>
                    {categories.map((category) => (
                      <option key={category.id} value={category.id}>
                        {category.name}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Unidad
                  </label>
                  <input
                    type="text"
                    value={formData.unit}
                    onChange={(e) => handleFormChange('unit', e.target.value)}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Ej: Galón, Litro, Unidad"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Precio *
                  </label>
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={formData.list_price}
                    onChange={(e) => handleFormChange('list_price', parseFloat(e.target.value) || 0)}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                  />
                </div>

                <div>
                  <label className="flex items-center">
                    <input
                      type="checkbox"
                      checked={formData.active}
                      onChange={(e) => handleFormChange('active', e.target.checked)}
                      className="mr-2"
                    />
                    <span className="text-sm font-medium text-gray-700">Activo</span>
                  </label>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Descripción
                </label>
                <textarea
                  value={formData.description}
                  onChange={(e) => handleFormChange('description', e.target.value)}
                  rows={4}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Descripción detallada del producto"
                />
              </div>

              {/* Images Section */}
              <div>
                <div className="flex justify-between items-center mb-4">
                  <label className="block text-sm font-medium text-gray-700">
                    Imágenes
                  </label>
                  <button
                    type="button"
                    onClick={addImage}
                    className="text-blue-600 hover:text-blue-700 text-sm flex items-center space-x-1"
                  >
                    <Upload className="h-4 w-4" />
                    <span>Agregar Imagen</span>
                  </button>
                </div>
                
                <div className="space-y-3">
                  {formData.images.map((image, index) => (
                    <div key={index} className="grid grid-cols-1 md:grid-cols-3 gap-3 p-4 border border-gray-200 rounded-lg">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          URL *
                        </label>
                        <input
                          type="url"
                          value={image.url}
                          onChange={(e) => handleImageChange(index, 'url', e.target.value)}
                          className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="https://example.com/image.jpg"
                        />
                      </div>
                      
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          Texto alternativo
                        </label>
                        <input
                          type="text"
                          value={image.alt}
                          onChange={(e) => handleImageChange(index, 'alt', e.target.value)}
                          className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                          placeholder="Descripción de la imagen"
                        />
                      </div>

                      <div className="flex items-end">
                        <button
                          type="button"
                          onClick={() => removeImage(index)}
                          className="text-red-600 hover:text-red-700 p-2"
                          title="Eliminar imagen"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    </div>
                  ))}
                  
                  {formData.images.length === 0 && (
                    <div className="text-center py-8 text-gray-500">
                      <Upload className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                      <p>No hay imágenes agregadas</p>
                      <button
                        type="button"
                        onClick={addImage}
                        className="text-blue-600 hover:text-blue-700 text-sm mt-2"
                      >
                        Agregar primera imagen
                      </button>
                    </div>
                  )}
                </div>
              </div>
              
              <div className="flex justify-end space-x-3 pt-6 border-t">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors duration-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 flex items-center space-x-2"
                >
                  {isSubmitting ? (
                    <>
                      <LoadingSpinner size="sm" />
                      <span>Guardando...</span>
                    </>
                  ) : (
                    <span>{editingProduct ? 'Actualizar' : 'Crear'}</span>
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}