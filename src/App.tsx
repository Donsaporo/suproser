import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import ScrollToTop from './components/Layout/ScrollToTop';
import Layout from './components/Layout/Layout';
import ProtectedRoute from './components/Auth/ProtectedRoute';
import Home from './pages/Home';
import Products from './pages/Products';
import ProductDetail from './pages/ProductDetail';
import Cart from './pages/Cart';
import DigitalCatalog from './pages/DigitalCatalog';
import Videos from './pages/Videos';
import HowToGetThere from './pages/HowToGetThere';
import Contact from './pages/Contact';
import PendingAccess from './pages/Auth/PendingAccess';
import MasterDashboard from './pages/Dashboards/MasterDashboard';
import GerenteDashboard from './pages/Dashboards/GerenteDashboard';
import AdminLayout from './components/Admin/AdminLayout';
import AdminResumen from './pages/Admin/AdminResumen';
import AdminProducts from './pages/Admin/Products';
import AdminCategories from './pages/Admin/Categories';
import AdminClients from './pages/Admin/Clients';
import AdminBranches from './pages/Admin/Branches';
import AdminClientUsers from './pages/Admin/ClientUsers';
import AdminClientPricing from './pages/Admin/ClientPricing';
import AdminPayments from './pages/Admin/Payments';
import MasterLayout from './components/Master/MasterLayout';
import MasterResumen from './pages/Master/Resumen';
import MasterSucursales from './pages/Master/Sucursales';
import MasterOrdenes from './pages/Master/Ordenes';
import MasterNuevaOrden from './pages/Master/NuevaOrden';
import MasterOrdenDetalle from './pages/Master/OrdenDetalle';
import GerenteLayout from './components/Gerente/GerenteLayout';
import GerenteResumen from './pages/Gerente/Resumen';
import GerenteNuevoPedido from './pages/Gerente/NuevoPedido';
import GerenteOrdenes from './pages/Gerente/Ordenes';
import GerenteOrdenDetalle from './pages/Gerente/OrdenDetalle';
import GerenteOrdenEditar from './pages/Gerente/OrdenEditar';
import { Navigate } from 'react-router-dom';
import LoadingSpinner from './components/UI/LoadingSpinner';
import { useAuth } from './contexts/AuthContext';
import ToastContainer from './components/UI/Toast';

function AppContent() {
  const { isInitialized, loading } = useAuth();

  // Show loading spinner until auth is initialized
  if (!isInitialized || loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <Router>
      <ScrollToTop />
      <ToastContainer />
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="productos" element={<Products />} />
          <Route path="productos/:slug" element={<ProductDetail />} />
          <Route path="carrito" element={<Cart />} />
          <Route path="catalogo-digital" element={<DigitalCatalog />} />
          <Route path="videos" element={<Videos />} />
          <Route path="como-llegar" element={<HowToGetThere />} />
          <Route path="contactenos" element={<Contact />} />
          
          {/* Auth Routes */}
          <Route path="acceso-pendiente" element={<PendingAccess />} />
          
          {/* Admin Routes */}
          <Route
            path="admin"
            element={
              <ProtectedRoute allowedRoles={['admin']}>
                <AdminLayout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/admin/resumen" replace />} />
            <Route path="resumen" element={<AdminResumen />} />
            <Route path="productos" element={<AdminProducts />} />
            <Route path="categorias" element={<AdminCategories />} />
            <Route path="clientes" element={<AdminClients />} />
            <Route path="sucursales" element={<AdminBranches />} />
            <Route path="usuarios-cliente" element={<AdminClientUsers />} />
            <Route path="precios-por-cliente" element={<AdminClientPricing />} />
            <Route path="pagos" element={<AdminPayments />} />
            {/* Removed routes - redirect to main dashboard */}
            <Route path="webhooks" element={<Navigate to="/admin/resumen" replace />} />
            <Route path="auditoria" element={<Navigate to="/admin/resumen" replace />} />
            <Route path="ajustes" element={<Navigate to="/admin/resumen" replace />} />
          </Route>
          
          {/* Master Routes */}
          <Route
            path="mi-empresa"
            element={
              <ProtectedRoute allowedRoles={['cliente_master']}>
                <MasterLayout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/mi-empresa/resumen" replace />} />
            <Route path="resumen" element={<MasterResumen />} />
            <Route path="sucursales" element={<MasterSucursales />} />
            <Route path="nueva-orden" element={<MasterNuevaOrden />} />
            <Route path="ordenes" element={<MasterOrdenes />} />
            <Route path="ordenes/:id" element={<MasterOrdenDetalle />} />
          </Route>
          
          {/* Gerente Routes */}
          <Route
            path="mi-sucursal/*"
            element={
              <ProtectedRoute allowedRoles={['cliente_gerente_sucursal']}>
                <GerenteLayout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/mi-sucursal/resumen" replace />} />
            <Route path="resumen" element={<GerenteResumen />} />
            <Route path="nuevo-pedido" element={<GerenteNuevoPedido />} />
            <Route path="ordenes" element={<GerenteOrdenes />} />
            <Route path="ordenes/:id/editar" element={<GerenteOrdenEditar />} />
            <Route path="ordenes/:id" element={<GerenteOrdenDetalle />} />
          </Route>
          
          {/* Legacy routes - redirect to new ones */}
          <Route path="panel/master" element={<Navigate to="/mi-empresa/resumen" replace />} />
          <Route path="panel/gerente" element={<Navigate to="/mi-sucursal/resumen" replace />} />
        </Route>
      </Routes>
    </Router>
  );
}
function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  );
}

export default App;