import React from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import LoadingSpinner from '../UI/LoadingSpinner';

interface ProtectedRouteProps {
  children: React.ReactNode;
  allowedRoles?: Array<'admin' | 'cliente_master' | 'cliente_gerente_sucursal'>;
  requireAuth?: boolean;
}

export default function ProtectedRoute({ 
  children, 
  allowedRoles = [], 
  requireAuth = true 
}: ProtectedRouteProps) {
  const { user, profile, loading, isInitialized } = useAuth();
  const location = useLocation();

  // Show loading while auth is not initialized or still loading
  if (!isInitialized || loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  console.debug('protected-route', { 
    path: location.pathname, 
    hasUser: !!user, 
    hasProfile: !!profile,
    userRole: profile?.role_app,
    allowedRoles 
  });
  if (requireAuth && !user) {
    console.debug('protected-route:no-user', 'Redirecting to home');
    return <Navigate to="/" state={{ from: location }} replace />;
  }

  if (user && profile) {
    // Check if user has a valid role
    if (!profile.role_app || !['admin', 'cliente_master', 'cliente_gerente_sucursal'].includes(profile.role_app)) {
      console.debug('protected-route:invalid-role', profile.role_app);
      return <Navigate to="/acceso-pendiente" replace />;
    }

    // Check if user is allowed to access this route
    if (allowedRoles.length > 0 && !allowedRoles.includes(profile.role_app)) {
      console.debug('protected-route:role-mismatch', { 
        userRole: profile.role_app, 
        allowedRoles 
      });
      
      // Redirect to appropriate dashboard based on role
      switch (profile.role_app) {
        case 'admin':
          return <Navigate to="/admin/resumen" replace />;
        case 'cliente_master':
          return <Navigate to="/mi-empresa/resumen" replace />;
        case 'cliente_gerente_sucursal':
          return <Navigate to="/mi-sucursal/resumen" replace />;
        default:
          return <Navigate to="/acceso-pendiente" replace />;
      }
    }
  }

  // If user exists but no profile yet, show loading
  if (user && !profile) {
    console.debug('protected-route:loading-profile');
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return <>{children}</>;
}