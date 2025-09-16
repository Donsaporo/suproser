import React, { useState } from 'react';
import { ShoppingCart, Plus, Minus, Trash2, Package, ArrowLeft } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { createOrder, addOrderItem } from '../../services/orders';
import ClientCatalog from '../../components/Master/ClientCatalog';
import { formatPrice } from '../../utils/format';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { showSuccess, showError } from '../../utils/toast';

interface OrderItem {
  product_id: string;
  product_name: string;
  product_unit: string;
  quantity: number;
  unit_price: number;
  line_total: number;
}

export default function MasterNuevaOrden() {
  const { user } = useAuth();
  const { selectedClientId, clients, branches } = useClientContext();
  const navigate = useNavigate();
  
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [selectedBranchId, setSelectedBranchId] = useState('');
  const [isCreatingOrder, setIsCreatingOrder] = useState(false);

  const selectedClient = clients.find(c => c.id === selectedClientId);
  const clientBranches = branches.filter(b => b.client_id === selectedClientId);

  const addItemToOrder = (product: any, quantity: number) => {
    const existingIndex = orderItems.findIndex(item => item.product_id === product.id);
    
    if (existingIndex >= 0) {
      setOrderItems(prev => prev.map((item, index) => 
        index === existingIndex 
          ? { 
              ...item, 
              quantity: item.quantity + quantity,
              line_total: (item.quantity + quantity) * item.unit_price
            }
          : item
      ));
    } else {
      const newItem: OrderItem = {
        product_id: product.id,
        product_name: product.name,
        product_unit: product.unit || 'Unidad',
        quantity,
        unit_price: product.effectivePrice || product.list_price,
        line_total: quantity * (product.effectivePrice || product.list_price)
      };
      setOrderItems(prev => [...prev, newItem]);
    }
  };

  const updateItemQuantity = (productId: string, newQuantity: number) => {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    
    setOrderItems(prev => prev.map(item => 
      item.product_id === productId 
        ? { 
            ...item, 
            quantity: newQuantity,
            line_total: newQuantity * item.unit_price
          }
        : item
    ));
  };

  const removeItem = (productId: string) => {
    setOrderItems(prev => prev.filter(item => item.product_id !== productId));
  };

  const getTotalAmount = () => {
    return orderItems.reduce((total, item) => total + item.line_total, 0);
  };

  const createOrderFromItems = async () => {
    if (!user || !selectedClientId || !selectedBranchId || orderItems.length === 0) {
      alert('Completa todos los campos requeridos');
      return;
    }

    try {
      setIsCreatingOrder(true);
      console.debug('master:nueva-orden:create:start', { 
        clientId: selectedClientId, 
        branchId: selectedBranchId,
        itemsCount: orderItems.length 
      });

      // Create the order
      const order = await createOrder({
        client_id: selectedClientId,
        branch_id: selectedBranchId,
        created_by: user.id
      });

      console.debug('master:nueva-orden:create:order-ok', order.id);

      // Add each item to the order
      for (const item of orderItems) {
        await addOrderItem({
          order_id: order.id,
          product_id: item.product_id,
          qty: item.quantity,
          unit_price: item.unit_price
        });
      }

      console.debug('master:nueva-orden:create:items-ok', orderItems.length);
      showSuccess(
        '¡Orden creada exitosamente!',
        `Orden #${order.id.slice(-8).toUpperCase()} lista para gestionar`
      );
      
      // Navigate to order detail
      navigate(`/mi-empresa/ordenes/${order.id}`);
    } catch (error) {
      console.error('master:nueva-orden:create:err', error);
      showError(
        'Error al crear la orden',
        error instanceof Error ? error.message : 'Error desconocido'
      );
    } finally {
      setIsCreatingOrder(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <Link
          to="/mi-empresa/ordenes"
          className="inline-flex items-center text-blue-600 hover:text-blue-700 transition-colors duration-200 mb-4"
        >
          <ArrowLeft className="h-4 w-4 mr-2" />
          Volver a órdenes
        </Link>
        <h1 className="text-2xl font-bold text-gray-900">Nueva Orden</h1>
        <p className="text-gray-600">
          Crear orden para {selectedClient?.name || 'tu empresa'}
        </p>
      </div>

      {/* Branch Selection */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Seleccionar Sucursal</h2>
        
        <div className="max-w-md">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Sucursal *
          </label>
          <select
            value={selectedBranchId}
            onChange={(e) => setSelectedBranchId(e.target.value)}
            className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            required
          >
            <option value="">Seleccionar sucursal...</option>
            {clientBranches.map((branch) => (
              <option key={branch.id} value={branch.id}>
                {branch.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      {selectedBranchId && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Catalog */}
          <div className="lg:col-span-2">
            <div className="mb-6">
              <h2 className="text-xl font-bold text-gray-900 mb-2">
                Catálogo con Precios Especiales
              </h2>
              <p className="text-gray-600">
                Productos con precios efectivos para {selectedClient?.name || 'tu empresa'}
              </p>
            </div>
            
            {selectedClientId ? (
              <ClientCatalog 
                clientId={selectedClientId}
                onAddToOrder={addItemToOrder}
              />
            ) : (
              <div className="text-center py-12 bg-white rounded-lg shadow-md">
                <Package className="h-16 w-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">Selecciona un cliente</h3>
                <p className="text-gray-600">Configurando contexto del cliente...</p>
              </div>
            )}
          </div>

          {/* Order Summary */}
          <div className="bg-white rounded-lg shadow-md p-6 h-fit sticky top-24">
            <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
              <ShoppingCart className="h-5 w-5 mr-2" />
              Carrito de la Orden
            </h2>
            
            {orderItems.length === 0 ? (
              <div className="text-center py-8 text-gray-500">
                <Package className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                <p>No hay productos en la orden</p>
                <p className="text-sm">Agrega productos del catálogo</p>
              </div>
            ) : (
              <>
                <div className="space-y-4 mb-6">
                  {orderItems.map((item) => (
                    <div key={item.product_id} className="border border-gray-200 rounded-lg p-4">
                      <div className="flex justify-between items-start mb-2">
                        <h3 className="font-medium text-gray-900 text-sm line-clamp-2">
                          {item.product_name}
                        </h3>
                        <button
                          onClick={() => removeItem(item.product_id)}
                          className="text-red-600 hover:text-red-700 ml-2"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                      
                      <div className="flex items-center justify-between">
                        <div className="flex items-center space-x-2">
                          <button
                            onClick={() => updateItemQuantity(item.product_id, item.quantity - 1)}
                            className="p-1 border border-gray-300 rounded hover:bg-gray-50"
                          >
                            <Minus className="h-3 w-3" />
                          </button>
                          <span className="text-sm font-medium w-8 text-center">
                            {item.quantity}
                          </span>
                          <button
                            onClick={() => updateItemQuantity(item.product_id, item.quantity + 1)}
                            className="p-1 border border-gray-300 rounded hover:bg-gray-50"
                          >
                            <Plus className="h-3 w-3" />
                          </button>
                        </div>
                        
                        <div className="text-right">
                          <div className="text-sm text-gray-600">
                            {formatPrice(item.unit_price)} / {item.product_unit}
                          </div>
                          <div className="text-sm font-semibold text-gray-900">
                            {formatPrice(item.line_total)}
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                <div className="border-t border-gray-200 pt-4 mb-6">
                  <div className="flex justify-between items-center text-lg font-bold">
                    <span>Total:</span>
                    <span className="text-blue-600">{formatPrice(getTotalAmount())}</span>
                  </div>
                </div>

                <button
                  onClick={createOrderFromItems}
                  disabled={isCreatingOrder}
                  className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {isCreatingOrder ? (
                    <>
                      <LoadingSpinner size="sm" />
                      <span>Creando Orden...</span>
                    </>
                  ) : (
                    <>
                      <ShoppingCart className="h-4 w-4" />
                      <span>Crear Orden</span>
                    </>
                  )}
                </button>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  );
}