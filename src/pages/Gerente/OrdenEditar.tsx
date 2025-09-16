import React, { useState, useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import { ArrowLeft, ShoppingCart, Plus, Minus, Trash2, Send, Package } from 'lucide-react';
import { getOrder, updateOrderItem, deleteOrderItem, addOrderItem, updateOrderStatus } from '../../services/orders';
import type { OrderWithItems } from '../../services/orders';
import ClientCatalog from '../../components/Master/ClientCatalog';
import { formatPrice } from '../../utils/format';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { showSuccess, showError } from '../../utils/toast';
import { useClientContext } from '../../hooks/useClientContext';

interface OrderItem {
  id: string;
  product_id: string;
  product_name: string;
  product_unit: string;
  quantity: number;
  unit_price: number;
  line_total: number;
}

export default function GerenteOrdenEditar() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { selectedClientId, clients, branches } = useClientContext();
  
  const [order, setOrder] = useState<OrderWithItems | null>(null);
  const [orderItems, setOrderItems] = useState<OrderItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isSavingItems, setIsSavingItems] = useState(false);
  const [isSendingApproval, setIsSendingApproval] = useState(false);

  const selectedClient = clients.find(c => c.id === selectedClientId);

  useEffect(() => {
    if (id) {
      loadOrder();
    }
  }, [id]);

  const loadOrder = async () => {
    if (!id) return;

    try {
      console.debug('gerente:orden:edit:fetch:start', id);
      const orderData = await getOrder(id);
      
      if (orderData.status !== 'borrador') {
        showError('No se puede editar', 'Solo se pueden editar pedidos en estado borrador');
        navigate(`/mi-sucursal/ordenes/${id}`);
        return;
      }
      
      setOrder(orderData);
      
      // Convert order items to editable format
      const editableItems: OrderItem[] = orderData.order_items.map(item => ({
        id: item.id,
        product_id: item.product_id,
        product_name: item.products?.name || 'Producto eliminado',
        product_unit: item.products?.unit || 'Unidad',
        quantity: parseFloat(item.qty),
        unit_price: item.unit_price,
        line_total: item.line_total
      }));
      
      setOrderItems(editableItems);
      console.debug('gerente:orden:edit:fetch:ok', editableItems.length);
    } catch (err) {
      console.error('gerente:orden:edit:fetch:err', err);
      setError(err instanceof Error ? err.message : 'Error loading order');
    } finally {
      setIsLoading(false);
    }
  };

  const addItemToOrder = async (product: any, quantity: number) => {
    if (!order) return;

    try {
      // Add directly to database
      await addOrderItem({
        order_id: order.id,
        product_id: product.id,
        qty: quantity,
        unit_price: product.effectivePrice || product.list_price
      });

      // Update local state
      const newItem: OrderItem = {
        id: `temp-${Date.now()}`, // Will be replaced after reload
        product_id: product.id,
        product_name: product.name,
        product_unit: product.unit || 'Unidad',
        quantity,
        unit_price: product.effectivePrice || product.list_price,
        line_total: quantity * (product.effectivePrice || product.list_price)
      };
      setOrderItems(prev => [...prev, newItem]);
      
      showSuccess('Producto agregado', `${product.name} agregado al pedido`);
    } catch (error) {
      console.error('Error adding item:', error);
      showError('Error', 'No se pudo agregar el producto');
    }
  };

  const updateItemQuantity = async (itemId: string, productId: string, newQuantity: number) => {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    try {
      setIsSavingItems(true);
      
      if (itemId.startsWith('temp-')) {
        // Update only local state for new items
        setOrderItems(prev => prev.map(item => 
          item.id === itemId 
            ? { 
                ...item, 
                quantity: newQuantity,
                line_total: newQuantity * item.unit_price
              }
            : item
        ));
      } else {
        // Update in database for existing items
        await updateOrderItem(itemId, { qty: newQuantity });
        
        // Update local state
        setOrderItems(prev => prev.map(item => 
          item.id === itemId 
            ? { 
                ...item, 
                quantity: newQuantity,
                line_total: newQuantity * item.unit_price
              }
            : item
        ));
      }
    } catch (error) {
      console.error('Error updating item:', error);
      showError('Error', 'No se pudo actualizar la cantidad');
    } finally {
      setIsSavingItems(false);
    }
  };

  const removeItem = async (itemId: string) => {
    try {
      if (!itemId.startsWith('temp-')) {
        // Delete from database if it's a real item
        await deleteOrderItem(itemId);
      }
      
      // Remove from local state
      setOrderItems(prev => prev.filter(item => item.id !== itemId));
      
      showSuccess('Producto eliminado', 'Producto removido del pedido');
    } catch (error) {
      console.error('Error removing item:', error);
      showError('Error', 'No se pudo eliminar el producto');
    }
  };

  const getTotalAmount = () => {
    return orderItems.reduce((total, item) => total + item.line_total, 0);
  };

  const sendForApproval = async () => {
    if (!order) return;

    try {
      setIsSendingApproval(true);
      console.debug('gerente:orden:edit:send-approval:start', order.id);
      
      await updateOrderStatus(order.id, 'pendiente_aprobacion');
      
      console.debug('gerente:orden:edit:send-approval:ok', order.id);
      showSuccess('Enviado a aprobación', 'El pedido ha sido enviado para aprobación del Master');
      
      navigate('/mi-sucursal/ordenes');
    } catch (error) {
      console.error('gerente:orden:edit:send-approval:err', error);
      showError('Error al enviar', 'No se pudo enviar el pedido para aprobación');
    } finally {
      setIsSendingApproval(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <Package className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">
          {error || 'Pedido no encontrado'}
        </h3>
        <Link
          to="/mi-sucursal/ordenes"
          className="text-blue-600 hover:text-blue-700 transition-colors duration-200"
        >
          Volver a mis pedidos
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex items-center justify-between">
          <div>
            <Link
              to="/mi-sucursal/ordenes"
              className="inline-flex items-center text-blue-600 hover:text-blue-700 transition-colors duration-200 mb-4"
            >
              <ArrowLeft className="h-4 w-4 mr-2" />
              Volver a mis pedidos
            </Link>
            <h1 className="text-2xl font-bold text-gray-900">
              Editar Pedido #{order.id.slice(-8).toUpperCase()}
            </h1>
            <p className="text-gray-600">
              {selectedClient?.name} • {order.client_branches?.name}
            </p>
          </div>

          <button
            onClick={sendForApproval}
            disabled={isSendingApproval || orderItems.length === 0}
            className="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition-colors duration-200 disabled:opacity-50 flex items-center space-x-2"
          >
            {isSendingApproval ? (
              <LoadingSpinner size="sm" />
            ) : (
              <Send className="h-4 w-4" />
            )}
            <span>{isSendingApproval ? 'Enviando...' : 'Enviar a Aprobación'}</span>
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Catalog */}
        <div className="lg:col-span-2">
          <div className="mb-6">
            <h2 className="text-xl font-bold text-gray-900 mb-2">
              Agregar más productos
            </h2>
            <p className="text-gray-600">
              Catálogo con precios efectivos para {selectedClient?.name}
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
              <p className="text-gray-600">Cargando información del cliente...</p>
            </div>
          )}
        </div>

        {/* Order Items Editor */}
        <div className="bg-white rounded-lg shadow-md p-6 h-fit sticky top-24">
          <h2 className="text-xl font-bold text-gray-900 mb-6 flex items-center">
            <ShoppingCart className="h-5 w-5 mr-2" />
            Items del Pedido
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
                  <div key={item.id} className="border border-gray-200 rounded-lg p-4">
                    <div className="flex justify-between items-start mb-2">
                      <h3 className="font-medium text-gray-900 text-sm line-clamp-2">
                        {item.product_name}
                      </h3>
                      <button
                        onClick={() => removeItem(item.id)}
                        className="text-red-600 hover:text-red-700 ml-2"
                        disabled={isSavingItems}
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => updateItemQuantity(item.id, item.product_id, item.quantity - 1)}
                          className="p-1 border border-gray-300 rounded hover:bg-gray-50"
                          disabled={isSavingItems}
                        >
                          <Minus className="h-3 w-3" />
                        </button>
                        <span className="text-sm font-medium w-8 text-center">
                          {item.quantity}
                        </span>
                        <button
                          onClick={() => updateItemQuantity(item.id, item.product_id, item.quantity + 1)}
                          className="p-1 border border-gray-300 rounded hover:bg-gray-50"
                          disabled={isSavingItems}
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
                onClick={sendForApproval}
                disabled={isSendingApproval || orderItems.length === 0}
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
            </>
          )}
        </div>
      </div>
    </div>
  );
}