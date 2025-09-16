import React, { useState } from 'react';
import { Copy, LogIn, Users, AlertTriangle, CheckCircle, XCircle } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import LoadingSpinner from '../UI/LoadingSpinner';

interface DemoUser {
  role: string;
  email: string;
  password: string;
  displayName: string;
}

interface CreateResult {
  role: string;
  status: 'created' | 'exists' | 'error';
  message?: string;
  user_id?: string;
}

const DEMO_USERS: DemoUser[] = [
  {
    role: 'admin',
    email: 'admin.demo@suproser.app',
    password: 'Demo123$!',
    displayName: 'Admin Demo'
  },
  {
    role: 'cliente_master',
    email: 'master.demo@clientedemo.app',
    password: 'Demo123$!',
    displayName: 'Master Demo'
  },
  {
    role: 'cliente_gerente_sucursal',
    email: 'gerente.rioabajo.demo@clientedemo.app',
    password: 'Demo123$!',
    displayName: 'Gerente Río Abajo Demo'
  }
];

interface DemoUsersSectionProps {
  onAutofill: (email: string, password: string) => void;
}

export default function DemoUsersSection({ onAutofill }: DemoUsersSectionProps) {
  const [isCreating, setIsCreating] = useState(false);
  const [results, setResults] = useState<CreateResult[]>([]);
  const [showResults, setShowResults] = useState(false);
  const { signIn } = useAuth();

  // Only show in development or when demo flag is enabled
  const isDevelopment = import.meta.env.DEV || import.meta.env.VITE_ENABLE_DEMO_USERS === 'true';
  
  if (!isDevelopment) {
    return null;
  }

  const handleCreateDemoUsers = async () => {
    setIsCreating(true);
    setResults([]);
    setShowResults(true);

    try {
      console.log('Starting demo users creation...');
      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/create-demo-users`;
      console.log('API URL:', apiUrl);
      
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
      });

      console.log('Response status:', response.status);
      
      if (!response.ok) {
        const errorText = await response.text();
        console.error('Response error:', errorText);
        throw new Error(`HTTP error! status: ${response.status} - ${errorText}`);
      }

      const data = await response.json();
      console.log('Response data:', data);
      
      if (data.error) {
        console.error('API returned error:', data.error);
        throw new Error(data.error);
      }

      setResults(data.results || []);
      console.log('Results set:', data.results);
    } catch (error) {
      console.error('Error creating demo users:', error);
      setResults([
        { 
          role: 'error', 
          status: 'error', 
          message: error instanceof Error ? error.message : 'Unknown error occurred' 
        }
      ]);
    } finally {
      setIsCreating(false);
    }
  };

  const handleCopyToClipboard = async (text: string, type: 'email' | 'password') => {
    try {
      await navigator.clipboard.writeText(text);
      // You could add a toast notification here
    } catch (error) {
      console.error(`Failed to copy ${type}:`, error);
    }
  };

  const handleQuickLogin = async (email: string, password: string) => {
    try {
      console.log('Quick login attempt:', { email });
      const { error } = await signIn(email, password);
      if (error) {
        console.error('Quick login error:', error);
        alert(`Error en login rápido: ${error.message}`);
      } else {
        console.log('Quick login successful');
      }
      // The auth system will handle redirection
    } catch (error) {
      console.error('Quick login failed:', error);
      alert(`Error inesperado en login: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'created':
        return <CheckCircle className="h-4 w-4 text-green-600" />;
      case 'exists':
        return <CheckCircle className="h-4 w-4 text-yellow-600" />;
      case 'error':
        return <XCircle className="h-4 w-4 text-red-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'created':
        return 'text-green-600 bg-green-50';
      case 'exists':
        return 'text-yellow-600 bg-yellow-50';
      case 'error':
        return 'text-red-600 bg-red-50';
      default:
        return 'text-gray-600 bg-gray-50';
    }
  };

  const getRoleDisplayName = (role: string) => {
    switch (role) {
      case 'admin':
        return 'Administrador';
      case 'cliente_master':
        return 'Cliente Master';
      case 'cliente_gerente_sucursal':
        return 'Gerente Sucursal';
      default:
        return role;
    }
  };

  return (
    <div className="mt-8 p-6 bg-yellow-50 border border-yellow-200 rounded-lg">
      {/* Header */}
      <div className="flex items-center space-x-2 mb-4">
        <Users className="h-5 w-5 text-yellow-600" />
        <h3 className="text-lg font-semibold text-gray-900">Ambiente de Demo (Solo Desarrollo)</h3>
      </div>

      <div className="flex items-start space-x-2 mb-4">
        <AlertTriangle className="h-4 w-4 text-yellow-600 mt-0.5 flex-shrink-0" />
        <p className="text-sm text-gray-700">
          Crea cuentas de prueba (admin, master y gerente) y úsalas para entrar. 
          <span className="font-medium text-red-600 ml-1">No habilitar en producción.</span>
        </p>
      </div>

      {/* Create Button */}
      <button
        onClick={handleCreateDemoUsers}
        disabled={isCreating}
        className="mb-6 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
      >
        {isCreating ? (
          <LoadingSpinner size="sm" />
        ) : (
          <Users className="h-4 w-4" />
        )}
        <span>{isCreating ? 'Creando usuarios...' : 'Crear Usuarios Demo'}</span>
      </button>

      {/* Credentials Table */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-200">
          <h4 className="text-sm font-medium text-gray-900">Credenciales de Demo</h4>
        </div>
        
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Rol
                </th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Email
                </th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Password
                </th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Acciones
                </th>
                {showResults && (
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Estado
                  </th>
                )}
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {DEMO_USERS.map((user) => {
                const result = results.find(r => r.role === user.role);
                return (
                  <tr key={user.role}>
                    <td className="px-4 py-3 whitespace-nowrap text-sm font-medium text-gray-900">
                      {getRoleDisplayName(user.role)}
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-600">
                      <div className="flex items-center space-x-2">
                        <code className="text-xs bg-gray-100 px-2 py-1 rounded">
                          {user.email}
                        </code>
                        <button
                          onClick={() => handleCopyToClipboard(user.email, 'email')}
                          className="text-gray-400 hover:text-gray-600"
                          title="Copiar email"
                        >
                          <Copy className="h-3 w-3" />
                        </button>
                      </div>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-sm text-gray-600">
                      <div className="flex items-center space-x-2">
                        <code className="text-xs bg-gray-100 px-2 py-1 rounded">
                          {user.password}
                        </code>
                        <button
                          onClick={() => handleCopyToClipboard(user.password, 'password')}
                          className="text-gray-400 hover:text-gray-600"
                          title="Copiar password"
                        >
                          <Copy className="h-3 w-3" />
                        </button>
                      </div>
                    </td>
                    <td className="px-4 py-3 whitespace-nowrap text-sm">
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => onAutofill(user.email, user.password)}
                          className="text-blue-600 hover:text-blue-800 text-xs"
                          title="Autocompletar formulario"
                        >
                          Autocompletar
                        </button>
                        <button
                          onClick={() => handleQuickLogin(user.email, user.password)}
                          className="text-green-600 hover:text-green-800 text-xs flex items-center space-x-1"
                          title="Iniciar sesión directamente"
                        >
                          <LogIn className="h-3 w-3" />
                          <span>Entrar</span>
                        </button>
                      </div>
                    </td>
                    {showResults && (
                      <td className="px-4 py-3 whitespace-nowrap">
                        {result ? (
                          <div className="flex items-center space-x-2">
                            {getStatusIcon(result.status)}
                            <span className={`text-xs px-2 py-1 rounded-full ${getStatusColor(result.status)}`}>
                              {result.status === 'created' && 'Creado'}
                              {result.status === 'exists' && 'Ya existía'}
                              {result.status === 'error' && 'Error'}
                            </span>
                            {result.message && (
                              <span className="text-xs text-gray-500" title={result.message}>
                                ⓘ
                              </span>
                            )}
                          </div>
                        ) : (
                          <span className="text-xs text-gray-400">-</span>
                        )}
                      </td>
                    )}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}