import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { ShoppingCart, DollarSign, Clock, CheckCircle, TrendingUp } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { supabase } from '../../lib/supabase';
import StatCard from '../../components/Admin/StatCard';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';

interface GerenteStats {
  totalOrders: number;
  totalRevenue: number;
  ordersByStatus: { [key: string]: number };
  recentOrders: Array<{
    id: string;
    status: string;
    total: number;
    created_at: string;
  }>;
}

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

export default function GerenteResumen() {
  const { user, profile } = useAuth();
  const { selectedClientId, selectedBranchId, clients, branches } = useClientContext();
  const [stats, setStats] = useState<GerenteStats | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const selectedClient = clients.find(c => c.id === selectedClientId);
  const selectedBranch = branches.find(b => b.id === selectedBranchId);

  useEffect(() => {
    if (selectedClientId && selectedBranchId) {
      loadGerenteStats();
    }
  }, [selectedClientId, selectedBranchId]);

  const loadGerenteStats = async () => {
    if (!selectedClientId || !selectedBranchId) return;

    try {
      setIsLoading(true);
      setError(null);
      console.debug('gerente:stats:fetch:start', { clientId: selectedClientId, branchId: selectedBranchId });

      // Get date 30 days ago
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      // Orders for this branch (last 30 days)
      const { data: ordersData, error: ordersError } = await supabase
        .from('orders')
        .select('id, status, total, created_at')
        .eq('client_id', selectedClientId)
        .eq('branch_id', selectedBranchId)
        .gte('created_at', thirtyDaysAgo.toISOString())
        .order('created_at', { ascending: false });

      if (ordersError) throw ordersError;

      const orders = ordersData || [];
      
      // Calculate statistics
      const ordersByStatus: { [key: string]: number } = {};
      let totalRevenue = 0;

      orders.forEach(order => {
        ordersByStatus[order.status] = (ordersByStatus[order.status] || 0) + 1;
        
        // Revenue from confirmed orders
        if (['pagado', 'en_preparacion', 'despachado', 'completado'].includes(order.status)) {
          totalRevenue += parseFloat(order.total || '0');
        }
      });

      // Recent orders (last 5)
      const recentOrders = orders
        .slice(0, 5)
        .map(order => ({
          id: order.id,
          status: order.status,
          total: parseFloat(order.total || '0'),
          created_at: order.created_at
        }));

      const gerenteStats: GerenteStats = {
        totalOrders: orders.length,
        totalRevenue,
        ordersByStatus,
        recentOrders
      };

      console.debug('gerente:stats:fetch:ok', gerenteStats);
      setStats(gerenteStats);
    } catch (err) {
      console.error('gerente:stats:fetch:err', err);
      setError(err instanceof Error ? err.message : 'Error loading statistics');
    } finally {
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <TrendingUp className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar estadísticas</h3>
        <p className="text-gray-600 mb-4">{error}</p>
        <button
          onClick={loadGerenteStats}
          className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
        >
          Reintentar
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Resumen de la Sucursal</h1>
        <p className="text-gray-600">
          Estadísticas y actividad de {selectedBranch?.name} - {selectedClient?.name}
        </p>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <StatCard
          title="Pedidos (30 días)"
          value={stats?.totalOrders || 0}
          icon={ShoppingCart}
        />
        <StatCard
          title="Total Confirmado"
          value={formatPrice(stats?.totalRevenue || 0)}
          icon={DollarSign}
        />
        <StatCard
          title="Promedio por Pedido"
          value={stats?.totalOrders ? formatPrice((stats.totalRevenue || 0) / stats.totalOrders) : formatPrice(0)}
          icon={TrendingUp}
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Orders by Status */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Pedidos por Estado</h3>
          <div className="space-y-3">
            {Object.entries(stats?.ordersByStatus || {}).map(([status, count]) => (
              <div key={status} className="flex justify-between items-center">
                <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                  statusConfig[status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                }`}>
                  {statusConfig[status as keyof typeof statusConfig]?.label || status}
                </span>
                <span className="text-sm text-gray-900 font-semibold">{count}</span>
              </div>
            ))}
            {Object.keys(stats?.ordersByStatus || {}).length === 0 && (
              <p className="text-gray-500 text-sm">No hay pedidos en los últimos 30 días</p>
            )}
          </div>
        </div>

        {/* Recent Orders */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Pedidos Recientes</h3>
            <Link
              to="/mi-sucursal/ordenes"
              className="text-blue-600 hover:text-blue-700 text-sm font-medium"
            >
              Ver todos
            </Link>
          </div>
          <div className="space-y-3">
            {stats?.recentOrders.map((order) => (
              <div key={order.id} className="border-b border-gray-100 pb-2 last:border-b-0">
                <div className="flex justify-between items-start">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center space-x-2">
                      <Link
                        to={`/mi-sucursal/ordenes/${order.id || ''}`}
                        className="text-sm font-medium text-blue-600 hover:text-blue-800"
                      >
                        #{order.id ? order.id.slice(-8).toUpperCase() : 'UNKNOWN'}
                      </Link>
                      <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                        statusConfig[order.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                      }`}>
                        {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-sm font-semibold text-gray-900">
                      {formatPrice(order.total || 0)}
                    </div>
                    <div className="text-xs text-gray-500">
                      {order.created_at ? new Date(order.created_at).toLocaleDateString('es-CO') : 'Sin fecha'}
                    </div>
                  </div>
                </div>
              </div>
            ))}
            {(stats?.recentOrders.length || 0) === 0 && (
              <p className="text-gray-500 text-sm">No hay pedidos recientes</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}