import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit, Trash2, MapPin, Building } from 'lucide-react';
import { useClientContext } from '../../hooks/useClientContext';
import { supabase } from '../../lib/supabase';
import LoadingSpinner from '../../components/UI/LoadingSpinner';

interface Branch {
  id: string;
  client_id: string;
  name: string;
  code: string | null;
  address: string | null;
  created_at: string;
}

interface BranchFormData {
  name: string;
  code: string;
  address: string;
}

export default function MasterSucursales() {
  const { 
    selectedClientId, 
    clients,
    isLoading: contextLoading 
  } = useClientContext();
  
  const [branches, setBranches] = useState<Branch[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingBranch, setEditingBranch] = useState<Branch | null>(null);
  const [formData, setFormData] = useState<BranchFormData>({ 
    name: '', 
    code: '', 
    address: '' 
  });
  const [isSubmitting, setIsSubmitting] = useState(false);

  const selectedClient = clients.find(c => c.id === selectedClientId);
  
  useEffect(() => {
    if (selectedClientId) {
      loadBranches();
    } else {
      setBranches([]);
      setIsLoading(false);
    }
  }, [selectedClientId, searchQuery]);

  const loadBranches = async () => {
    if (!selectedClientId) return;

    try {
      setIsLoading(true);
      setError(null);
      console.debug('master:sucursales:fetch:start', { clientId: selectedClientId, searchQuery });

      let query = supabase
        .from('client_branches')
        .select('*')
        .eq('client_id', selectedClientId)
        .order('created_at', { ascending: false });

      if (searchQuery) {
        query = query.ilike('name', `%${searchQuery}%`);
      }

      const { data, error } = await query;

      if (error) throw error;

      console.debug('master:sucursales:fetch:ok', data?.length || 0);
      setBranches(data || []);
    } catch (err) {
      console.error('master:sucursales:fetch:err', err);
      setError(err instanceof Error ? err.message : 'Error loading branches');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting || !selectedClientId) return;

    try {
      setIsSubmitting(true);
      console.debug('master:sucursales:save:start', editingBranch ? 'edit' : 'create');

      const branchData = {
        client_id: selectedClientId,
        name: formData.name.trim(),
        code: formData.code.trim() || null,
        address: formData.address.trim() || null
      };

      if (editingBranch) {
        const { error } = await supabase
          .from('client_branches')
          .update(branchData)
          .eq('id', editingBranch.id);

        if (error) throw error;
      } else {
        const { error } = await supabase
          .from('client_branches')
          .insert([branchData]);

        if (error) throw error;
      }

      console.debug('master:sucursales:save:ok');
      setShowModal(false);
      setEditingBranch(null);
      setFormData({ name: '', code: '', address: '' });
      loadBranches();
    } catch (error: any) {
      console.error('master:sucursales:save:err', error);
      alert('Error al guardar la sucursal: ' + error.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEdit = (branch: Branch) => {
    setEditingBranch(branch);
    setFormData({ 
      name: branch.name, 
      code: branch.code || '', 
      address: branch.address || '' 
    });
    setShowModal(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm('¿Estás seguro de que quieres eliminar esta sucursal?')) return;

    try {
      console.debug('master:sucursales:delete:start', id);
      
      const { error } = await supabase
        .from('client_branches')
        .delete()
        .eq('id', id)
        .eq('client_id', selectedClientId);

      if (error) throw error;

      console.debug('master:sucursales:delete:ok', id);
      loadBranches();
    } catch (error) {
      console.error('master:sucursales:delete:err', error);
      alert('Error al eliminar la sucursal');
    }
  };

  const openCreateModal = () => {
    setEditingBranch(null);
    setFormData({ name: '', code: '', address: '' });
    setShowModal(true);
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
          <Building className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar sucursales</h3>
        <p className="text-gray-600 mb-4">{error}</p>
        <button
          onClick={loadBranches}
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
          <div>
            <h2 className="text-lg font-semibold text-gray-900">Sucursales de {selectedClient?.name || 'tu empresa'}</h2>
            <p className="text-gray-600 text-sm">Administra las ubicaciones de tu empresa</p>
          </div>
          <button
            onClick={openCreateModal}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nueva Sucursal</span>
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

      {/* Branches Table */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Sucursal
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Código
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Dirección
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Fecha de Creación
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Acciones
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {branches.map((branch) => (
                <tr key={branch.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center">
                      <MapPin className="h-5 w-5 text-gray-400 mr-3" />
                      <div className="text-sm font-medium text-gray-900">
                        {branch.name}
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {branch.code || '-'}
                  </td>
                  <td className="px-6 py-4 text-sm text-gray-900 max-w-xs truncate">
                    {branch.address || '-'}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {new Date(branch.created_at).toLocaleDateString('es-CO')}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                    <button
                      onClick={() => handleEdit(branch)}
                      className="text-indigo-600 hover:text-indigo-900"
                      title="Editar sucursal"
                    >
                      <Edit className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => handleDelete(branch.id)}
                      className="text-red-600 hover:text-red-900"
                      title="Eliminar sucursal"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {branches.length === 0 && !isLoading && (
          <div className="text-center py-12">
            <MapPin className="h-16 w-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay sucursales</h3>
            <p className="text-gray-600 mb-4">Crea la primera sucursal de tu empresa</p>
            <button
              onClick={openCreateModal}
              className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
            >
              Crear Sucursal
            </button>
          </div>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200">
              <h3 className="text-lg font-semibold text-gray-900">
                {editingBranch ? 'Editar Sucursal' : 'Nueva Sucursal'}
              </h3>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nombre de la Sucursal *
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
                  Código de Sucursal
                </label>
                <input
                  type="text"
                  value={formData.code}
                  onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Ej: SUC001"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Dirección
                </label>
                <textarea
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  rows={3}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Dirección completa de la sucursal"
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
                  <span>{isSubmitting ? 'Guardando...' : (editingBranch ? 'Actualizar' : 'Crear')}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}