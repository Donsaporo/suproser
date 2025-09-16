import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit, Trash2, Building, Users } from 'lucide-react';
import { Link } from 'react-router-dom';
import { supabase } from '../../lib/supabase';
import LoadingSpinner from '../../components/UI/LoadingSpinner';

interface Client {
  id: string;
  name: string;
  tax_id: string | null;
  billing_email: string | null;
  created_at: string;
}

interface ClientFormData {
  name: string;
  tax_id: string;
  billing_email: string;
}

export default function AdminClients() {
  const [clients, setClients] = useState<Client[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingClient, setEditingClient] = useState<Client | null>(null);
  const [formData, setFormData] = useState<ClientFormData>({ name: '', tax_id: '', billing_email: '' });
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    let isMounted = true;

    const fetchClients = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:clientes:fetch:start', { searchQuery });
        
        const data = await loadClientsData();
        console.debug('admin:clientes:fetch:ok', data.length);
        
        if (isMounted) {
          setClients(data);
        }
      } catch (err) {
        console.error('admin:clientes:fetch:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading clients');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    fetchClients();

    return () => {
      isMounted = false;
    };
  }, [searchQuery]);

  const loadClientsData = async () => {
    let query = supabase
      .from('clients')
      .select('*')
      .order('name', { ascending: true });

    if (searchQuery) {
      query = query.ilike('name', `%${searchQuery}%`);
    }

    const { data, error } = await query;

    if (error) throw error;

    return data || [];
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;

    try {
      setIsSubmitting(true);
      console.debug('admin:clientes:save:start', editingClient ? 'edit' : 'create');

      const clientData = {
        name: formData.name.trim(),
        tax_id: formData.tax_id.trim() || null,
        billing_email: formData.billing_email.trim() || null
      };

      if (editingClient) {
        const { error } = await supabase
          .from('clients')
          .update(clientData)
          .eq('id', editingClient.id);

        if (error) throw error;
        console.debug('admin:clientes:save:ok', editingClient.id);
      } else {
        const { error } = await supabase
          .from('clients')
          .insert([clientData]);

        if (error) throw error;
        console.debug('admin:clientes:save:ok', 'new');
      }

      setShowModal(false);
      setEditingClient(null);
      setFormData({ name: '', tax_id: '', billing_email: '' });
      // Refetch clients  
      const data = await loadClientsData();
      setClients(data);
    } catch (error: any) {
      console.error('admin:clientes:save:err', error);
      if (error.code === '23505') {
        alert('Ya existe un cliente con ese nombre');
      } else {
        alert('Error al guardar el cliente: ' + error.message);
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEdit = (client: Client) => {
    setEditingClient(client);
    setFormData({ 
      name: client.name, 
      tax_id: client.tax_id || '', 
      billing_email: client.billing_email || '' 
    });
    setShowModal(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('¿Estás seguro de que quieres eliminar este cliente?')) return;

    try {
      console.debug('admin:clientes:delete:start', id);
      
      const { error } = await supabase
        .from('clients')
        .delete()
        .eq('id', id);

      if (error) throw error;

      console.debug('admin:clientes:delete:ok', id);
      
      // Refetch clients
      const data = await loadClientsData();
      setClients(data);
    } catch (error) {
      console.error('admin:clientes:delete:err', error);
      alert('Error al eliminar el cliente. Puede que tenga datos asociados.');
    }
  };

  const openCreateModal = () => {
    setEditingClient(null);
    setFormData({ name: '', tax_id: '', billing_email: '' });
    setShowModal(true);
  };

  const handleRetry = () => {
    window.location.reload();
  };

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <Building className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar clientes</h3>
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
      {/* Search and Create */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-lg font-semibold text-gray-900">Gestión de Clientes</h2>
          <button
            onClick={openCreateModal}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nuevo Cliente</span>
          </button>
        </div>

        <div className="max-w-md">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              type="text"
              placeholder="Buscar por nombre..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>
      </div>

      {/* Clients Table */}
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
                      Cliente
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      RUC/NIT
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Email Facturación
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Fecha Creación
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Acciones
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {clients.map((client) => (
                    <tr key={client.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <Building className="h-5 w-5 text-gray-400 mr-3" />
                          <div className="text-sm font-medium text-gray-900">
                            {client.name}
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {client.tax_id || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {client.billing_email || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(client.created_at).toLocaleDateString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                        <button
                          onClick={() => handleEdit(client)}
                          className="text-indigo-600 hover:text-indigo-900"
                          title="Editar cliente"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <Link
                          to={`/admin/usuarios-cliente?client=${client.id}`}
                          className="text-blue-600 hover:text-blue-900"
                          title="Ver usuarios del cliente"
                        >
                          <Users className="h-4 w-4" />
                        </Link>
                        <button
                          onClick={() => handleDelete(client.id)}
                          className="text-red-600 hover:text-red-900"
                          title="Eliminar cliente"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {clients.length === 0 && !isLoading && (
              <div className="text-center py-12">
                <Building className="h-16 w-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay clientes</h3>
                <p className="text-gray-600 mb-4">Crea el primer cliente para comenzar</p>
                <button
                  onClick={openCreateModal}
                  className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
                >
                  Crear Cliente
                </button>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">
                {editingClient ? 'Editar Cliente' : 'Nuevo Cliente'}
              </h3>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nombre del Cliente *
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  RUC/NIT
                </label>
                <input
                  type="text"
                  value={formData.tax_id}
                  onChange={(e) => setFormData({ ...formData, tax_id: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email de Facturación
                </label>
                <input
                  type="email"
                  value={formData.billing_email}
                  onChange={(e) => setFormData({ ...formData, billing_email: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              
              <div className="flex justify-end space-x-3 pt-4">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors duration-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 flex items-center space-x-2"
                >
                  {isSubmitting && <LoadingSpinner size="sm" />}
                  <span>{isSubmitting ? 'Guardando...' : (editingClient ? 'Actualizar' : 'Crear')}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}