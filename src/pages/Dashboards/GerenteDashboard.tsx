import React from 'react';
import { ShoppingCart, Package, Clock, CheckCircle, Plus, Send } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { getOrders, updateOrderStatus, createOrder } from '../../services/orders';
import type { Order } from '../../services/orders';
import OrdersList from '../../components/Master/OrdersList';
import ClientCatalog from '../../components/Master/ClientCatalog';
import LoadingSpinner from '../../components/UI/LoadingSpinner';

export default function GerenteDashboard() {
  const { user, profile } = useAuth();
  const { 
    clients, 
    branches, 
    selectedClientId, 
    selectedBranchId,
    isLoading 
  } = useClientContext();

  const [activeTab, setActiveTab] = useState<'orders' | 'catalog'>('orders');
  const [orders, setOrders] = useState<Order[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [statusFilter, setStatusFilter] = useState('all');

  useEffect(() => {
    if (selectedClientId && selectedBranchId && activeTab === 'orders') {
      loadOrders();
    }
  }, [selectedClientId, selectedBranchId, statusFilter, activeTab]);

  const loadOrders = async () => {
    if (!selectedClientId || !selectedBranchId) return;

    try {
      setOrdersLoading(true);
      const { data } = await getOrders(selectedClientId, {
        status: statusFilter,
        branchId: selectedBranchId
      });
      setOrders(data);
    } catch (error) {
      console.error('Error loading orders:', error);
    } finally {
      setOrdersLoading(false);
    }
  };

  const handleSendForApproval = async (orderId: string) => {
    try {
      await updateOrderStatus(orderId, 'pendiente_aprobacion');
      loadOrders();
    } catch (error) {
      console.error('Error sending order for approval:', error);
      alert('Error al enviar la orden para aprobación');
    }
  };

  const handleViewOrder = (orderId: string) => {
    // TODO: Open order detail modal or navigate to detail page
    console.log('View order:', orderId);
  };

  const handleCreateNewOrder = async () => {
    if (!selectedClientId || !selectedBranchId || !user?.id) return;

    try {
      const newOrder = await createOrder({
        client_id: selectedClientId,
        branch_id: selectedBranchId,
        created_by: user.id
      });
      
      // TODO: Navigate to order editing interface
      console.log('Created new order:', newOrder.id);
      alert(`Nueva orden creada: ${newOrder.id.slice(-8).toUpperCase()}`);
      loadOrders();
    } catch (error) {
      console.error('Error creating order:', error);
      alert('Error al crear la orden');
    }
  };

  const handleAddToOrder = async (product: any, quantity: number) => {
    // TODO: Add to current draft order or create new order
    console.log('Add to order:', product.name, quantity);
    alert(`${product.name} agregado al pedido (${quantity} unidades)`);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  const selectedClient = clients.find(c => c.id === selectedClientId);
  const selectedBranch = branches.find(b => b.id === selectedBranchId);

  if (!selectedClient || !selectedBranch) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="text-center py-12 bg-white rounded-lg shadow-md">
          <Clock className="h-16 w-16 text-gray-300 mx-auto mb-4" />
          <h3 className="text-xl font-semibold text-gray-900 mb-2">Configurando acceso</h3>
          <p className="text-gray-600">Cargando información de tu sucursal...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">Panel de Gerente</h1>
        <p className="text-lg text-gray-600 mt-2">
          Bienvenido, {profile?.display_name || 'Usuario'} 
          <span className="text-blue-600"> - {selectedClient.name}</span>
        </p>
      </div>

      {/* Branch Info */}
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Mi Sucursal</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Cliente
            </label>
            <div className="bg-gray-50 px-3 py-2 rounded-md text-gray-900">
              {selectedClient.name}
            </div>
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Sucursal
            </label>
            <div className="bg-gray-50 px-3 py-2 rounded-md text-gray-900">
              {selectedBranch.name}
            </div>
          </div>

          {selectedBranch.address && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Dirección
              </label>
              <div className="bg-gray-50 px-3 py-2 rounded-md text-gray-900 text-sm">
                {selectedBranch.address}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Navigation Tabs */}
      <div className="border-b border-gray-200 mb-6">
        <nav className="-mb-px flex space-x-8">
          {[
            { id: 'orders', label: 'Mis Pedidos', icon: ShoppingCart },
            { id: 'catalog', label: 'Catálogo', icon: Package }
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`flex items-center space-x-2 py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === tab.id
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              } transition-colors duration-200`}
            >
              <tab.icon className="h-4 w-4" />
              <span>{tab.label}</span>
            </button>
          ))}
        </nav>
      </div>

      {/* Tab Content */}
      {activeTab === 'orders' && (
        <div className="space-y-6">
          {/* Order Filters and Actions */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0">
              <div>
                <h2 className="text-lg font-medium text-gray-900">Mis Pedidos</h2>
                <p className="text-sm text-gray-600">
                  Pedidos de la sucursal: {selectedBranch.name}
                </p>
              </div>
              <div className="flex items-center space-x-4">
                <select
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                  className="border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="all">Todos los estados</option>
                  <option value="borrador">Borradores</option>
                  <option value="pendiente_aprobacion">Pendientes</option>
                  <option value="aprobado">Aprobadas</option>
                  <option value="pagado">Pagadas</option>
                  <option value="completado">Completadas</option>
                </select>
                <button 
                  onClick={handleCreateNewOrder}
                  className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
                >
                  <Plus className="h-4 w-4" />
                  <span>Nuevo Pedido</span>
                </button>
              </div>
            </div>
          </div>

          {/* Orders List */}
          <GerenteOrdersList
            orders={orders}
            isLoading={ordersLoading}
            onViewOrder={handleViewOrder}
            onSendForApproval={handleSendForApproval}
          />
        </div>
      )}

      {activeTab === 'catalog' && (
        <div>
          <div className="mb-6">
            <h2 className="text-xl font-bold text-gray-900 mb-2">
              Catálogo con Precios Especiales
            </h2>
            <p className="text-gray-600">
              Productos con precios efectivos para {selectedClient.name}
            </p>
          </div>
          
          <ClientCatalog 
            clientId={selectedClientId}
            onAddToOrder={handleAddToOrder}
          />
        </div>
      )}
    </div>
  );
}

// Gerente-specific orders list component
interface GerenteOrdersListProps {
  orders: Order[];
  isLoading: boolean;
  onViewOrder: (orderId: string) => void;
  onSendForApproval: (orderId: string) => void;
}

function GerenteOrdersList({ 
  orders, 
  isLoading, 
  onViewOrder, 
  onSendForApproval 
}: GerenteOrdersListProps) {
  const statusConfig = {
    borrador: { label: 'Borrador', color: 'bg-gray-100 text-gray-800' },
    pendiente_aprobacion: { label: 'Pendiente', color: 'bg-yellow-100 text-yellow-800' },
    aprobado: { label: 'Aprobado', color: 'bg-green-100 text-green-800' },
    pagado: { label: 'Pagado', color: 'bg-blue-100 text-blue-800' },
    en_preparacion: { label: 'Preparación', color: 'bg-purple-100 text-purple-800' },
    despachado: { label: 'Despachado', color: 'bg-indigo-100 text-indigo-800' },
    completado: { label: 'Completado', color: 'bg-green-100 text-green-800' },
    anulado: { label: 'Anulado', color: 'bg-red-100 text-red-800' }
  };

  if (isLoading) {
    return (
      <div className="space-y-4">
        {[...Array(3)].map((_, i) => (
          <div key={i} className="bg-white rounded-lg shadow-md p-6 animate-pulse">
            <div className="h-4 bg-gray-200 rounded w-1/4 mb-2"></div>
            <div className="h-3 bg-gray-200 rounded w-1/2 mb-4"></div>
            <div className="flex space-x-2">
              <div className="h-8 bg-gray-200 rounded w-20"></div>
              <div className="h-8 bg-gray-200 rounded w-20"></div>
            </div>
          </div>
        ))}
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <ShoppingCart className="h-16 w-16 text-gray-300 mx-auto mb-4" />
        <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay pedidos</h3>
        <p className="text-gray-600">Crea tu primer pedido para comenzar</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {orders.map((order) => (
        <div key={order.id} className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="text-lg font-semibold text-gray-900">
                Pedido #{order.id.slice(-8).toUpperCase()}
              </h3>
              <p className="text-sm text-gray-600">
                {order.user_profiles.display_name || 'Usuario'} • {order.client_branches.name}
              </p>
              <p className="text-xs text-gray-500">
                {new Date(order.created_at!).toLocaleDateString('es-CO', {
                  year: 'numeric',
                  month: 'short',
                  day: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit'
                })}
              </p>
            </div>
            
            <div className="text-right">
              <div className="text-lg font-bold text-gray-900">
                ${(order.total || 0).toLocaleString()}
              </div>
              <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                statusConfig[order.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
              }`}>
                {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
              </span>
            </div>
          </div>

          <div className="flex items-center space-x-2">
            <button
              onClick={() => onViewOrder(order.id)}
              className="flex items-center space-x-1 px-3 py-1 text-sm text-blue-600 hover:bg-blue-50 rounded-md transition-colors duration-200"
            >
              <Package className="h-4 w-4" />
              <span>Ver</span>
            </button>

            {order.status === 'borrador' && (
              <button
                onClick={() => onSendForApproval(order.id)}
                className="flex items-center space-x-1 px-3 py-1 text-sm text-green-600 hover:bg-green-50 rounded-md transition-colors duration-200"
              >
                <Send className="h-4 w-4" />
                <span>Enviar a Aprobación</span>
              </button>
            )}
          </div>
        </div>
      ))}
    </div>
  );
}