import React, { useState, useEffect } from 'react';
import { ShoppingCart, Plus, Minus, Trash2, Send, Package } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { createOrder, addOrderItem, updateOrderStatus } from '../../services/orders';
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

export default function GerenteNuevoPedido() {
  const { user, profile } = useAuth();
  const { selectedClientId, selectedBranchId, clients, branches } = useClientContext();
  const navigate = useNavigate();
  
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [currentOrderId, setCurrentOrderId] = useState<string | null>(null);
  const [isCreatingOrder, setIsCreatingOrder] = useState(false);
  const [isSendingApproval, setIsSendingApproval] = useState(false);

  const selectedClient = clients.find(c => c.id === selectedClientId);
  const selectedBranch = branches.find(b => b.id === selectedBranchId);

  const addItemToOrder = (product: any, quantity: number) => {
    const existingIndex = orderItems.findIndex(item => item.product_id === product.id);
    
    if (existingIndex >= 0) {
      // Update existing item
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
      // Add new item
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
      alert('Faltan datos requeridos para crear el pedido');
      return;
    }

    try {
      setIsCreatingOrder(true);
      console.debug('gerente:pedido:create:start', { 
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

      setCurrentOrderId(order.id);
      console.debug('gerente:pedido:create:order-ok', order.id);

      // Add each item to the order
      for (const item of orderItems) {
        await addOrderItem({
          order_id: order.id,
          product_id: item.product_id,
          qty: item.quantity,
          unit_price: item.unit_price
        });
      }

      console.debug('gerente:pedido:create:items-ok', orderItems.length);
      showSuccess(
        '¡Pedido creado exitosamente!',
        `Pedido #${order.id.slice(-8).toUpperCase()} listo para enviar a aprobación`
      );
      
      // Clear the order items
      setOrderItems([]);
      
      // Navigate to orders list
      navigate('/mi-sucursal/ordenes');
    } catch (error) {
      console.error('gerente:pedido:create:err', error);
      showError(
        'Error al crear el pedido',
        error instanceof Error ? error.message : 'Error desconocido'
      );
    } finally {
      setIsCreatingOrder(false);
    }
  };

  const sendOrderForApproval = async () => {
    if (!currentOrderId) return;

    try {
      setIsSendingApproval(true);
      console.debug('gerente:pedido:approve:start', currentOrderId);
      
      await updateOrderStatus(currentOrderId, 'pendiente_aprobacion');
      
      console.debug('gerente:pedido:approve:ok', currentOrderId);
      alert('Pedido enviado para aprobación exitosamente');
      
      setCurrentOrderId(null);
      navigate('/mi-sucursal/ordenes');
    } catch (error) {
      console.error('gerente:pedido:approve:err', error);
      alert('Error al enviar para aprobación: ' + (error instanceof Error ? error.message : 'Error desconocido'));
    } finally {
      setIsSendingApproval(false);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Nuevo Pedido</h1>
        <p className="text-gray-600">
          Crear pedido para {selectedBranch?.name || 'tu sucursal'} - {selectedClient?.name || 'tu cliente'}
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Catalog */}
        <div className="lg:col-span-2">
          <div className="mb-6">
            <h2 className="text-xl font-bold text-gray-900 mb-2">
              Catálogo con Precios Especiales
            </h2>
            <p className="text-gray-600">
              Productos con precios efectivos para {selectedClient?.name || 'tu cliente'}
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
              <h3 className="text-xl font-semibold text-gray-900 mb-2">Configurando cliente</h3>
              <p className="text-gray-600">Cargando información de tu cliente...</p>
            </div>
          )}
        </div>

        {/* Order Summary */}
        <div className="bg-white rounded-lg shadow-md p-6 h-fit sticky top-24" data-testid="order-cart">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <ShoppingCart className="h-5 w-5 mr-2" />
            Carrito del Pedido
          </h2>
          
          {orderItems.length === 0 ? (
            <div className="text-center py-8 text-gray-500">
              <Package className="h-12 w-12 mx-auto mb-4 text-gray-300" />
              <p>No hay productos en el pedido</p>
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

              <div className="space-y-3">
                <button
                  onClick={createOrderFromItems}
                  disabled={isCreatingOrder}
                  className="w-full bg-blue-600 text-white py-3 px-4 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                >
                  {isCreatingOrder ? (
                    <>
                      <LoadingSpinner size="sm" />
                      <span>Creando Pedido...</span>
                    </>
                  ) : (
                    <>
                      <ShoppingCart className="h-4 w-4" />
                      <span>Crear Pedido</span>
                    </>
                  )}
                </button>

                {currentOrderId && (
                  <button
                    onClick={sendOrderForApproval}
                    disabled={isSendingApproval}
                    className="w-full bg-green-600 text-white py-3 px-4 rounded-lg font-semibold hover:bg-green-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center space-x-2"
                  >
                    {isSendingApproval ? (
                      <>
                        <LoadingSpinner size="sm" />
                        <span>Enviando...</span>
                      </>
                    ) : (
                      <>
                        <Send className="h-4 w-4" />
                        <span>Enviar a Aprobación</span>
                      </>
                    )}
                  </button>
                )}
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  );
}