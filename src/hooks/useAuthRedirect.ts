import { useEffect } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

export function useAuthRedirect() {
  const { user, profile, loading, isInitialized } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    // Don't do anything while loading
    if (!isInitialized || loading) return;
    
    // Only redirect from specific pages to avoid loops
    const shouldRedirect = location.pathname === '/' || location.pathname === '/login';
    if (!shouldRedirect) return;
    
    // Only proceed if user exists
    if (!user) return;

    if (profile) {
      // Check if user has a valid role
      if (!profile.role_app || !['admin', 'cliente_master', 'cliente_gerente_sucursal'].includes(profile.role_app)) {
        if (location.pathname !== '/acceso-pendiente') {
          navigate('/acceso-pendiente', { replace: true });
        }
        return;
      }

      // Only redirect from home page to dashboard
      if (location.pathname === '/') {
        const from = (location.state as any)?.from?.pathname;
        
        // Don't redirect if coming from logout or if already on a dashboard
        const dashboardPaths = ['/admin', '/mi-empresa', '/mi-sucursal'];
        if (from && dashboardPaths.includes(from)) {
          return;
        }
        
        console.debug('auth:redirect:dashboard', profile.role_app);
        
        // Redirect to appropriate dashboard based on role
        switch (profile.role_app) {
          case 'admin':
            navigate('/admin/resumen', { replace: true });
            break;
          case 'cliente_master':
            navigate('/mi-empresa/resumen', { replace: true });
            break;
          case 'cliente_gerente_sucursal':
            navigate('/mi-sucursal/resumen', { replace: true });
            break;
        }
      }
    }
  }, [user, profile, loading, isInitialized, navigate, location]);
}