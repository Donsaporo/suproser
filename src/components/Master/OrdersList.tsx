import React, { useState } from 'react';
import { Eye, CheckCircle, XCircle, Clock, CreditCard } from 'lucide-react';
import { formatPrice } from '../../utils/format';
import type { Order } from '../../services/orders';

interface OrdersListProps {
  orders: Order[];
  isLoading: boolean;
  onViewOrder: (orderId: string) => void;
  onApproveOrder: (orderId: string) => void;
  onRejectOrder: (orderId: string, note?: string) => void;
  onPayOrder?: (orderId: string) => void;
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

export default function OrdersList({ 
  orders, 
  isLoading, 
  onViewOrder, 
  onApproveOrder, 
  onRejectOrder,
  onPayOrder 
}: OrdersListProps) {
  const [rejectingOrder, setRejectingOrder] = useState<string | null>(null);
  const [rejectNote, setRejectNote] = useState('');

  const handleRejectSubmit = () => {
    if (rejectingOrder) {
      onRejectOrder(rejectingOrder, rejectNote);
      setRejectingOrder(null);
      setRejectNote('');
    }
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
        <Clock className="h-16 w-16 text-gray-300 mx-auto mb-4" />
        <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay órdenes</h3>
        <p className="text-gray-600">No se encontraron órdenes con los filtros aplicados</p>
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
                Orden #{order.id.slice(-8).toUpperCase()}
              </h3>
              <p className="text-sm text-gray-600">
                {order.client_branches.name} • {order.user_profiles.display_name || 'Usuario'}
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
                {formatPrice(order.total || 0)}
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
              <Eye className="h-4 w-4" />
              <span>Ver</span>
            </button>

            {order.status === 'pendiente_aprobacion' && (
              <>
                <button
                  onClick={() => onApproveOrder(order.id)}
                  className="flex items-center space-x-1 px-3 py-1 text-sm text-green-600 hover:bg-green-50 rounded-md transition-colors duration-200"
                >
                  <CheckCircle className="h-4 w-4" />
                  <span>Aprobar</span>
                </button>
                
                <button
                  onClick={() => setRejectingOrder(order.id)}
                  className="flex items-center space-x-1 px-3 py-1 text-sm text-red-600 hover:bg-red-50 rounded-md transition-colors duration-200"
                >
                  <XCircle className="h-4 w-4" />
                  <span>Rechazar</span>
                </button>
              </>
            )}

            {order.status === 'aprobado' && onPayOrder && (
              <button
                onClick={() => onPayOrder(order.id)}
                className="flex items-center space-x-1 px-3 py-1 text-sm text-purple-600 hover:bg-purple-50 rounded-md transition-colors duration-200"
              >
                <CreditCard className="h-4 w-4" />
                <span>Pagar</span>
              </button>
            )}
          </div>
        </div>
      ))}

      {/* Reject Modal */}
      {rejectingOrder && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">
                Rechazar Orden
              </h3>
            </div>
            
            <div className="p-6">
              <p className="text-gray-600 mb-4">
                ¿Estás seguro de que quieres rechazar esta orden?
              </p>
              
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nota (opcional)
                </label>
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
                  onClick={handleRejectSubmit}
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