import React, { useState } from 'react';
import { useLocation } from 'react-router-dom';
import { X, Mail, Lock, User, AlertCircle, CheckCircle } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import LoadingSpinner from '../UI/LoadingSpinner';
import DemoUsersSection from './DemoUsersSection';

interface AuthModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function AuthModal({ isOpen, onClose }: AuthModalProps) {
  const [mode, setMode] = useState<'login' | 'signup' | 'reset'>('login');
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    displayName: ''
  });
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  
  const { signUp, signIn, resetPassword } = useAuth();
  const location = useLocation();
  const loginMessage = (location.state as any)?.message;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    console.log('🔄 Form submit started', { mode, email: formData.email });
    setIsLoading(true);
    setError(null);
    setMessage(null);

    try {
      if (mode === 'signup') {
        console.log('📝 Attempting signup...');
        const { error } = await signUp(formData.email, formData.password, formData.displayName);
        if (error) {
          console.error('❌ Signup error:', error);
          setError(error.message);
        } else {
          console.log('✅ Signup successful');
          setMessage('Cuenta creada exitosamente. Verifica tu email para continuar.');
          setTimeout(() => {
            onClose();
          }, 2000);
        }
      } else if (mode === 'login') {
        console.log('🔐 Attempting login...');
        const { error } = await signIn(formData.email, formData.password);
        console.log('🔐 Login response:', { error });
        if (error) {
          console.error('Login error:', error);
          if (error.message?.includes('Invalid login credentials') || 
              error.message?.includes('Invalid user credentials') ||
              error.message?.includes('Credenciales inválidas')) {
            setError('Email o contraseña incorrectos');
          } else if (error.message?.includes('timeout') || error.message?.includes('Failed to fetch')) {
            setError('Usando modo demo - Supabase no disponible');
          } else {
            setError(error.message || 'Error al iniciar sesión');
          }
        } else {
          console.log('✅ Login successful, closing modal...');
          setMessage('¡Bienvenido! Iniciando sesión...');
          setTimeout(() => {
            onClose();
          }, 500);
        }
      } else if (mode === 'reset') {
        console.log('🔄 Attempting password reset...');
        const { error } = await resetPassword(formData.email);
        if (error) {
          console.error('❌ Reset error:', error);
          setError(error.message);
        } else {
          setMessage('Se ha enviado un email para restablecer tu contraseña.');
        }
      }
    } catch (err) {
      console.error('❌ Unexpected error in handleSubmit:', err);
      setError('Ocurrió un error inesperado');
    } finally {
      console.log('🏁 Setting loading to false');
      setIsLoading(false);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError(null);
  };

  const resetForm = () => {
    setFormData({ email: '', password: '', displayName: '' });
    setError(null);
    setMessage(null);
  };

  const handleDemoAutofill = (email: string, password: string) => {
    setFormData({ ...formData, email, password });
    setMode('login');
    setError(null);
    setMessage(null);
  };

  const switchMode = (newMode: 'login' | 'signup' | 'reset') => {
    setMode(newMode);
    resetForm();
  };

  if (!isOpen) return null;

  const titles = {
    login: 'Iniciar Sesión',
    signup: 'Crear Cuenta',
    reset: 'Recuperar Contraseña'
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div className="flex justify-between items-center p-6 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900">
            {titles[mode]}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 transition-colors duration-200"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {loginMessage && mode === 'login' && (
            <div className="flex items-center space-x-2 text-blue-600 text-sm bg-blue-50 p-3 rounded-md">
              <AlertCircle className="h-4 w-4" />
              <span>{loginMessage}</span>
            </div>
          )}

          {mode === 'signup' && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Nombre completo
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  name="displayName"
                  value={formData.displayName}
                  onChange={handleInputChange}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Tu nombre completo"
                />
              </div>
            </div>
          )}

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="tu@empresa.com"
                required
              />
            </div>
          </div>

          {mode !== 'reset' && (
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Contraseña
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="password"
                  name="password"
                  value={formData.password}
                  onChange={handleInputChange}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="••••••••"
                  required
                  minLength={6}
                />
              </div>
            </div>
          )}

          {error && (
            <div className="flex items-center space-x-2 text-red-600 text-sm bg-red-50 p-3 rounded-md">
              <AlertCircle className="h-4 w-4" />
              <span>{error}</span>
            </div>
          )}

          {message && (
            <div className="flex items-center space-x-2 text-green-600 text-sm bg-green-50 p-3 rounded-md">
              <CheckCircle className="h-4 w-4" />
              <span>{message}</span>
            </div>
          )}

          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors duration-200 font-medium disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center"
          >
            {isLoading ? (
              <LoadingSpinner size="sm" />
            ) : (
              titles[mode]
            )}
          </button>

          <div className="text-center space-y-2">
            {mode === 'login' && (
              <>
                <button
                  type="button"
                  onClick={() => switchMode('signup')}
                  className="text-blue-600 hover:text-blue-700 text-sm transition-colors duration-200"
                >
                  ¿No tienes cuenta? Regístrate
                </button>
                <div>
                  <button
                    type="button"
                    onClick={() => switchMode('reset')}
                    className="text-blue-600 hover:text-blue-700 text-sm transition-colors duration-200"
                  >
                    ¿Olvidaste tu contraseña?
                  </button>
                </div>
              </>
            )}
            
            {mode === 'signup' && (
              <button
                type="button"
                onClick={() => switchMode('login')}
                className="text-blue-600 hover:text-blue-700 text-sm transition-colors duration-200"
              >
                ¿Ya tienes cuenta? Inicia sesión
              </button>
            )}

            {mode === 'reset' && (
              <button
                type="button"
                onClick={() => switchMode('login')}
                className="text-blue-600 hover:text-blue-700 text-sm transition-colors duration-200"
              >
                Volver al inicio de sesión
              </button>
            )}
          </div>
        </form>

        {/* Demo Users Section - only show on login mode */}
        {mode === 'login' && (
          <div className="px-6 pb-6">
            <DemoUsersSection onAutofill={handleDemoAutofill} />
          </div>
        )}
      </div>
    </div>
  );
}