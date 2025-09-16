import React, { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { User, Settings, LogOut, ChevronDown } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

export default function UserMenu() {
  const [isOpen, setIsOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement>(null);
  const { user, profile, signOut, loading } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const handleDashboardClick = () => {
    setIsOpen(false);
    const dashboardLink = getDashboardLink();
    window.location.href = dashboardLink;
  };

  const handleSignOut = async () => {
    setIsOpen(false);
    try {
      const { error } = await signOut();
      if (error) {
        console.error('Error signing out:', error);
        alert('Error al cerrar sesión. Inténtalo de nuevo.');
      }
      // signOut already handles redirect to home
    } catch (error) {
      console.error('Unexpected error during signout:', error);
      alert('Error inesperado al cerrar sesión.');
    }
  };

  const getDashboardLink = () => {
    if (!profile?.role_app) return '/';
    
    switch (profile.role_app) {
      case 'admin':
        return '/admin/resumen';
      case 'cliente_master':
        return '/mi-empresa/resumen';
      case 'cliente_gerente_sucursal':
        return '/mi-sucursal/resumen';
      default:
        return '/';
    }
  };

  const getRoleDisplayName = () => {
    if (!profile?.role_app) return '';
    
    switch (profile.role_app) {
      case 'admin':
        return 'Administrador';
      case 'cliente_master':
        return 'Cliente Master';
      case 'cliente_gerente_sucursal':
        return 'Gerente de Sucursal';
      default:
        return '';
    }
  };

  // Don't render if still loading
  if (loading) {
    return null;
  }

  return (
    <div className="relative" ref={menuRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 p-2 text-gray-600 hover:text-blue-600 transition-colors duration-200"
      >
        <User className="h-5 w-5" />
        <ChevronDown className={`h-4 w-4 transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {isOpen && (
        <div className="absolute right-0 mt-2 w-64 bg-white rounded-md shadow-lg border border-gray-200 z-10">
          <div className="p-4 border-b border-gray-200">
            <div className="text-sm font-medium text-gray-900">
              {profile?.display_name || user?.email}
            </div>
            <div className="text-xs text-gray-500">{user?.email}</div>
            {profile?.role_app && (
              <div className="text-xs text-blue-600 mt-1">{getRoleDisplayName()}</div>
            )}
          </div>
          
          <div className="py-2">
            <button
              onClick={handleDashboardClick}
              className="flex items-center space-x-2 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
            >
              <Settings className="h-4 w-4" />
              <span>Mi Panel</span>
            </button>
            
            <button
              onClick={handleSignOut}
              className="flex items-center space-x-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 w-full text-left"
            >
              <LogOut className="h-4 w-4" />
              <span>Cerrar Sesión</span>
            </button>
          </div>
        </div>
      )}
    </div>
  );
}