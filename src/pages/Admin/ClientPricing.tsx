import React, { useState, useEffect } from 'react';
import { DollarSign, Percent, Plus, Search, Edit, Trash2, Package, Building, AlertTriangle } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';

interface Product {
  id: string;
  name: string;
  list_price: number;
}

interface Client {
  id: string;
  name: string;
}

interface PriceOverride {
  id: string;
  client_id: string;
  product_id: string;
  discount_pct: number | null;
  custom_price: number | null;
  created_at: string;
  clients: { name: string };
  products: { name: string; list_price: number };
}

interface EffectivePrice {
  product_id: string;
  client_id: string;
  effective_price: number;
}

interface OverrideFormData {
  client_id: string;
  product_id: string;
  override_type: 'discount' | 'custom';
  discount_pct: number;
  custom_price: number;
  new_client_name: string;
}

export default function AdminClientPricing() {
  const [activeTab, setActiveTab] = useState<'by-product' | 'by-client'>('by-product');
  const [products, setProducts] = useState<Product[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [priceOverrides, setPriceOverrides] = useState<PriceOverride[]>([]);
  const [effectivePrices, setEffectivePrices] = useState<EffectivePrice[]>([]);
  
  // Loading states
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  // Error states
  const [error, setError] = useState<string | null>(null);
  
  // Filters
  const [selectedProduct, setSelectedProduct] = useState('');
  const [selectedClient, setSelectedClient] = useState('');
  const [productSearch, setProductSearch] = useState('');
  const [clientSearch, setClientSearch] = useState('');
  
  // Modal states
  const [showModal, setShowModal] = useState(false);
  const [editingOverride, setEditingOverride] = useState<PriceOverride | null>(null);
  const [formData, setFormData] = useState<OverrideFormData>({
    client_id: '',
    product_id: '',
    override_type: 'discount',
    discount_pct: 0,
    custom_price: 0,
    new_client_name: ''
  });

  useEffect(() => {
    let isMounted = true;

    const fetchInitialData = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:precios:fetch:start');
        
        const data = await loadAllData();
        console.debug('admin:precios:fetch:ok', `products:${data.products.length} clients:${data.clients.length} overrides:${data.overrides.length}`);
        
        if (isMounted) {
          setProducts(data.products);
          setClients(data.clients);
          setPriceOverrides(data.overrides);
          setEffectivePrices(data.effectivePrices);
        }
      } catch (err) {
        console.error('admin:precios:fetch:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading pricing data');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchInitialData();

    return () => {
      isMounted = false;
    };
  }, []);

  const loadAllData = async () => {
    const [productsResult, clientsResult, overridesResult, effectivePricesResult] = await Promise.all([
      // Load active products
      supabase
        .from('products')
        .select('id, name, list_price')
        .eq('active', true)
        .order('name', { ascending: true }),
      
      // Load clients
      supabase
        .from('clients')
        .select('id, name')
        .order('name', { ascending: true }),
      
      // Load price overrides with relations
      supabase
        .from('price_overrides')
        .select(`
          *,
          clients!inner(name),
          products!inner(name, list_price)
        `)
        .order('created_at', { ascending: false }),
      
      // Load effective prices
      supabase
        .from('v_effective_prices')
        .select('*')
    ]);

    if (productsResult.error) throw productsResult.error;
    if (clientsResult.error) throw clientsResult.error;
    if (overridesResult.error) throw overridesResult.error;
    if (effectivePricesResult.error) throw effectivePricesResult.error;

    return {
      products: productsResult.data || [],
      clients: clientsResult.data || [],
      overrides: overridesResult.data || [],
      effectivePrices: effectivePricesResult.data || []
    };
  };

  const refreshData = async () => {
    try {
      console.debug('admin:precios:refresh:start');
      const data = await loadAllData();
      console.debug('admin:precios:refresh:ok', data.overrides.length);
      
      setProducts(data.products);
      setClients(data.clients);
      setPriceOverrides(data.overrides);
      setEffectivePrices(data.effectivePrices);
    } catch (err) {
      console.error('admin:precios:refresh:err', err);
      setError(err instanceof Error ? err.message : 'Error refreshing data');
    }
  };

  const openCreateModal = (productId?: string, clientId?: string) => {
    setEditingOverride(null);
    setFormData({
      client_id: clientId || '',
      product_id: productId || '',
      override_type: 'discount',
      discount_pct: 0,
      custom_price: 0,
      new_client_name: ''
    });
    setShowModal(true);
  };

  const openEditModal = (override: PriceOverride) => {
    setEditingOverride(override);
    setFormData({
      client_id: override.client_id,
      product_id: override.product_id,
      override_type: override.discount_pct !== null ? 'discount' : 'custom',
      discount_pct: override.discount_pct || 0,
      custom_price: override.custom_price || 0,
      new_client_name: ''
    });
    setShowModal(true);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;

    // Validations
    if (!formData.product_id) {
      alert('Selecciona un producto');
      return;
    }

    let clientId = formData.client_id;

    // Create new client if needed
    if (!clientId && formData.new_client_name.trim()) {
      try {
        console.debug('admin:precios:create-client:start', formData.new_client_name);
        const { data: newClient, error: clientError } = await supabase
          .from('clients')
          .insert({
            name: formData.new_client_name.trim()
          })
          .select('id')
          .single();

        if (clientError) throw clientError;
        clientId = newClient.id;
        console.debug('admin:precios:create-client:ok', clientId);
      } catch (err) {
        console.error('admin:precios:create-client:err', err);
        alert('Error al crear el cliente');
        return;
      }
    }

    if (!clientId) {
      alert('Selecciona un cliente o crea uno nuevo');
      return;
    }

    if (formData.override_type === 'discount' && (formData.discount_pct < 0 || formData.discount_pct > 100)) {
      alert('El descuento debe estar entre 0% y 100%');
      return;
    }

    if (formData.override_type === 'custom' && formData.custom_price <= 0) {
      alert('El precio personalizado debe ser mayor a 0');
      return;
    }

    try {
      setIsSubmitting(true);
      console.debug('admin:precios:save:start', editingOverride ? 'edit' : 'create');

      const overrideData: any = {
        client_id: clientId,
        product_id: formData.product_id
      };

      if (formData.override_type === 'discount') {
        overrideData.discount_pct = formData.discount_pct;
        overrideData.custom_price = null;
      } else {
        overrideData.discount_pct = null;
        overrideData.custom_price = formData.custom_price;
      }

      if (editingOverride) {
        const { error } = await supabase
          .from('price_overrides')
          .update(overrideData)
          .eq('id', editingOverride.id);

        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('price_overrides')
          .insert([overrideData]);

        if (error) throw error;
      }

      console.debug('admin:precios:save:ok');
      setShowModal(false);
      setEditingOverride(null);
      await refreshData();

    } catch (error: any) {
      console.error('admin:precios:save:err', error);
      if (error.code === '23505') {
        alert('Ya existe un override de precio para este cliente y producto');
      } else {
        alert('Error al guardar: ' + error.message);
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('¿Estás seguro de que quieres eliminar este override?')) return;

    try {
      console.debug('admin:precios:delete:start', id);
      
      const { error } = await supabase
        .from('price_overrides')
        .delete()
        .eq('id', id);

      if (error) throw error;

      console.debug('admin:precios:delete:ok', id);
      await refreshData();
    } catch (error) {
      console.error('admin:precios:delete:err', error);
      alert('Error al eliminar el override');
    }
  };

  const getEffectivePrice = (clientId: string, productId: string) => {
    const effectivePrice = effectivePrices.find(
      ep => ep.client_id === clientId && ep.product_id === productId
    );
    return effectivePrice?.effective_price;
  };

  const getFilteredProducts = () => {
    if (!productSearch.trim()) return products;
    return products.filter(p => 
      p.name.toLowerCase().includes(productSearch.toLowerCase())
    );
  };

  const getFilteredClients = () => {
    if (!clientSearch.trim()) return clients;
    return clients.filter(c => 
      c.name.toLowerCase().includes(clientSearch.toLowerCase())
    );
  };

  const getProductOverrides = () => {
    if (!selectedProduct) return [];
    return priceOverrides.filter(po => po.product_id === selectedProduct);
  };

  const getClientOverrides = () => {
    if (!selectedClient) return [];
    return priceOverrides.filter(po => po.client_id === selectedClient);
  };

  const handleRetry = () => {
    window.location.reload();
  };

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <DollarSign className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar precios</h3>
        <p className="text-gray-600 mb-4">{error}</p>
        <button
          onClick={handleRetry}
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
          <h1 className="text-2xl font-bold text-gray-900">Precios por Cliente</h1>
          <p className="text-gray-600">Configura precios especiales y descuentos por cliente</p>
        </div>
      </div>

      {/* Loading State */}
      {isLoading ? (
        <div className="space-y-6">
          {[...Array(3)].map((_, i) => (
            <div key={i} className="bg-white rounded-lg shadow-md p-6 animate-pulse">
              <div className="h-6 bg-gray-200 rounded w-1/3 mb-4"></div>
              <div className="space-y-3">
                {[...Array(3)].map((_, j) => (
                  <div key={j} className="h-4 bg-gray-200 rounded"></div>
                ))}
              </div>
            </div>
          ))}
        </div>
      ) : (
        <>
          {/* Tabs */}
          <div className="border-b border-gray-200">
            <nav className="-mb-px flex space-x-8">
              <button
                onClick={() => setActiveTab('by-product')}
                className={`py-2 px-1 border-b-2 font-medium text-sm transition-colors duration-200 ${
                  activeTab === 'by-product'
                    ? 'border-blue-500 text-blue-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
              >
                <Package className="h-4 w-4 inline-block mr-2" />
                Por Producto
              </button>
              <button
                onClick={() => setActiveTab('by-client')}
                className={`py-2 px-1 border-b-2 font-medium text-sm transition-colors duration-200 ${
                  activeTab === 'by-client'
                    ? 'border-blue-500 text-blue-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
              >
                <Building className="h-4 w-4 inline-block mr-2" />
                Por Cliente
              </button>
            </nav>
          </div>

          {/* Tab Content */}
          {activeTab === 'by-product' && (
            <div className="space-y-6">
              {/* Product Selector */}
              <div className="bg-white rounded-lg shadow-md p-6">
                <div className="flex justify-between items-center mb-4">
                  <h2 className="text-lg font-medium text-gray-900">Seleccionar Producto</h2>
                  {selectedProduct && (
                    <button
                      onClick={() => openCreateModal(selectedProduct)}
                      className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
                    >
                      <Plus className="h-4 w-4" />
                      <span>Agregar Override</span>
                    </button>
                  )}
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <div className="relative mb-4">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                      <input
                        type="text"
                        placeholder="Buscar productos..."
                        value={productSearch}
                        onChange={(e) => setProductSearch(e.target.value)}
                        className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>
                  </div>

                  <div>
                    <select
                      value={selectedProduct}
                      onChange={(e) => setSelectedProduct(e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Seleccionar producto...</option>
                      {getFilteredProducts().map((product) => (
                        <option key={product.id} value={product.id}>
                          {product.name} - {formatPrice(product.list_price)}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>
              </div>

              {/* Product Overrides */}
              {selectedProduct && (
                <div className="bg-white rounded-lg shadow-md p-6">
                  <h3 className="text-lg font-medium text-gray-900 mb-4">
                    Overrides para: {products.find(p => p.id === selectedProduct)?.name}
                  </h3>
                  
                  {getProductOverrides().length > 0 ? (
                    <div className="overflow-x-auto">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-50">
                          <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Cliente
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Precio Lista
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Override
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Precio Efectivo
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Acciones
                            </th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {getProductOverrides().map((override) => {
                            const effectivePrice = getEffectivePrice(override.client_id, override.product_id);
                            return (
                              <tr key={override.id} className="hover:bg-gray-50">
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                  {override.clients.name}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                  {formatPrice(override.products.list_price)}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm">
                                  {override.discount_pct !== null ? (
                                    <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full">
                                      -{override.discount_pct}%
                                    </span>
                                  ) : (
                                    <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                                      {formatPrice(override.custom_price || 0)}
                                    </span>
                                  )}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">
                                  {effectivePrice ? formatPrice(effectivePrice) : 'Calculando...'}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                  <button
                                    onClick={() => openEditModal(override)}
                                    className="text-indigo-600 hover:text-indigo-900"
                                  >
                                    <Edit className="h-4 w-4" />
                                  </button>
                                  <button
                                    onClick={() => handleDelete(override.id)}
                                    className="text-red-600 hover:text-red-900"
                                  >
                                    <Trash2 className="h-4 w-4" />
                                  </button>
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  ) : (
                    <div className="text-center py-12 text-gray-500">
                      <Percent className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                      <p>No hay overrides para este producto</p>
                      <button
                        onClick={() => openCreateModal(selectedProduct)}
                        className="text-blue-600 hover:text-blue-700 text-sm mt-2"
                      >
                        Crear primer override
                      </button>
                    </div>
                  )}
                </div>
              )}
            </div>
          )}

          {activeTab === 'by-client' && (
            <div className="space-y-6">
              {/* Client Selector */}
              <div className="bg-white rounded-lg shadow-md p-6">
                <div className="flex justify-between items-center mb-4">
                  <h2 className="text-lg font-medium text-gray-900">Seleccionar Cliente</h2>
                  {selectedClient && (
                    <button
                      onClick={() => openCreateModal(undefined, selectedClient)}
                      className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
                    >
                      <Plus className="h-4 w-4" />
                      <span>Agregar Override</span>
                    </button>
                  )}
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <div className="relative mb-4">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                      <input
                        type="text"
                        placeholder="Buscar clientes..."
                        value={clientSearch}
                        onChange={(e) => setClientSearch(e.target.value)}
                        className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                    </div>
                  </div>

                  <div>
                    <select
                      value={selectedClient}
                      onChange={(e) => setSelectedClient(e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Seleccionar cliente...</option>
                      {getFilteredClients().map((client) => (
                        <option key={client.id} value={client.id}>
                          {client.name}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>
              </div>

              {/* Client Overrides */}
              {selectedClient && (
                <div className="bg-white rounded-lg shadow-md p-6">
                  <h3 className="text-lg font-medium text-gray-900 mb-4">
                    Overrides para: {clients.find(c => c.id === selectedClient)?.name}
                  </h3>
                  
                  {getClientOverrides().length > 0 ? (
                    <div className="overflow-x-auto">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-50">
                          <tr>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Producto
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Precio Lista
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Override
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Precio Efectivo
                            </th>
                            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Acciones
                            </th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {getClientOverrides().map((override) => {
                            const effectivePrice = getEffectivePrice(override.client_id, override.product_id);
                            return (
                              <tr key={override.id} className="hover:bg-gray-50">
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                                  {override.products.name}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                  {formatPrice(override.products.list_price)}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm">
                                  {override.discount_pct !== null ? (
                                    <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full">
                                      -{override.discount_pct}%
                                    </span>
                                  ) : (
                                    <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                                      {formatPrice(override.custom_price || 0)}
                                    </span>
                                  )}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">
                                  {effectivePrice ? formatPrice(effectivePrice) : 'Calculando...'}
                                </td>
                                <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                                  <button
                                    onClick={() => openEditModal(override)}
                                    className="text-indigo-600 hover:text-indigo-900"
                                  >
                                    <Edit className="h-4 w-4" />
                                  </button>
                                  <button
                                    onClick={() => handleDelete(override.id)}
                                    className="text-red-600 hover:text-red-900"
                                  >
                                    <Trash2 className="h-4 w-4" />
                                  </button>
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  ) : (
                    <div className="text-center py-12 text-gray-500">
                      <DollarSign className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                      <p>No hay overrides para este cliente</p>
                      <button
                        onClick={() => openCreateModal(undefined, selectedClient)}
                        className="text-blue-600 hover:text-blue-700 text-sm mt-2"
                      >
                        Crear primer override
                      </button>
                    </div>
                  )}
                </div>
              )}
            </div>
          )}
        </>
      )}

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">
                {editingOverride ? 'Editar Override' : 'Nuevo Override'}
              </h3>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              {/* Product Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Producto *
                </label>
                <select
                  value={formData.product_id}
                  onChange={(e) => setFormData({ ...formData, product_id: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                  disabled={!!editingOverride}
                >
                  <option value="">Seleccionar producto...</option>
                  {products.map((product) => (
                    <option key={product.id} value={product.id}>
                      {product.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Client Selection or Creation */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Cliente *
                </label>
                <select
                  value={formData.client_id}
                  onChange={(e) => setFormData({ ...formData, client_id: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent mb-2"
                  required={!formData.new_client_name}
                  disabled={!!editingOverride}
                >
                  <option value="">Seleccionar cliente...</option>
                  {clients.map((client) => (
                    <option key={client.id} value={client.id}>
                      {client.name}
                    </option>
                  ))}
                </select>
                
                {!editingOverride && (
                  <div>
                    <p className="text-sm text-gray-500 mb-2">O crear cliente nuevo:</p>
                    <input
                      type="text"
                      placeholder="Nombre del nuevo cliente"
                      value={formData.new_client_name}
                      onChange={(e) => setFormData({ ...formData, new_client_name: e.target.value, client_id: '' })}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                  </div>
                )}
              </div>

              {/* Override Type */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Tipo de Override *
                </label>
                <div className="space-y-3">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="discount"
                      checked={formData.override_type === 'discount'}
                      onChange={(e) => setFormData({ ...formData, override_type: e.target.value as 'discount' | 'custom' })}
                      className="mr-2"
                    />
                    <span className="text-sm">Descuento por porcentaje</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="custom"
                      checked={formData.override_type === 'custom'}
                      onChange={(e) => setFormData({ ...formData, override_type: e.target.value as 'discount' | 'custom' })}
                      className="mr-2"
                    />
                    <span className="text-sm">Precio personalizado</span>
                  </label>
                </div>
              </div>

              {/* Override Value */}
              {formData.override_type === 'discount' ? (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Descuento (%) *
                  </label>
                  <input
                    type="number"
                    min="0"
                    max="100"
                    step="0.01"
                    value={formData.discount_pct}
                    onChange={(e) => setFormData({ ...formData, discount_pct: parseFloat(e.target.value) || 0 })}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                    placeholder="0.00"
                  />
                  <p className="text-xs text-gray-500 mt-1">Porcentaje entre 0% y 100%</p>
                </div>
              ) : (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Precio Personalizado *
                  </label>
                  <input
                    type="number"
                    min="0"
                    step="0.01"
                    value={formData.custom_price}
                    onChange={(e) => setFormData({ ...formData, custom_price: parseFloat(e.target.value) || 0 })}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required
                    placeholder="0.00"
                  />
                </div>
              )}

              {/* Preview */}
              {formData.product_id && (
                <div className="bg-blue-50 p-4 rounded-lg">
                  <h4 className="text-sm font-medium text-blue-900 mb-2">Vista previa:</h4>
                  {(() => {
                    const product = products.find(p => p.id === formData.product_id);
                    if (!product) return null;
                    
                    const listPrice = product.list_price;
                    let previewPrice = listPrice;
                    
                    if (formData.override_type === 'discount' && formData.discount_pct > 0) {
                      previewPrice = listPrice * (1 - formData.discount_pct / 100);
                    } else if (formData.override_type === 'custom' && formData.custom_price > 0) {
                      previewPrice = formData.custom_price;
                    }
                    
                    return (
                      <div className="text-sm text-blue-800">
                        <p>Precio lista: {formatPrice(listPrice)}</p>
                        <p className="font-semibold">Precio efectivo: {formatPrice(previewPrice)}</p>
                        {previewPrice !== listPrice && (
                          <p className="text-green-700">
                            Ahorro: {formatPrice(listPrice - previewPrice)} 
                            ({(((listPrice - previewPrice) / listPrice) * 100).toFixed(1)}%)
                          </p>
                        )}
                      </div>
                    );
                  })()}
                </div>
              )}
              
              <div className="flex justify-end space-x-3 pt-4 border-t">
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
                  {isSubmitting && <LoadingSpinner size="sm" />}
                  <span>{isSubmitting ? 'Guardando...' : (editingOverride ? 'Actualizar' : 'Crear')}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}