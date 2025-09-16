import React, { useState, useEffect } from 'react';
import { ShoppingCart, DollarSign, Package, Users, TrendingUp, Eye, Clock, ArrowUp, ArrowDown } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import StatCard from '../../components/Admin/StatCard';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';
import { Link } from 'react-router-dom';
import { logPageLoad } from '../../utils/qa';

interface DashboardStats {
  ordersByStatus: { [key: string]: number };
  totalRevenue: number;
  topProducts: Array<{ product_id: string; product_name: string; total_quantity: number }>;
  activeClients: number;
  totalOrders: number;
}

interface RecentOrder {
  id: string;
  status: string;
  total: number;
  created_at: string;
  client_name: string;
}

interface StatusChange {
  id: string;
  order_id: string;
  from_status: string | null;
  to_status: string;
  at: string;
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

export default function AdminResumen() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [recentOrders, setRecentOrders] = useState<RecentOrder[]>([]);
  const [statusChanges, setStatusChanges] = useState<StatusChange[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    logPageLoad('admin-resumen', 'admin');
    let isMounted = true;

    const fetchDashboardData = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:resumen:fetch:start');
        
        const [statsData, ordersData, changesData] = await Promise.all([
          loadDashboardStats(),
          loadRecentOrders(),
          loadStatusChanges()
        ]);
        
        console.debug('admin:resumen:fetch:ok', `stats:${!!statsData} orders:${ordersData.length} changes:${changesData.length}`);
        
        if (isMounted) {
          setStats(statsData);
          setRecentOrders(ordersData);
          setStatusChanges(changesData);
        }
      } catch (err) {
        console.error('admin:resumen:fetch:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading dashboard data');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchDashboardData();

    return () => {
      isMounted = false;
    };
  }, []);

  const loadDashboardStats = async (): Promise<DashboardStats> => {
    console.debug('admin:stats:load:start');
    // Get date 30 days ago
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    // 1. Orders by status (last 30 days)
    const { data: ordersData, error: ordersError } = await supabase
      .from('orders')
      .select('status, total')
      .gte('created_at', thirtyDaysAgo.toISOString());

    if (ordersError) throw ordersError;

    const ordersByStatus: { [key: string]: number } = {};
    let totalRevenue = 0;
    const totalOrders = ordersData?.length || 0;

    ordersData?.forEach(order => {
      ordersByStatus[order.status] = (ordersByStatus[order.status] || 0) + 1;
      
      // Revenue from paid/completed orders
      if (['pagado', 'en_preparacion', 'despachado', 'completado'].includes(order.status)) {
        totalRevenue += parseFloat(order.total || '0');
      }
    });

    // 2. Active clients (last 30 days)
    const { data: clientsData, error: clientsError } = await supabase
      .from('orders')
      .select('client_id')
      .gte('created_at', thirtyDaysAgo.toISOString());

    if (clientsError) throw clientsError;

    const uniqueClients = new Set(clientsData?.map(o => o.client_id) || []);
    const activeClients = uniqueClients.size;

    // 3. Top 5 products by quantity (last 30 days)
    const { data: topProductsRaw, error: productsError } = await supabase
      .from('order_items')
      .select(`
        product_id,
        qty,
        orders!inner(created_at),
        products!inner(name)
      `)
      .gte('orders.created_at', thirtyDaysAgo.toISOString())
      .order('qty', { ascending: false });

    if (productsError) throw productsError;

    // Aggregate quantities by product
    const productQuantities: { [key: string]: { name: string; total: number } } = {};
    
    topProductsRaw?.forEach(item => {
      const productId = item.product_id;
      const qty = parseFloat(item.qty);
      const productName = item.products?.name || 'Producto desconocido';
      
      if (!productQuantities[productId]) {
        productQuantities[productId] = { name: productName, total: 0 };
      }
      productQuantities[productId].total += qty;
    });

    const topProducts = Object.entries(productQuantities)
      .map(([product_id, data]) => ({
        product_id,
        product_name: data.name,
        total_quantity: data.total
      }))
      .sort((a, b) => b.total_quantity - a.total_quantity)
      .slice(0, 5);
    
    console.debug('admin:stats:load:ok', `orders:${totalOrders} revenue:${totalRevenue} clients:${activeClients}`);

    return {
      ordersByStatus,
      totalRevenue,
      topProducts,
      activeClients,
      totalOrders
    };
  };

  const loadRecentOrders = async (): Promise<RecentOrder[]> => {
    try {
      const { data, error } = await supabase
        .from('orders')
        .select(`
          id,
          status,
          total,
          created_at,
          client_id
        `)
        .order('created_at', { ascending: false })
        .limit(10);

      if (error) throw error;

      // Get client names separately
      const clientIds = [...new Set(data?.map(o => o.client_id) || [])];
      const { data: clients } = await supabase
        .from('clients')
        .select('id, name')
        .in('id', clientIds);

      const clientsMap = new Map((clients || []).map(c => [c.id, c.name]));

      return data?.map(order => ({
        id: order.id,
        status: order.status,
        total: parseFloat(order.total || '0'),
        created_at: order.created_at,
        client_name: clientsMap.get(order.client_id) || 'Cliente desconocido'
      })) || [];
    } catch (error) {
      console.error('Error loading recent orders:', error);
      return [];
    }
  };

  const loadStatusChanges = async (): Promise<StatusChange[]> => {
    const { data, error } = await supabase
      .from('order_status_history')
      .select('id, order_id, from_status, to_status, at')
      .order('at', { ascending: false })
      .limit(10);

    if (error) throw error;

    return data || [];
  };

  const handleRetry = () => {
    window.location.reload();
  };

  if (isLoading) {
    return (
      <div className="space-y-8">
        {/* KPI Cards Skeleton */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[...Array(4)].map((_, i) => (
            <div key={i} className="bg-white rounded-lg shadow-md p-6 animate-pulse">
              <div className="h-8 w-8 bg-gray-200 rounded mb-4"></div>
              <div className="h-4 bg-gray-200 rounded w-3/4 mb-2"></div>
              <div className="h-6 bg-gray-200 rounded w-1/2"></div>
            </div>
          ))}
        </div>

        {/* Lists Skeleton */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {[...Array(2)].map((_, i) => (
            <div key={i} className="bg-white rounded-lg shadow-md p-6 animate-pulse">
              <div className="h-6 bg-gray-200 rounded w-1/3 mb-6"></div>
              <div className="space-y-4">
                {[...Array(5)].map((_, j) => (
                  <div key={j} className="h-4 bg-gray-200 rounded"></div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <TrendingUp className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar dashboard</h3>
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
    <div className="space-y-8">
      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Órdenes (30 días)"
          value={stats?.totalOrders || 0}
          icon={ShoppingCart}
        />
        <StatCard
          title="Ventas Confirmadas"
          value={formatPrice(stats?.totalRevenue || 0)}
          icon={DollarSign}
        />
        <StatCard
          title="Clientes Activos"
          value={stats?.activeClients || 0}
          icon={Users}
        />
        <StatCard
          title="Top Producto"
          value={stats?.topProducts[0]?.total_quantity || 0}
          icon={Package}
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Orders by Status */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Órdenes por Estado</h3>
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
              <p className="text-gray-500 text-sm">No hay órdenes en los últimos 30 días</p>
            )}
          </div>
        </div>

        {/* Top Products */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Top Productos</h3>
          <div className="space-y-3">
            {stats?.topProducts.map((product, index) => (
              <div key={product.product_id} className="flex justify-between items-center">
                <div className="flex-1 min-w-0">
                  <span className="text-sm font-medium text-gray-900 truncate block">
                    {index + 1}. {product.product_name}
                  </span>
                </div>
                <span className="text-sm text-blue-600 font-semibold ml-2">
                  {Math.round(product.total_quantity)}
                </span>
              </div>
            ))}
            {(stats?.topProducts.length || 0) === 0 && (
              <p className="text-gray-500 text-sm">No hay datos de productos</p>
            )}
          </div>
        </div>

        {/* Recent Orders */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold text-gray-900">Órdenes Recientes</h3>
            <Link
              to="/admin/resumen"
              className="text-blue-600 hover:text-blue-700 text-sm font-medium"
            >
              Ver todas
            </Link>
          </div>
          <div className="space-y-3">
            {recentOrders.map((order) => (
              <div key={order.id} className="border-b border-gray-100 pb-2 last:border-b-0">
                <div className="flex justify-between items-start">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center space-x-2">
                      <span className="text-sm font-medium text-gray-900">
                        #{order.id.slice(-8).toUpperCase()}
                      </span>
                      <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                        statusConfig[order.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                      }`}>
                        {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
                      </span>
                    </div>
                    <p className="text-xs text-gray-600 truncate mt-1">
                      {order.client_name}
                    </p>
                  </div>
                  <div className="text-right">
                    <div className="text-sm font-semibold text-gray-900">
                      {formatPrice(order.total)}
                    </div>
                    <div className="text-xs text-gray-500">
                      {new Date(order.created_at).toLocaleDateString('es-CO')}
                    </div>
                  </div>
                </div>
              </div>
            ))}
            {recentOrders.length === 0 && (
              <p className="text-gray-500 text-sm">No hay órdenes recientes</p>
            )}
          </div>
        </div>
      </div>

      {/* Status Changes */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Cambios de Estado Recientes</h3>
        <div className="space-y-3">
          {statusChanges.map((change) => (
            <div key={change.id} className="flex items-center space-x-4 py-2">
              <div className="flex items-center space-x-2">
                <Clock className="h-4 w-4 text-gray-400" />
                <span className="text-sm text-gray-600">
                  {new Date(change.at).toLocaleString('es-CO')}
                </span>
              </div>
              <div className="flex items-center space-x-2">
                <span className="text-sm font-medium text-gray-900">
                  Orden #{change.order_id.slice(-8).toUpperCase()}
                </span>
                {change.from_status && (
                  <>
                    <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                      statusConfig[change.from_status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                    }`}>
                      {statusConfig[change.from_status as keyof typeof statusConfig]?.label || change.from_status}
                    </span>
                    <ArrowRight className="h-3 w-3 text-gray-400" />
                  </>
                )}
                <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                  statusConfig[change.to_status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                }`}>
                  {statusConfig[change.to_status as keyof typeof statusConfig]?.label || change.to_status}
                </span>
              </div>
            </div>
          ))}
          {statusChanges.length === 0 && (
            <p className="text-gray-500 text-sm">No hay cambios de estado recientes</p>
          )}
        </div>
      </div>
    </div>
  );
}

// Arrow Right component (missing import)
function ArrowRight({ className }: { className?: string }) {
  return (
    <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
    </svg>
  );
}