import React from 'react';
import { ShoppingCart, Users, MapPin, TrendingUp, Plus, Package, Building } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { getOrders, updateOrderStatus } from '../../services/orders';
import type { Order } from '../../services/orders';
import OrdersList from '../../components/Master/OrdersList';
import ClientCatalog from '../../components/Master/ClientCatalog';
import LoadingSpinner from '../../components/UI/LoadingSpinner';

export default function MasterDashboard() {
  const { user, profile } = useAuth();
  const { 
    clients,
    branches,
    selectedClientId,
    selectedBranchId,
    setSelectedClientId,
    setSelectedBranchId,
    isLoading 
  } = useClientContext();

  const [activeTab, setActiveTab] = useState<'orders' | 'catalog' | 'branches' | 'users'>('orders');
  const [orders, setOrders] = useState<Order[]>([]);
  const [ordersLoading, setOrdersLoading] = useState(false);
  const [statusFilter, setStatusFilter] = useState('all');

  useEffect(() => {
    if (selectedClientId && activeTab === 'orders') {
      loadOrders();
    }
  }, [selectedClientId, statusFilter, activeTab]);

  const loadOrders = async () => {
    if (!selectedClientId) return;

    try {
      setOrdersLoading(true);
      const { data } = await getOrders(selectedClientId, {
        status: statusFilter,
        created_by: user!.id
      });
      setOrders(data);
    } catch (error) {
      console.error('Error loading orders:', error);
    } finally {
      setOrdersLoading(false);
    }
  };

  const handleApproveOrder = async (orderId: string) => {
    try {
      await updateOrderStatus(orderId, 'aprobado');
      loadOrders();
    } catch (error) {
      console.error('Error approving order:', error);
      alert('Error al aprobar la orden');
    }
  };

  const handleRejectOrder = async (orderId: string, note?: string) => {
    try {
      await updateOrderStatus(orderId, 'anulado', note);
      loadOrders();
    } catch (error) {
      console.error('Error rejecting order:', error);
      alert('Error al rechazar la orden');
    }
  };

  const handleViewOrder = (orderId: string) => {
    // TODO: Open order detail modal or navigate to detail page
    console.log('View order:', orderId);
  };

  const handlePayOrder = (orderId: string) => {
    // TODO: Implement payment flow (Prompt 10)
    console.log('Pay order:', orderId);
  };

  const handleAddToOrder = (product: any, quantity: number) => {
    // TODO: Add to current order or create new order
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
  const clientBranches = branches.filter(b => b.client_id === selectedClientId);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">Panel Master</h1>
        <p className="text-lg text-gray-600 mt-2">
          Bienvenido, {profile?.display_name || 'Usuario'} 
          {selectedClient && <span className="text-blue-600"> - {selectedClient.name}</span>}
        </p>
      </div>

      {/* Client Selector */}
      {clients.length > 1 && (
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Seleccionar Cliente</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Cliente
              </label>
              <select
                value={selectedClientId || ''}
                onChange={(e) => {
                  setSelectedClientId(e.target.value || null);
                  setSelectedBranchId(null);
                }}
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Seleccionar cliente</option>
                {clients.map((client) => (
                  <option key={client.id} value={client.id}>
                    {client.name}
                  </option>
                ))}
              </select>
            </div>
            
            {clientBranches.length > 0 && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Sucursal (Opcional)
                </label>
                <select
                  value={selectedBranchId || ''}
                  onChange={(e) => setSelectedBranchId(e.target.value || null)}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="">Todas las sucursales</option>
                  {clientBranches.map((branch) => (
                    <option key={branch.id} value={branch.id}>
                      {branch.name}
                    </option>
                  ))}
                </select>
              </div>
            )}
          </div>
        </div>
      )}

      {!selectedClient ? (
        <div className="text-center py-12 bg-white rounded-lg shadow-md">
          <Building className="h-16 w-16 text-gray-300 mx-auto mb-4" />
          <h3 className="text-xl font-semibold text-gray-900 mb-2">Selecciona un Cliente</h3>
          <p className="text-gray-600">Elige un cliente para comenzar a gestionar pedidos</p>
        </div>
      ) : (
        <>
          {/* Navigation Tabs */}
          <div className="border-b border-gray-200 mb-6">
            <nav className="-mb-px flex space-x-8">
              {[
                { id: 'orders', label: 'Mis Órdenes', icon: ShoppingCart },
                { id: 'catalog', label: 'Catálogo', icon: Package },
                { id: 'branches', label: 'Sucursales', icon: MapPin },
                { id: 'users', label: 'Usuarios', icon: Users }
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
              {/* Order Filters */}
              <div className="bg-white rounded-lg shadow-md p-6">
                <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between space-y-4 sm:space-y-0">
                  <div>
                    <h2 className="text-lg font-medium text-gray-900">Gestión de Órdenes</h2>
                    <p className="text-sm text-gray-600">
                      {selectedBranchId 
                        ? `Filtrando por: ${clientBranches.find(b => b.id === selectedBranchId)?.name}`
                        : 'Mostrando todas las sucursales'
                      }
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
                    <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2">
                      <Plus className="h-4 w-4" />
                      <span>Nueva Orden</span>
                    </button>
                  </div>
                </div>
              </div>

              {/* Orders List */}
              <OrdersList
                orders={orders}
                isLoading={ordersLoading}
                onViewOrder={handleViewOrder}
                onApproveOrder={handleApproveOrder}
                onRejectOrder={handleRejectOrder}
                onPayOrder={handlePayOrder}
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

          {activeTab === 'branches' && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <div className="flex justify-between items-center mb-6">
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Sucursales</h2>
                  <p className="text-gray-600">
                    Gestiona las sucursales de {selectedClient.name}
                  </p>
                </div>
                <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2">
                  <Plus className="h-4 w-4" />
                  <span>Nueva Sucursal</span>
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {clientBranches.map((branch) => (
                  <div key={branch.id} className="border border-gray-200 rounded-lg p-4">
                    <h3 className="font-medium text-gray-900">{branch.name}</h3>
                    {branch.code && (
                      <p className="text-sm text-gray-600">Código: {branch.code}</p>
                    )}
                    {branch.address && (
                      <p className="text-sm text-gray-600 mt-1">{branch.address}</p>
                    )}
                    <div className="mt-3 flex space-x-2">
                      <button className="text-blue-600 hover:text-blue-700 text-sm">
                        Editar
                      </button>
                      <button className="text-red-600 hover:text-red-700 text-sm">
                        Eliminar
                      </button>
                    </div>
                  </div>
                ))}

                {clientBranches.length === 0 && (
                  <div className="col-span-full text-center py-8 text-gray-500">
                    <MapPin className="h-12 w-12 mx-auto mb-4 text-gray-300" />
                    <p>No hay sucursales configuradas</p>
                    <p className="text-sm">Crea la primera sucursal para comenzar</p>
                  </div>
                )}
              </div>
            </div>
          )}

          {activeTab === 'users' && (
            <div className="bg-white rounded-lg shadow-md p-6">
              <div className="flex justify-between items-center mb-6">
                <div>
                  <h2 className="text-xl font-bold text-gray-900">Gerentes de Sucursal</h2>
                  <p className="text-gray-600">
                    Administra los usuarios gerentes de {selectedClient.name}
                  </p>
                </div>
                <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2">
                  <Plus className="h-4 w-4" />
                  <span>Agregar Gerente</span>
                </button>
              </div>

              <div className="text-center py-12 text-gray-500">
                <Users className="h-16 w-16 mx-auto mb-4 text-gray-300" />
                <h3 className="text-lg font-medium text-gray-900 mb-2">Gestión de Usuarios</h3>
                <p className="text-gray-600">
                  La funcionalidad para gestionar gerentes estará disponible próximamente
                </p>
              </div>
            </div>
          )}
        </>
      )}
    </div>
  );
}

// Keep the old stats component for potential future use
const StatsSection = ({ clientBranches }: { clientBranches: any[] }) => {
  const stats = [
    {
      name: 'Pedidos Este Mes',
      value: '12',
      icon: ShoppingCart,
      change: '+23%',
      changeType: 'increase'
    },
    {
      name: 'Usuarios Activos', 
      value: '8',
      icon: Users,
      change: '+2',
      changeType: 'increase'
    },
    {
      name: 'Sucursales',
      value: clientBranches.length.toString(),
      icon: MapPin,
      change: '—',
      changeType: 'neutral'
    },
    {
      name: 'Total Gastado',
      value: '$485,250',
      icon: TrendingUp,
      change: '+18%',
      changeType: 'increase'
    }
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      {stats.map((stat) => (
        <div key={stat.name} className="bg-white rounded-lg shadow-md p-6">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <stat.icon className="h-8 w-8 text-blue-600" />
            </div>
            <div className="ml-5 w-0 flex-1">
              <dl>
                <dt className="text-sm font-medium text-gray-500 truncate">
                  {stat.name}
                </dt>
                <dd className="flex items-baseline">
                  <div className="text-2xl font-semibold text-gray-900">
                    {stat.value}
                  </div>
                  <div className={`ml-2 flex items-baseline text-sm font-semibold ${
                    stat.changeType === 'increase' ? 'text-green-600' : 
                    stat.changeType === 'decrease' ? 'text-red-600' : 'text-gray-400'
                  }`}>
                    {stat.change}
                  </div>
                </dd>
              </dl>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};