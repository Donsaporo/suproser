import React, { useEffect, useState } from 'react';
import { Search, Filter, CheckCircle, XCircle, Eye, Plus } from 'lucide-react';
import { Link } from 'react-router-dom';
import { showSuccess, showError } from '../../utils/toast';
import { useClientContext } from '../../hooks/useClientContext';
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
  anulado: { label: 'Anulado', color: 'bg-red-100 text-red-800' },
};

export default function MasterOrdenes() {
  const { branches, selectedClientId, clients, isLoading: contextLoading } = useClientContext();

  const [orders, setOrders] = useState<Order[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [statusFilter, setStatusFilter] = useState('all');
  const [branchFilter, setBranchFilter] = useState('');
  const [currentPage, setCurrentPage] = useState(1);

  const [rejectingOrder, setRejectingOrder] = useState<string | null>(null);
  const [rejectNote, setRejectNote] = useState('');

  const selectedClient = selectedClientId ? clients.find((c) => c.id === selectedClientId) : null;
  const contextReady =
    !contextLoading &&
    !!selectedClientId &&
    (clients.length === 0 || clients.some((c) => c.id === selectedClientId));

  const ordersPerPage = 10;

  useEffect(() => {
    if (contextReady && selectedClientId) {
      loadOrders();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [contextReady, selectedClientId, statusFilter, branchFilter, currentPage]);

  const loadOrders = async () => {
    if (!selectedClientId) return;

    try {
      setIsLoading(true);
      setError(null);
      console.debug('master:ordenes:fetch:start', {
        clientId: selectedClientId,
        status: statusFilter,
        branch: branchFilter,
        page: currentPage,
      });

      const { data, count } = await getOrders(selectedClientId, {
        status: statusFilter === 'all' ? undefined : statusFilter,
        branchId: branchFilter || undefined,
        page: currentPage,
        limit: ordersPerPage,
      });

      setOrders(data);
      setTotalCount(count);
      console.debug('master:ordenes:fetch:ok', data.length, 'total:', count);
    } catch (err: any) {
      console.error('master:ordenes:fetch:err', err);
      setError(err?.message || 'Error loading orders');
    } finally {
      setIsLoading(false);
    }
  };

  const handleApproveOrder = async (orderId: string) => {
    try {
      console.debug('master:ordenes:approve:start', orderId);
      await updateOrderStatus(orderId, 'aprobado');
      console.debug('master:ordenes:approve:ok', orderId);
      loadOrders();
      showSuccess('Orden aprobada', 'La orden ha sido aprobada exitosamente');
    } catch (error) {
      console.error('master:ordenes:approve:err', error);
      showError('Error al aprobar', 'No se pudo aprobar la orden');
    }
  };

  const handleRejectOrder = async (orderId: string, note?: string) => {
    try {
      console.debug('master:ordenes:reject:start', orderId);
      await updateOrderStatus(orderId, 'anulado', note);
      console.debug('master:ordenes:reject:ok', orderId);
      setRejectingOrder(null);
      setRejectNote('');
      loadOrders();
      showSuccess('Orden rechazada', 'La orden ha sido rechazada');
    } catch (error) {
      console.error('master:ordenes:reject:err', error);
      showError('Error al rechazar', 'No se pudo rechazar la orden');
    }
  };

  const totalPages = Math.ceil(totalCount / ordersPerPage);

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
          <Filter className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar órdenes</h3>
        <p className="text-gray-600 mb-4">{error}</p>
        <button
          to="/mi-empresa/nueva-orden"
          className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
        >
          Reintentar
        </button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex justify-between items-center mb-4">
          <div>
            <h2 className="text-lg font-semibold text-gray-900">Órdenes de {selectedClient?.name}</h2>
            <p className="text-gray-600 text-sm">Administra todas las órdenes de tus sucursales</p>
          </div>
          <Link
            to="/mi-empresa/nueva-orden"
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nueva Orden</span>
          </Link>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Estado</label>
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
              <option value="aprobado">Aprobadas</option>
              <option value="pagado">Pagadas</option>
              <option value="completado">Completadas</option>
              <option value="anulado">Anuladas</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Sucursal</label>
            <select
              value={branchFilter}
              onChange={(e) => {
                setBranchFilter(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todas las sucursales</option>
              {branches
                .filter((b) => b.client_id === selectedClientId)
                .map((branch) => (
                  <option key={branch.id} value={branch.id}>
                    {branch.name}
                  </option>
                ))}
            </select>
          </div>
        </div>
      </div>

      {/* Orders List */}
      <div className="bg-white rounded-lg shadow-md">
        {isLoading ? (
          <div className="flex justify-center items-center h-64">
            <LoadingSpinner size="lg" />
          </div>
        ) : error ? (
          <div className="text-center py-12">
            <div className="text-red-400 mb-4">
              <Filter className="h-16 w-16 mx-auto" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar órdenes</h3>
            <p className="text-gray-600 mb-4">{error}</p>
            <button
              onClick={loadOrders}
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
                      Orden
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Sucursal
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
                        <div className="flex items-center">
                          <div>
                            <Link
                              to={`/mi-empresa/ordenes/${order.id}`}
                              className="text-sm font-medium text-blue-600 hover:text-blue-800"
                            >
                              #{order.id.slice(-8).toUpperCase()}
                            </Link>
                            <div className="text-sm text-gray-500">
                              {order.user_profiles?.display_name || 'Usuario'}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {order.client_branches?.name || 'Sin sucursal'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span
                          className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                            statusConfig[order.status as keyof typeof statusConfig]?.color ||
                            'bg-gray-100 text-gray-800'
                          }`}
                        >
                          {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        {formatPrice(order.total || 0)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {order.created_at
                          ? new Date(order.created_at).toLocaleDateString('es-CO')
                          : 'Sin fecha'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <div className="flex items-center space-x-2">
                          <Link
                            to={`/mi-empresa/ordenes/${order.id || ''}`}
                            className="flex items-center space-x-1 px-3 py-1 text-sm text-blue-600 hover:bg-blue-50 rounded-md transition-colors duration-200"
                          >
                            <Eye className="h-4 w-4" />
                            <span>Ver</span>
                          </Link>

                          {order.status === 'pendiente_aprobacion' && (
                            <>
                              <button
                                onClick={() => order.id && handleApproveOrder(order.id)}
                                className="flex items-center space-x-1 px-3 py-1 text-sm text-green-600 hover:bg-green-50 rounded-md transition-colors duration-200"
                              >
                                <CheckCircle className="h-4 w-4" />
                                <span>Aprobar</span>
                              </button>

                              <button
                                onClick={() => order.id && setRejectingOrder(order.id)}
                                className="flex items-center space-x-1 px-3 py-1 text-sm text-red-600 hover:bg-red-50 rounded-md transition-colors duración-200"
                              >
                                <XCircle className="h-4 w-4" />
                                <span>Rechazar</span>
                              </button>
                            </>
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
                    Mostrando {(currentPage - 1) * ordersPerPage + 1} a{' '}
                    {Math.min(currentPage * ordersPerPage, totalCount)} de {totalCount} órdenes
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
                <div className="text-gray-400 mb-4">
                  <Filter className="h-16 w-16 mx-auto" />
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay órdenes</h3>
                <p className="text-gray-600">No se encontraron órdenes con los filtros aplicados</p>
              </div>
            )}
          </>
        )}
      </div>

      {/* Reject Modal */}
      {rejectingOrder && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">Rechazar Orden</h3>
            </div>

            <div className="p-6">
              <p className="text-gray-600 mb-4">¿Estás seguro de que quieres rechazar esta orden?</p>

              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1">Nota (opcional)</label>
                <textarea
                  value={rejectNote}
                  onChange={(e) => setRejectNote(e.target.value)}
                  rows={3}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-red-500 focus:border-transparent"
                  placeholder="Razón del rechazo..."
                />
              </div>

              <div className="flex justify-end space-x-3">
                <button
                  onClick={() => {
                    setRejectingOrder(null);
                    setRejectNote('');
                  }}
                  className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors duration-200"
                >
                  Cancelar
                </button>
                <button
                  onClick={() => handleRejectOrder(rejectingOrder!, rejectNote)}
                  className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors duration-200"
                >
                  Rechazar
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}