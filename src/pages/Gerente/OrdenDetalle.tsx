import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, Clock, Package, Send, Edit } from 'lucide-react';
import { getOrder, updateOrderStatus } from '../../services/orders';
import type { OrderWithItems } from '../../services/orders';
import { supabase } from '../../lib/supabase';
import { showSuccess, showError } from '../../utils/toast';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';
import YappyButton from '../../components/Payments/YappyButton';

interface StatusHistoryEntry {
  id: number;
  from_status: string | null;
  to_status: string;
  at: string;
  note: string | null;
}

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

export default function GerenteOrdenDetalle() {
  const { id } = useParams<{ id: string }>();
  const [order, setOrder] = useState<OrderWithItems | null>(null);
  const [statusHistory, setStatusHistory] = useState<StatusHistoryEntry[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isSending, setIsSending] = useState(false);

  useEffect(() => {
    if (id) {
      loadOrder();
      loadStatusHistory();
    }
  }, [id]);

  const loadOrder = async () => {
    if (!id) return;

    try {
      console.debug('gerente:orden:detail:fetch:start', id);
      const orderData = await getOrder(id);
      console.debug('gerente:orden:detail:fetch:ok', orderData.status);
      setOrder(orderData);
    } catch (err) {
      console.error('gerente:orden:detail:fetch:err', err);
      setError(err instanceof Error ? err.message : 'Error loading order');
    } finally {
      setIsLoading(false);
    }
  };

  const loadStatusHistory = async () => {
    if (!id) return;

    try {
      console.debug('gerente:orden:history:fetch:start', id);
      const { data, error } = await supabase
        .from('order_status_history')
        .select('id, from_status, to_status, at, note')
        .eq('order_id', id)
        .order('at', { ascending: false });

      if (error) throw error;

      console.debug('gerente:orden:history:fetch:ok', data?.length || 0);
      setStatusHistory(data || []);
    } catch (err) {
      console.error('gerente:orden:history:fetch:err', err);
    }
  };

  const handleSendForApproval = async () => {
    if (!order) return;

    try {
      setIsSending(true);
      console.debug('gerente:orden:send-approval:start', order.id);
      await updateOrderStatus(order.id, 'pendiente_aprobacion');
      console.debug('gerente:orden:send-approval:ok', order.id);
      loadOrder();
      loadStatusHistory();
      showSuccess('Enviado a aprobación', 'El pedido ha sido enviado para aprobación del Master');
    } catch (error) {
      console.error('gerente:orden:send-approval:err', error);
      showError('Error al enviar', 'No se pudo enviar el pedido para aprobación');
    } finally {
      setIsSending(false);
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
            <div className="flex items-center space-x-4">
              <div>
                <h1 className="text-2xl font-bold text-gray-900">
                  Pedido #{order.id.slice(-8).toUpperCase()}
                </h1>
                <p className="text-gray-600">
                  {order.client_branches?.name} • {order.user_profiles?.display_name || 'Usuario'}
                </p>
                <p className="text-sm text-gray-500">
                  Creado el {new Date(order.created_at || '').toLocaleDateString('es-CO', {
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                  })}
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-4">
            <span className={`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${
              statusConfig[order.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
            }`}>
              {statusConfig[order.status as keyof typeof statusConfig]?.label || order.status}
            </span>

            {order.status === 'borrador' && (
              <div className="flex space-x-2">
                <Link
                  to={`/mi-sucursal/ordenes/${order.id}/editar`}
                  className="bg-purple-600 text-white px-4 py-2 rounded-md hover:bg-purple-700 transition-colors duration-200 flex items-center space-x-2"
                >
                  <Edit className="h-4 w-4" />
                  <span>Editar</span>
                </Link>
                <button
                  onClick={handleSendForApproval}
                  disabled={isSending}
                  className="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition-colors duration-200 flex items-center space-x-2 disabled:opacity-50"
                >
                  {isSending ? (
                    <LoadingSpinner size="sm" />
                  ) : (
                    <Send className="h-4 w-4" />
                  )}
                  <span>{isSending ? 'Enviando...' : 'Enviar a Aprobación'}</span>
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Order Items */}
      <div className="bg-white rounded-lg shadow-md">
        <div className="px-6 py-4 border-b border-gray-200">
          <h3 className="text-lg font-semibold text-gray-900">Productos</h3>
        </div>
        <div className="overflow-x-auto">
          <div className="min-w-full">
            <div className="overflow-hidden">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Producto
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Cantidad
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Precio Unit.
                    </th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Total
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {order.order_items?.map((item) => (
                    <tr key={item.id}>
                      <td className="px-4 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <div className="flex-shrink-0 h-12 w-12">
                            <img
                              className="h-12 w-12 rounded-lg object-cover"
                              src={item.products?.image_url || '/placeholder-product.png'}
                              alt={item.products?.name || 'Producto'}
                            />
                          </div>
                          <div className="ml-4">
                            <div className="text-sm font-medium text-gray-900">
                              {item.products?.name || 'Producto sin nombre'}
                            </div>
                            <div className="text-sm text-gray-500">
                              {item.products?.sku || 'Sin SKU'}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                        {parseFloat(item.qty).toLocaleString()}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm text-gray-900">
                        {formatPrice(item.unit_price)}
                      </td>
                      <td className="px-4 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        {formatPrice(item.line_total)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Order Total */}
        <div className="px-6 py-4 border-t border-gray-200">
          <div className="flex justify-end">
            <div className="text-right">
              <div className="text-lg font-semibold text-gray-900">
                Total: {formatPrice(order.total_amount)}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Status History */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Historial de Estados</h3>
        
        <div className="space-y-4">
          {statusHistory.map((entry, index) => (
            <div key={entry.id} className="flex items-start space-x-3">
              <div className="flex-shrink-0">
                <div className="w-3 h-3 bg-blue-600 rounded-full mt-2"></div>
                {index < statusHistory.length - 1 && (
                  <div className="w-0.5 h-8 bg-gray-200 ml-1 mt-1"></div>
                )}
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center space-x-2">
                  {entry.from_status && (
                    <>
                      <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                        statusConfig[entry.from_status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                      }`}>
                        {statusConfig[entry.from_status as keyof typeof statusConfig]?.label || entry.from_status}
                      </span>
                      <span className="text-gray-400">→</span>
                    </>
                  )}
                  <span className={`inline-flex px-2 py-0.5 text-xs font-medium rounded-full ${
                    statusConfig[entry.to_status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                  }`}>
                    {statusConfig[entry.to_status as keyof typeof statusConfig]?.label || entry.to_status}
                  </span>
                </div>
                <p className="text-sm text-gray-500 mt-1">
                  {new Date(entry.at).toLocaleString('es-CO')}
                </p>
                {entry.note && (
                  <p className="text-sm text-gray-700 mt-1 bg-gray-50 p-2 rounded">
                    {entry.note}
                  </p>
                )}
              </div>
            </div>
          ))}
          {statusHistory.length === 0 && (
            <p className="text-gray-500 text-sm">No hay historial de cambios</p>
          )}
        </div>
      </div>
    </div>
  );
}