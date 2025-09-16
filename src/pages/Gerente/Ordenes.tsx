import React, { useState, useEffect } from 'react';
import { Search, Filter, Send, Eye, Edit, Clock, Plus } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { useClientContext } from '../../hooks/useClientContext';
import { showSuccess, showError } from '../../utils/toast';
import { getOrders, updateOrderStatus } from '../../services/orders';
import type { Order } from '../../services/orders';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';

const statusConfig = {
  borrador: { label: 'Borrador', color: 'bg-gray-100 text-gray-800' },
  pendiente_aprobacion: { label: 'Pendiente Aprobación', color: 'bg-yellow-100 text-yellow-800' },
  aprobado: { label: 'Aprobado', color: 'bg-green-100 text-green-800' },
  pagado: { label: 'Pagado', color: 'bg-blue-100 text-blue-800' },
  en_preparacion: { label: 'En Preparación', color: 'bg-purple-100 text-purple-800' },
  despachado: { label: 'Despachado', color: 'bg-indigo-100 text-indigo-800' },
  completado: { label: 'Completado', color: 'bg-green-100 text-green-800' },
  anulado: { label: 'Anulado', color: 'bg-red-100 text-red-800' }
};

export default function GerenteOrdenes() {
  const { user } = useAuth();
  const { 
    selectedClientId, 
    selectedBranchId, 
    clients, 
    branches,
    isLoading: contextLoading 
  } = useClientContext();

  const [orders, setOrders] = useState<Order[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [statusFilter, setStatusFilter] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);

  const selectedClient = clients.find(c => c.id === selectedClientId);
  const selectedBranch = branches.find(b => b.id === selectedBranchId);
  
  const ordersPerPage = 10;

  useEffect(() => {
    if (selectedClientId && selectedBranchId) {
      loadOrders();
    }
  }, [selectedClientId, selectedBranchId, statusFilter, currentPage]);

  const loadOrders = async () => {
    if (!selectedClientId || !selectedBranchId) return;

    try {
      setIsLoading(true);
      setError(null);
      console.debug('gerente:ordenes:fetch:start', { 
        clientId: selectedClientId, 
        branchId: selectedBranchId,
        status: statusFilter, 
        page: currentPage 
      });

      const { data, count } = await getOrders(selectedClientId, {
        status: statusFilter === 'all' ? undefined : statusFilter,
        branchId: selectedBranchId,
        page: currentPage,
        limit: ordersPerPage
      });

      console.debug('gerente:ordenes:fetch:ok', data.length, 'total:', count);
      setOrders(data);
      setTotalCount(count);
    } catch (err) {
      console.error('gerente:ordenes:fetch:err', err);
      setError(err instanceof Error ? err.message : 'Error loading orders');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSendForApproval = async (orderId: string) => {
    try {
      console.debug('gerente:ordenes:send-approval:start', orderId);
      await updateOrderStatus(orderId, 'pendiente_aprobacion');
      console.debug('gerente:ordenes:send-approval:ok', orderId);
      loadOrders();
      showSuccess('Enviado a aprobación', 'El pedido ha sido enviado para aprobación del Master');
    } catch (error) {
      console.error('gerente:ordenes:send-approval:err', error);
      showError('Error al enviar', 'No se pudo enviar el pedido para aprobación');
    }
  };

  const handleRetry = () => {
    loadOrders();
  };

  const totalPages = Math.ceil(totalCount / ordersPerPage);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex justify-between items-center">
          <div>
            <h2 className="text-lg font-semibold text-gray-900">
              Mis Pedidos - {selectedBranch?.name || 'Cargando...'}
            </h2>
            <p className="text-gray-600 text-sm">
              Administra los pedidos de tu sucursal
            </p>
          </div>
          <Link
            to="/mi-sucursal/nuevo-pedido"
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nuevo Pedido</span>
          </Link>
        </div>

        <div className="mt-4">
          <div className="max-w-xs">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Filtrar por estado
            </label>
            <select
              value={statusFilter}
              onChange={(e) => {
                setStatusFilter(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="all">Todos los estados</option>
              <option value="borrador">Borradores</option>
              <option value="pendiente_aprobacion">Pendientes Aprobación</option>
              <option value="aprobado">Aprobados</option>
              <option value="pagado">Pagados</option>
              <option value="completado">Completados</option>
              <option value="anulado">Anulados</option>
            </select>
          </div>
        </div>
      </div>

      {/* Orders List */}
      <div className="bg-white rounded-lg shadow-md">
        {contextLoading || isLoading ? (
          <div className="flex justify-center items-center h-64">
            <LoadingSpinner size="lg" />
          </div>
        ) : error ? (
          <div className="text-center py-12">
            <div className="text-red-400 mb-4">
              <Filter className="h-16 w-16 mx-auto" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar pedidos</h3>
            <p className="text-gray-600 mb-4">{error}</p>
            <button
              onClick={handleRetry}
              className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
            >
              Reintentar
            </button>
          </div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Pedido
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Estado
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Total
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Fecha
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Acciones
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {orders.map((order) => (
                    <tr key={order.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div>
                          <Link
                            to={`/mi-sucursal/ordenes/${order.id || ''}`}
                            className="text-blue-600 hover:text-blue-800 font-medium"
                          >
                            #{order.id ? order.id.slice(-8).toUpperCase() : 'UNKNOWN'}
                          </Link>
                          <div className="text-sm text-gray-500">
                            Por: {order.user_profiles?.display_name || 'Usuario'}
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          statusConfig[order.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                        }`}>
                          {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        {formatPrice(order.total || 0)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {order.created_at ? new Date(order.created_at).toLocaleDateString('es-CO') : 'Sin fecha'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <div className="flex items-center space-x-2">
                          <Link
                            to={`/mi-sucursal/ordenes/${order.id || ''}`}
                            className="flex items-center space-x-1 px-3 py-1 text-sm text-blue-600 hover:bg-blue-50 rounded-md transition-colors duration-200"
                          >
                            <Eye className="h-4 w-4" />
                            <span>Ver</span>
                          </Link>

                          {order.status === 'borrador' && (
                            <Link
                              to={`/mi-sucursal/ordenes/${order.id || ''}/editar`}
                              className="flex items-center space-x-1 px-3 py-1 text-sm text-purple-600 hover:bg-purple-50 rounded-md transition-colors duration-200"
                            >
                              <Edit className="h-4 w-4" />
                              <span>Editar</span>
                            </Link>
                          )}

                          {order.status === 'borrador' && (
                            <button
                              onClick={() => order.id && handleSendForApproval(order.id)}
                              className="flex items-center space-x-1 px-3 py-1 text-sm text-green-600 hover:bg-green-50 rounded-md transition-colors duration-200"
                            >
                              <Send className="h-4 w-4" />
                              <span>Enviar</span>
                            </button>
                          )}
                        </div>
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
                    Mostrando {(currentPage - 1) * ordersPerPage + 1} a {Math.min(currentPage * ordersPerPage, totalCount)} de {totalCount} pedidos
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

            {orders.length === 0 && !isLoading && (
              <div className="text-center py-12">
                <Clock className="h-16 w-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay pedidos</h3>
                <p className="text-gray-600 mb-4">
                  {statusFilter === 'all' 
                    ? 'Aún no has creado ningún pedido'
                    : 'No hay pedidos con este estado'
                  }
                </p>
                <Link
                  to="/mi-sucursal/nuevo-pedido"
                  className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
                >
                  Crear Primer Pedido
                </Link>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}