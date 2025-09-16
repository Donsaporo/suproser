import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit, Trash2, Users, UserCheck, Building, MapPin, AlertCircle, X } from 'lucide-react';
import { useSearchParams } from 'react-router-dom';
import { supabase } from '../../lib/supabase';
import LoadingSpinner from '../../components/UI/LoadingSpinner';

interface ClientUser {
  id: string;
  user_id: string;
  client_id: string;
  branch_id: string | null;
  role_in_client: 'master' | 'gerente_sucursal';
  created_at: string;
  // Enriched data
  display_name: string | null;
  client_name: string;
  branch_name: string | null;
}

interface Client {
  id: string;
  name: string;
}

interface Branch {
  id: string;
  name: string;
  client_id: string;
}

interface UserProfile {
  user_id: string;
  display_name: string | null;
  role_app: string | null;
}

interface AssignUserFormData {
  client_id: string;
  branch_id: string;
  role_in_client: 'master' | 'gerente_sucursal';
  selected_user: UserProfile | null;
  manual_user_id: string;
}

export default function AdminClientUsers() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [clientUsers, setClientUsers] = useState<ClientUser[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [branches, setBranches] = useState<Branch[]>([]);
  const [userProfiles, setUserProfiles] = useState<UserProfile[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  
  // Filters - get from URL params
  const [searchQuery, setSearchQuery] = useState(searchParams.get('search') || '');
  const [selectedClient, setSelectedClient] = useState(searchParams.get('client') || '');
  const [selectedBranch, setSelectedBranch] = useState(searchParams.get('branch') || '');
  const [selectedRole, setSelectedRole] = useState(searchParams.get('role') || '');
  const [currentPage, setCurrentPage] = useState(parseInt(searchParams.get('page') || '1'));
  const [totalCount, setTotalCount] = useState(0);
  
  // Modal states
  const [showModal, setShowModal] = useState(false);
  const [editingUser, setEditingUser] = useState<ClientUser | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSearchingUsers, setIsSearchingUsers] = useState(false);
  const [userSearchQuery, setUserSearchQuery] = useState('');
  const [formData, setFormData] = useState<AssignUserFormData>({
    client_id: '',
    branch_id: '',
    role_in_client: 'gerente_sucursal',
    selected_user: null,
    manual_user_id: ''
  });

  const pageSize = 25;
  const isDev = import.meta.env.DEV;

  useEffect(() => {
    let isMounted = true;

    const initializeData = async () => {
      if (!isMounted) return;
      
      try {
        setIsLoading(true);
        setError(null);
        console.debug('admin:usuarios:init:start');
        
        const data = await loadAllData();
        console.debug('admin:usuarios:init:ok', {
          users: data.clientUsers.length,
          clients: data.clients.length,
          branches: data.branches.length,
          total: data.count
        });
        
        if (isMounted) {
          setClients(data.clients);
          setBranches(data.branches);
          setClientUsers(data.clientUsers);
          setTotalCount(data.count);
        }
      } catch (err) {
        console.error('admin:usuarios:init:err', err);
        if (isMounted) {
          setError(err instanceof Error ? err.message : 'Error loading client users');
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    };

    initializeData();

    return () => {
      isMounted = false;
    };
  }, [searchQuery, selectedClient, selectedBranch, selectedRole, currentPage]);

  // Update URL params when filters change
  useEffect(() => {
    const params = new URLSearchParams();
    if (searchQuery) params.set('search', searchQuery);
    if (selectedClient) params.set('client', selectedClient);
    if (selectedBranch) params.set('branch', selectedBranch);
    if (selectedRole) params.set('role', selectedRole);
    if (currentPage > 1) params.set('page', currentPage.toString());
    
    setSearchParams(params);
  }, [searchQuery, selectedClient, selectedBranch, selectedRole, currentPage, setSearchParams]);

  // Load user profiles for modal search
  useEffect(() => {
    if (showModal && userSearchQuery.trim() && userSearchQuery.length >= 2) {
      searchUserProfiles();
    } else {
      setUserProfiles([]);
    }
  }, [userSearchQuery, showModal]);

  const loadAllData = async () => {
    console.debug('admin:usuarios:loadAllData:start');

    // Load reference data first
    const [clientsResult, branchesResult] = await Promise.all([
      supabase
        .from('clients')
        .select('id, name')
        .order('name', { ascending: true }),
      supabase
        .from('client_branches')
        .select('id, name, client_id')
        .order('name', { ascending: true })
    ]);

    if (clientsResult.error) throw clientsResult.error;
    if (branchesResult.error) throw branchesResult.error;

    // Load client users with filters
    const clientUsersData = await loadClientUsers();

    return {
      clients: clientsResult.data || [],
      branches: branchesResult.data || [],
      clientUsers: clientUsersData.data,
      count: clientUsersData.count
    };
  };

  const isUUID = (str: string): boolean => {
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    return uuidRegex.test(str);
  };

  const loadClientUsers = async () => {
    console.debug('admin:usuarios:loadClientUsers:start');

    // Build base query
    let query = supabase
      .from('client_users')
      .select(`
        *,
        clients!inner(name),
        client_branches(name)
      `, { count: 'exact' })
      .order('created_at', { ascending: false });

    // Apply filters
    if (selectedClient) {
      query = query.eq('client_id', selectedClient);
    }

    if (selectedBranch) {
      query = query.eq('branch_id', selectedBranch);
    }

    if (selectedRole && ['master', 'gerente_sucursal'].includes(selectedRole)) {
      query = query.eq('role_in_client', selectedRole);
    }

    // Handle search
    if (searchQuery && searchQuery.trim()) {
      const term = searchQuery.trim();
      
      if (isUUID(term)) {
        // Search by user_id directly
        query = query.eq('user_id', term);
      } else if (term.length >= 2) {
        // Search by display_name - first get matching user_ids
        const { data: userIds, error: searchError } = await supabase
          .from('user_profiles')
          .select('user_id')
          .ilike('display_name', `%${term}%`)
          .limit(200);

        if (searchError) throw searchError;

        if (userIds && userIds.length > 0) {
          const userIdsList = userIds.map(u => u.user_id);
          query = query.in('user_id', userIdsList);
        } else {
          // No users found with that display_name - return empty result
          return { data: [], count: 0 };
        }
      }
    }

    // Apply pagination
    const start = (currentPage - 1) * pageSize;
    const end = start + pageSize - 1;
    query = query.range(start, end);

    const { data, error, count } = await query;

    if (error) throw error;

    const clientUsersData = data || [];
    console.debug('admin:usuarios:loadClientUsers:base-data', clientUsersData.length);

    // Get user profiles separately
    const userIds = [...new Set(clientUsersData.map(cu => cu.user_id))];
    console.debug('admin:usuarios:loadClientUsers:user-ids', userIds.length);

    if (userIds.length === 0) {
      return { data: [], count: 0 };
    }

    const { data: profiles, error: profilesError } = await supabase
      .from('user_profiles')
      .select('user_id, display_name')
      .in('user_id', userIds);

    console.debug('admin:usuarios:loadClientUsers:profiles', {
      error: profilesError?.message,
      found: profiles?.length || 0,
      sample: profiles?.[0] ? {
        user_id: profiles[0].user_id.slice(0, 8),
        display_name: profiles[0].display_name
      } : null
    });

    const profilesMap = new Map((profiles || []).map(p => [p.user_id, p.display_name]));

    // Transform data with profile lookup
    const enrichedData: ClientUser[] = clientUsersData.map(cu => {
      const profileName = profilesMap.get(cu.user_id);
      console.debug('admin:usuarios:lookup', {
        user_id: cu.user_id.slice(0, 8),
        found_name: profileName
      });

      return {
        id: cu.id,
        user_id: cu.user_id,
        client_id: cu.client_id,
        branch_id: cu.branch_id,
        role_in_client: cu.role_in_client,
        created_at: cu.created_at,
        display_name: profileName || null,
        client_name: cu.clients?.name || 'Cliente eliminado',
        branch_name: cu.client_branches?.name || null
      };
    });

    return {
      data: enrichedData,
      count: count || 0
    };
  };

  const searchUserProfiles = async () => {
    if (!userSearchQuery.trim() || userSearchQuery.length < 2) return;

    try {
      setIsSearchingUsers(true);
      console.debug('admin:usuarios:search:start', userSearchQuery);
      
      const term = userSearchQuery.trim();
      let query = supabase
        .from('user_profiles')
        .select('user_id, display_name, role_app')
        .limit(20);

      if (isUUID(term)) {
        // Search by exact user_id
        console.debug('admin:usuarios:search:by-id', term);
        query = query.eq('user_id', term);
      } else {
        // Search by display_name
        console.debug('admin:usuarios:search:by-name', term);
        query = query.ilike('display_name', `%${term}%`);
      }

      const { data, error } = await query;

      if (error) {
        console.error('admin:usuarios:search:query-err', error);
        throw error;
      }

      console.debug('admin:usuarios:search:results', {
        found: data?.length || 0,
        sample: data?.[0] ? {
          user_id: data[0].user_id.slice(0, 8),
          display_name: data[0].display_name,
          role_app: data[0].role_app
        } : null
      });

      setUserProfiles(data || []);
    } catch (error) {
      console.error('admin:usuarios:search:err', error);
      setUserProfiles([]);
    } finally {
      setIsSearchingUsers(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isSubmitting) return;

    // Get user_id (from selection or manual input)
    let targetUserId = '';
    if (formData.selected_user) {
      targetUserId = formData.selected_user.user_id;
    } else if (formData.manual_user_id.trim() && isUUID(formData.manual_user_id)) {
      targetUserId = formData.manual_user_id.trim();
    } else {
      alert('Selecciona un usuario válido o ingresa un User ID válido');
      return;
    }

    // Validations
    if (!formData.client_id) {
      alert('Selecciona un cliente');
      return;
    }

    if (formData.role_in_client === 'gerente_sucursal' && !formData.branch_id) {
      alert('Los gerentes requieren una sucursal asignada');
      return;
    }

    try {
      setIsSubmitting(true);
      console.debug('admin:usuarios:assign:start', {
        user_id: targetUserId,
        client_id: formData.client_id,
        role: formData.role_in_client,
        editing: !!editingUser
      });

      // Ensure user_profiles exists
      const { data: existingProfile } = await supabase
        .from('user_profiles')
        .select('user_id')
        .eq('user_id', targetUserId)
        .single();

      if (!existingProfile) {
        // Create basic profile if doesn't exist
        const { error: profileError } = await supabase
          .from('user_profiles')
          .insert({
            user_id: targetUserId,
            role_app: 'cliente_gerente_sucursal',
            display_name: null
          });

        if (profileError && profileError.code !== '23505') { // Ignore duplicate
          throw profileError;
        }
      }

      // Prepare client_user data
      const clientUserData: any = {
        user_id: targetUserId,
        client_id: formData.client_id,
        role_in_client: formData.role_in_client
      };

      // Set branch_id based on role
      if (formData.role_in_client === 'master') {
        clientUserData.branch_id = null;
      } else {
        clientUserData.branch_id = formData.branch_id;
      }

      if (editingUser) {
        // Update existing assignment
        const { error } = await supabase
          .from('client_users')
          .update(clientUserData)
          .eq('id', editingUser.id);

        if (error) throw error;
      } else {
        // Create new assignment
        const { error } = await supabase
          .from('client_users')
          .insert([clientUserData]);

        if (error) {
          // Handle conflicts with upsert
          if (error.code === '23505') {
            // Try to update existing record
            const { error: updateError } = await supabase
              .from('client_users')
              .update({
                role_in_client: clientUserData.role_in_client,
                branch_id: clientUserData.branch_id
              })
              .eq('user_id', targetUserId)
              .eq('client_id', clientUserData.client_id);

            if (updateError) throw updateError;
          } else {
            throw error;
          }
        }
      }

      console.debug('admin:usuarios:assign:ok');
      setShowModal(false);
      setEditingUser(null);
      resetForm();
      
      // Refresh data
      const refreshedData = await loadAllData();
      setClients(refreshedData.clients);
      setBranches(refreshedData.branches);
      setClientUsers(refreshedData.clientUsers);
      setTotalCount(refreshedData.count);

    } catch (error: any) {
      console.error('admin:usuarios:assign:err', error);
      
      let errorMessage = 'Error al asignar usuario';
      if (error.code === '23505') {
        errorMessage = 'Este usuario ya está asignado a este cliente/sucursal con ese rol';
      } else if (error.code === '23503') {
        errorMessage = 'El User ID no existe en el sistema';
      } else if (error.message) {
        errorMessage = error.message;
      }
      
      alert(errorMessage);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleEdit = (clientUser: ClientUser) => {
    setEditingUser(clientUser);
    setFormData({
      client_id: clientUser.client_id,
      branch_id: clientUser.branch_id || '',
      role_in_client: clientUser.role_in_client,
      selected_user: {
        user_id: clientUser.user_id,
        display_name: clientUser.display_name,
        role_app: null
      },
      manual_user_id: ''
    });
    setShowModal(true);
  };

  const handleDelete = async (clientUserId: string) => {
    if (!confirm('¿Estás seguro de que quieres eliminar esta asignación de usuario?')) return;

    try {
      console.debug('admin:usuarios:remove:start', clientUserId);
      
      const { error } = await supabase
        .from('client_users')
        .delete()
        .eq('id', clientUserId);

      if (error) throw error;

      console.debug('admin:usuarios:remove:ok');
      
      // Refresh data
      const refreshedData = await loadAllData();
      setClients(refreshedData.clients);
      setBranches(refreshedData.branches);
      setClientUsers(refreshedData.clientUsers);
      setTotalCount(refreshedData.count);
    } catch (error: any) {
      console.error('admin:usuarios:remove:err', error);
      alert('Error al eliminar la asignación: ' + error.message);
    }
  };

  const openCreateModal = () => {
    setEditingUser(null);
    resetForm();
    setShowModal(true);
  };

  const resetForm = () => {
    setFormData({
      client_id: '',
      branch_id: '',
      role_in_client: 'gerente_sucursal',
      selected_user: null,
      manual_user_id: ''
    });
    setUserSearchQuery('');
    setUserProfiles([]);
  };

  const handleFilterChange = (field: string, value: string) => {
    switch (field) {
      case 'search':
        setSearchQuery(value);
        setCurrentPage(1);
        break;
      case 'client':
        setSelectedClient(value);
        setSelectedBranch(''); // Reset branch when client changes
        setCurrentPage(1);
        break;
      case 'branch':
        setSelectedBranch(value);
        setCurrentPage(1);
        break;
      case 'role':
        setSelectedRole(value);
        setCurrentPage(1);
        break;
    }
  };

  const clearFilters = () => {
    setSearchQuery('');
    setSelectedClient('');
    setSelectedBranch('');
    setSelectedRole('');
    setCurrentPage(1);
  };

  const getAvailableBranches = () => {
    return branches.filter(b => b.client_id === formData.client_id);
  };

  const getRoleLabel = (role: string) => {
    switch (role) {
      case 'master':
        return 'Master';
      case 'gerente_sucursal':
        return 'Gerente de Sucursal';
      default:
        return role;
    }
  };

  const formatUserId = (userId: string) => {
    return userId.slice(0, 8) + '...';
  };

  const handleRetry = () => {
    setError(null);
    window.location.reload();
  };

  const totalPages = Math.ceil(totalCount / pageSize);

  if (error) {
    return (
      <div className="text-center py-12 bg-white rounded-lg shadow-md">
        <div className="text-red-400 mb-4">
          <Users className="h-16 w-16 mx-auto" />
        </div>
        <h3 className="text-xl font-semibold text-gray-900 mb-2">Error al cargar usuarios de cliente</h3>
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
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Usuarios de Clientes</h1>
          <p className="text-gray-600">Administra los usuarios master y gerentes de los clientes</p>
        </div>
        <button
          onClick={openCreateModal}
          className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 flex items-center space-x-2"
        >
          <Plus className="h-4 w-4" />
          <span>Asignar Usuario</span>
        </button>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Filtros</h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Buscar
            </label>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <input
                type="text"
                placeholder="Nombre o User ID..."
                value={searchQuery}
                onChange={(e) => handleFilterChange('search', e.target.value)}
                className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Cliente
            </label>
            <select
              value={selectedClient}
              onChange={(e) => handleFilterChange('client', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todos los clientes</option>
              {clients.map((client) => (
                <option key={client.id} value={client.id}>
                  {client.name}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Sucursal
            </label>
            <select
              value={selectedBranch}
              onChange={(e) => handleFilterChange('branch', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              disabled={!selectedClient}
            >
              <option value="">Todas las sucursales</option>
              {branches
                .filter(b => !selectedClient || b.client_id === selectedClient)
                .map((branch) => (
                  <option key={branch.id} value={branch.id}>
                    {branch.name}
                  </option>
                ))
              }
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Rol
            </label>
            <select
              value={selectedRole}
              onChange={(e) => handleFilterChange('role', e.target.value)}
              className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Todos los roles</option>
              <option value="master">Master</option>
              <option value="gerente_sucursal">Gerente de Sucursal</option>
            </select>
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

      {/* Users Table */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        {isLoading ? (
          <div className="space-y-4 p-6">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="animate-pulse">
                <div className="flex items-center space-x-4">
                  <div className="w-10 h-10 bg-gray-200 rounded-full"></div>
                  <div className="flex-1 space-y-2">
                    <div className="h-4 bg-gray-200 rounded w-1/4"></div>
                    <div className="h-3 bg-gray-200 rounded w-1/2"></div>
                  </div>
                  <div className="h-8 bg-gray-200 rounded w-20"></div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Usuario
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Cliente
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Rol
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Sucursal
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Fecha Asignación
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Acciones
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {clientUsers.map((clientUser) => (
                    <tr key={clientUser.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <UserCheck className="h-5 w-5 text-gray-400 mr-3" />
                          <div>
                            <div className="text-sm font-medium text-gray-900">
                              {clientUser.display_name || '(sin nombre)'}
                            </div>
                            <div className="text-sm text-gray-500">
                              ID: {formatUserId(clientUser.user_id)}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <Building className="h-4 w-4 text-gray-400 mr-2" />
                          <div className="text-sm text-gray-900">
                            {clientUser.client_name}
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                          clientUser.role_in_client === 'master' 
                            ? 'bg-purple-100 text-purple-800'
                            : 'bg-blue-100 text-blue-800'
                        }`}>
                          {getRoleLabel(clientUser.role_in_client)}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        {clientUser.branch_id ? (
                          <div className="flex items-center">
                            <MapPin className="h-4 w-4 text-gray-400 mr-1" />
                            <span className="text-sm text-gray-900">
                              {clientUser.branch_name || 'Sucursal eliminada'}
                            </span>
                          </div>
                        ) : (
                          <span className="text-sm text-gray-500">—</span>
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {new Date(clientUser.created_at).toLocaleDateString('es-CO')}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                        <button
                          onClick={() => handleEdit(clientUser)}
                          className="text-indigo-600 hover:text-indigo-900"
                          title="Editar asignación"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(clientUser.id)}
                          className="text-red-600 hover:text-red-900"
                          title="Eliminar asignación"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
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
                    Mostrando {(currentPage - 1) * pageSize + 1} a {Math.min(currentPage * pageSize, totalCount)} de {totalCount} asignaciones
                  </div>
                  <div className="flex space-x-2">
                    <button
                      onClick={() => setCurrentPage(Math.max(currentPage - 1, 1))}
                      disabled={currentPage === 1}
                      className="px-3 py-1 border border-gray-300 rounded-md text-sm hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      Anterior
                    </button>
                    <span className="px-3 py-1 text-sm text-gray-700">
                      Página {currentPage} de {totalPages}
                    </span>
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

            {clientUsers.length === 0 && !isLoading && (
              <div className="text-center py-12">
                <Users className="h-16 w-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-900 mb-2">No hay usuarios asignados</h3>
                <p className="text-gray-600 mb-4">
                  {searchQuery || selectedClient || selectedBranch || selectedRole
                    ? 'No se encontraron usuarios con estos filtros'
                    : 'Asigna el primer usuario a un cliente'
                  }
                </p>
                <button
                  onClick={openCreateModal}
                  className="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200"
                >
                  Asignar Usuario
                </button>
              </div>
            )}
          </>
        )}
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-gray-900">
                {editingUser ? 'Editar Asignación de Usuario' : 'Asignar Usuario Existente'}
              </h3>
              <button
                onClick={() => setShowModal(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
            
            <form onSubmit={handleSubmit} className="p-6 space-y-6">
              {/* Client Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Cliente *
                </label>
                <select
                  value={formData.client_id}
                  onChange={(e) => setFormData({ 
                    ...formData, 
                    client_id: e.target.value, 
                    branch_id: '' 
                  })}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                  disabled={!!editingUser}
                >
                  <option value="">Seleccionar cliente...</option>
                  {clients.map((client) => (
                    <option key={client.id} value={client.id}>
                      {client.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Role Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Rol en el Cliente *
                </label>
                <div className="space-y-2">
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="master"
                      checked={formData.role_in_client === 'master'}
                      onChange={(e) => setFormData({ 
                        ...formData, 
                        role_in_client: e.target.value as 'master' | 'gerente_sucursal',
                        branch_id: '' // Clear branch when switching to master
                      })}
                      className="mr-2"
                    />
                    <span className="text-sm">Master (acceso a todo el cliente)</span>
                  </label>
                  <label className="flex items-center">
                    <input
                      type="radio"
                      value="gerente_sucursal"
                      checked={formData.role_in_client === 'gerente_sucursal'}
                      onChange={(e) => setFormData({ 
                        ...formData, 
                        role_in_client: e.target.value as 'master' | 'gerente_sucursal'
                      })}
                      className="mr-2"
                    />
                    <span className="text-sm">Gerente de Sucursal</span>
                  </label>
                </div>
              </div>

              {/* Branch Selection (only for gerente) */}
              {formData.role_in_client === 'gerente_sucursal' && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Sucursal *
                  </label>
                  <select
                    value={formData.branch_id}
                    onChange={(e) => setFormData({ ...formData, branch_id: e.target.value })}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    required={formData.role_in_client === 'gerente_sucursal'}
                  >
                    <option value="">Seleccionar sucursal...</option>
                    {getAvailableBranches().map((branch) => (
                      <option key={branch.id} value={branch.id}>
                        {branch.name}
                      </option>
                    ))}
                  </select>
                </div>
              )}

              {/* User Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Usuario *
                </label>
                
                {editingUser ? (
                  <div className="bg-gray-50 p-3 rounded-md">
                    <div className="text-sm font-medium text-gray-900">
                      {editingUser.display_name || '(sin nombre)'}
                    </div>
                    <div className="text-sm text-gray-500">
                      ID: {editingUser.user_id}
                    </div>
                  </div>
                ) : (
                  <>
                    {/* User Search */}
                    <div className="mb-3">
                      <div className="relative">
                        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                        <input
                          type="text"
                          placeholder="Buscar por nombre o User ID..."
                          value={userSearchQuery}
                          onChange={(e) => setUserSearchQuery(e.target.value)}
                          className="pl-10 w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                        />
                      </div>
                      {isSearchingUsers && (
                        <div className="mt-2 text-sm text-gray-500 flex items-center">
                          <LoadingSpinner size="sm" />
                          <span className="ml-2">Buscando usuarios...</span>
                        </div>
                      )}
                      {userSearchQuery.length >= 2 && !isSearchingUsers && userProfiles.length === 0 && (
                        <div className="mt-2 text-sm text-yellow-600 bg-yellow-50 p-2 rounded">
                          No se encontraron usuarios. Esto puede indicar que no hay datos en user_profiles.
                        </div>
                      )}
                    </div>

                    {/* User Selection Results */}
                    {userProfiles.length > 0 && (
                      <div className="mb-3 max-h-40 overflow-y-auto border border-gray-200 rounded-md">
                        {userProfiles.map((profile) => (
                          <button
                            key={profile.user_id}
                            type="button"
                            onClick={() => setFormData({ 
                              ...formData, 
                              selected_user: profile,
                              manual_user_id: ''
                            })}
                            className={`w-full text-left px-3 py-2 hover:bg-gray-50 transition-colors duration-200 ${
                              formData.selected_user?.user_id === profile.user_id ? 'bg-blue-50 border-l-4 border-blue-500' : ''
                            }`}
                          >
                            <div className="text-sm font-medium text-gray-900">
                              {profile.display_name || '(sin nombre)'}
                            </div>
                            <div className="text-xs text-gray-500">
                              ID: {formatUserId(profile.user_id)} • App: {profile.role_app || 'sin rol'}
                            </div>
                          </button>
                        ))}
                      </div>
                    )}

                    {/* Manual User ID Input */}
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">
                        O ingresar User ID manualmente
                      </label>
                      <input
                        type="text"
                        placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
                        value={formData.manual_user_id}
                        onChange={(e) => setFormData({ 
                          ...formData, 
                          manual_user_id: e.target.value,
                          selected_user: null
                        })}
                        className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      />
                      {formData.manual_user_id && !isUUID(formData.manual_user_id) && (
                        <p className="text-xs text-red-600 mt-1">Formato UUID inválido</p>
                      )}
                    </div>

                    {/* Selected User Display */}
                    {formData.selected_user && (
                      <div className="bg-green-50 border border-green-200 rounded-md p-3">
                        <div className="flex items-center space-x-2">
                          <UserCheck className="h-4 w-4 text-green-600" />
                          <div>
                            <div className="text-sm font-medium text-green-900">
                              Usuario seleccionado: {formData.selected_user.display_name || '(sin nombre)'}
                            </div>
                            <div className="text-xs text-green-700">
                              ID: {formData.selected_user.user_id}
                            </div>
                          </div>
                        </div>
                      </div>
                    )}
                  </>
                )}
              </div>

              {/* Info Note */}
              <div className="bg-blue-50 border border-blue-200 rounded-md p-4">
                <div className="flex items-start space-x-2">
                  <AlertCircle className="h-4 w-4 text-blue-600 mt-0.5" />
                  <div className="text-sm text-blue-800">
                    <p className="font-medium mb-1">Importante:</p>
                    <ul className="list-disc list-inside space-y-1">
                      <li>Los usuarios deben registrarse primero mediante el formulario de registro</li>
                      <li>Solo puedes asignar usuarios que ya existen en el sistema</li>
                      <li>Un cliente puede tener solo un usuario master</li>
                      <li>Cada sucursal puede tener solo un gerente</li>
                      <li className="text-red-700 font-medium">Si no aparecen usuarios, es porque no hay registros en user_profiles</li>
                    </ul>
                  </div>
                </div>
              </div>

              {/* Debug Section (Development only) */}
              {isDev && (
                <div className="bg-gray-50 border border-gray-200 rounded-md p-4">
                  <div className="text-sm text-gray-700">
                    <p className="font-medium mb-2">🔍 Debug Info:</p>
                    <p>• Busca usuarios con término de mínimo 2 caracteres</p>
                    <p>• Si no aparece nada, verifica la consola del navegador</p>
                    <p>• Puede que necesites crear usuarios demo primero</p>
                  </div>
                </div>
              )}
              
              <div className="flex justify-end space-x-3 pt-4 border-t">
                <button
                  type="button"
                  onClick={() => setShowModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors duration-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting || (!editingUser && !formData.selected_user && (!formData.manual_user_id || !isUUID(formData.manual_user_id)))}
                  className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 flex items-center space-x-2"
                >
                  {isSubmitting && <LoadingSpinner size="sm" />}
                  <span>{isSubmitting ? 'Guardando...' : (editingUser ? 'Actualizar' : 'Asignar')}</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}