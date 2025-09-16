import React, { useState, useEffect } from 'react';
import { Search, Filter, CreditCard, ExternalLink, Calendar, DollarSign } from 'lucide-react';
import { supabase } from '../../lib/supabase';
import LoadingSpinner from '../../components/UI/LoadingSpinner';
import { formatPrice } from '../../utils/format';

interface Payment {
  id: string;
  order_id: string;
  method: 'yappy' | 'bg_cybersource';
  status: 'init' | 'pending' | 'approved' | 'declined' | 'error' | 'refunded';
  amount: number;
  provider_ref: string | null;
  raw: any;
  created_at: string;
}

interface PaymentFilters {
  status: string;
  method: string;
  dateFrom: string;
  dateTo: string;
}

const statusConfig = {
  init: { label: 'Iniciado', color: 'bg-gray-100 text-gray-800' },
  pending: { label: 'Pendiente', color: 'bg-yellow-100 text-yellow-800' },
  approved: { label: 'Aprobado', color: 'bg-green-100 text-green-800' },
  declined: { label: 'Declinado', color: 'bg-red-100 text-red-800' },
  error: { label: 'Error', color: 'bg-red-100 text-red-800' },
  refunded: { label: 'Reembolsado', color: 'bg-blue-100 text-blue-800' }
};

const methodConfig = {
  yappy: { label: 'Yappy', color: 'bg-purple-100 text-purple-800' },
  bg_cybersource: { label: 'CyberSource', color: 'bg-indigo-100 text-indigo-800' }
};

export default function AdminPayments() {
  const [payments, setPayments] = useState<Payment[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalCount, setTotalCount] = useState(0);
  
  const [filters, setFilters] = useState<PaymentFilters>({
    status: '',
    method: '',
    dateFrom: '',
    dateTo: ''
  });

  const paymentsPerPage = 20;

  useEffect(() => {
    let isMounted = true;

    const fetchPayments = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:pagos:fetch:start', { filters, page: currentPage });
        
        const data = await loadPaymentsData();
        console.debug('admin:pagos:fetch:ok', data.payments.length, 'total:', data.count);
        
        if (isMounted) {
          setPayments(data.payments);
          setTotalCount(data.count);
        }
      } catch (err) {
        console.error('admin:pagos:fetch:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading payments');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchPayments();

    return () => {
      isMounted = false;
    };
  }, [filters, currentPage]);

  const loadPaymentsData = async () => {
    let query = supabase
      .from('payments')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false });

    // Apply filters
    if (filters.status) {
      query = query.eq('status', filters.status);
    }

    if (filters.method) {
      query = query.eq('method', filters.method);
    }

    if (filters.dateFrom) {
      query = query.gte('created_at', new Date(filters.dateFrom).toISOString());
    }

    if (filters.dateTo) {
      const endDate = new Date(filters.dateTo);
      endDate.setHours(23, 59, 59, 999);
      query = query.lte('created_at', endDate.toISOString());
    }

    // Apply pagination
    const from = (currentPage - 1) * paymentsPerPage;
    const to = from + paymentsPerPage - 1;
    query = query.range(from, to);

    const { data, error, count } = await query;

    if (error) throw error;

    return {
      payments: data || [],
      count: count || 0
    };
  };

  const handleFilterChange = (field: keyof PaymentFilters, value: string) => {
    setFilters(prev => ({ ...prev, [field]: value }));
    setCurrentPage(1);
  };

  const clearFilters = () => {
    setFilters({
      status: '',
      method: '',
      dateFrom: '',
      dateTo: ''
    });
    setCurrentPage(1);
  };

  const handleRetry = () => {
    window.location.reload();
  };

  const totalPages = Math.ceil(totalCount / paymentsPerPage);

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <CreditCard className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar pagos</h3>
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
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Gestión de Pagos</h1>
        <p className="text-gray-600">Administra los pagos y transacciones del sistema</p>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Filtros</h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Estado
            </label>
            <select
              value={filters.status}
              onChange={(e) => handleFilterChange('status', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todos los estados</option>
              <option value="init">Iniciado</option>
              <option value="pending">Pendiente</option>
              <option value="approved">Aprobado</option>
              <option value="declined">Declinado</option>
              <option value="error">Error</option>
              <option value="refunded">Reembolsado</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Método
            </label>
            <select
              value={filters.method}
              onChange={(e) => handleFilterChange('method', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todos los métodos</option>
              <option value="yappy">Yappy</option>
              <option value="bg_cybersource">CyberSource</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Desde
            </label>
            <input
              type="date"
              value={filters.dateFrom}
              onChange={(e) => handleFilterChange('dateFrom', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Hasta
            </label>
            <input
              type="date"
              value={filters.dateTo}
              onChange={(e) => handleFilterChange('dateTo', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>

        <div className="mt-4 flex justify-end">
          <button
            onClick={clearFilters}
            className="text-gray-600 hover:text-gray-800 text-sm"
          >
            Limpiar filtros
          </button>
        </div>
      </div>

      {/* Payments Table */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        {isLoading ? (
          <div className="flex justify-center items-center h-64">
            <LoadingSpinner size="lg" />
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
                      Método
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Estado
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Monto
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Referencia
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Fecha
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {payments.map((payment) => (
                    <tr key={payment.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <CreditCard className="h-4 w-4 text-gray-400 mr-2" />
                          <div>
                            <div className="text-sm font-medium text-blue-600">
                              #{payment.order_id.slice(-8).toUpperCase()}
                            </div>
                            <button
                              onClick={() => console.log('View order:', payment.order_id)}
                              className="text-xs text-gray-500 hover:text-blue-600 flex items-center"
                              title="Ver orden completa"
                            >
                              <ExternalLink className="h-3 w-3 mr-1" />
                              Ver orden
                            </button>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          methodConfig[payment.method as keyof typeof methodConfig]?.color || 'bg-gray-100 text-gray-800'
                        }`}>
                          {methodConfig[payment.method as keyof typeof methodConfig]?.label || payment.method}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          statusConfig[payment.status as keyof typeof statusConfig]?.color || 'bg-gray-100 text-gray-800'
                        }`}>
                          {statusConfig[payment.status as keyof typeof statusConfig]?.label || payment.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        {formatPrice(payment.amount || 0)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {payment.provider_ref || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(payment.created_at).toLocaleDateString('es-CO', {
                          year: 'numeric',
                          month: 'short',
                          day: 'numeric',
                          hour: '2-digit',
                          minute: '2-digit'
                        })}
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
                    Mostrando {(currentPage - 1) * paymentsPerPage + 1} a {Math.min(currentPage * paymentsPerPage, totalCount)} de {totalCount} pagos
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

            {payments.length === 0 && !isLoading && (
              <div className="text-center py-12">
                <CreditCard className="h-16 w-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay pagos</h3>
                <p className="text-gray-600">No se encontraron pagos con los filtros aplicados</p>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}