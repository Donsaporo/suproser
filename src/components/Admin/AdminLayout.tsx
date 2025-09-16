import React, { useState } from 'react';
import { Outlet, Link, useLocation, useNavigate } from 'react-router-dom';
import { 
  BarChart3, 
  Package, 
  Tags, 
  Building, 
  MapPin, 
  Users, 
  DollarSign, 
  CreditCard, 
  Menu, 
  X,
  Home,
  ChevronRight
} from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

const navigation = [
  { name: 'Resumen', href: '/admin/resumen', icon: BarChart3 },
  { name: 'Productos', href: '/admin/productos', icon: Package },
  { name: 'Categorías', href: '/admin/categorias', icon: Tags },
  { name: 'Clientes', href: '/admin/clientes', icon: Building },
  { name: 'Sucursales', href: '/admin/sucursales', icon: MapPin },
  { name: 'Usuarios de Clientes', href: '/admin/usuarios-cliente', icon: Users },
  { name: 'Precios por Cliente', href: '/admin/precios-por-cliente', icon: DollarSign },
  { name: 'Pagos', href: '/admin/pagos', icon: CreditCard },
];

export default function AdminLayout() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const { profile } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

  const isActive = (href: string) => location.pathname === href;

  const getBreadcrumbs = () => {
    const path = location.pathname;
    const breadcrumbs = [{ name: 'Admin', href: '/admin/resumen' }];
    
    const currentNav = navigation.find(nav => nav.href === path);
    if (currentNav && currentNav.href !== '/admin/resumen') {
      breadcrumbs.push({ name: currentNav.name, href: path });
    }
    
    return breadcrumbs;
  };

  const getCurrentPageTitle = () => {
    const currentNav = navigation.find(nav => nav.href === location.pathname);
    return currentNav?.name || 'Admin';
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile sidebar overlay */}
      {sidebarOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <div className="fixed inset-0 bg-black bg-opacity-50" onClick={() => setSidebarOpen(false)} />
          <div className="relative flex w-full max-w-xs flex-1 flex-col bg-white">
            <div className="absolute top-0 right-0 -mr-12 pt-2">
              <button
                type="button"
                className="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                onClick={() => setSidebarOpen(false)}
              >
                <X className="h-6 w-6 text-white" />
              </button>
            </div>
            <SidebarContent />
          </div>
        </div>
      )}

      {/* Desktop sidebar */}
      <div className="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-64 lg:flex-col">
        <div className="flex flex-1 flex-col bg-white shadow-lg">
          <SidebarContent />
        </div>
      </div>

      {/* Main content */}
      <div className="lg:pl-64">
        {/* Top bar */}
        <div className="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm sm:gap-x-6 sm:px-6 lg:px-8">
          <button
            type="button"
            className="-m-2.5 p-2.5 text-gray-700 lg:hidden"
            onClick={() => setSidebarOpen(true)}
          >
            <Menu className="h-6 w-6" />
          </button>

          <div className="flex flex-1 gap-x-4 self-stretch lg:gap-x-6">
            <div className="flex flex-col justify-center">
              {/* Breadcrumbs */}
              <nav className="flex" aria-label="Breadcrumb">
                <ol className="flex items-center space-x-2">
                  {getBreadcrumbs().map((crumb, index) => (
                    <li key={crumb.href} className="flex items-center">
                      {index > 0 && <ChevronRight className="h-4 w-4 text-gray-400 mx-2" />}
                      <Link
                        to={crumb.href}
                        className={`text-sm font-medium ${
                          index === getBreadcrumbs().length - 1
                            ? 'text-gray-900'
                            : 'text-gray-500 hover:text-gray-700'
                        }`}
                      >
                        {crumb.name}
                      </Link>
                    </li>
                  ))}
                </ol>
              </nav>
              
              {/* Page Title */}
              <div className="flex items-center gap-x-2 mt-1">
                <h1 className="text-lg font-semibold text-gray-900">
                  {getCurrentPageTitle()}
                </h1>
                <div className="text-sm text-gray-500">
                  • {profile?.display_name || 'Administrador'}
                </div>
              </div>
            </div>
            
            <div className="flex items-center gap-x-4 lg:gap-x-6 ml-auto">
              <Link
                to="/"
                className="flex items-center gap-x-2 rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white hover:bg-blue-700"
              >
                <Home className="h-4 w-4" />
                Ver Sitio
              </Link>
            </div>
          </div>
        </div>

        {/* Page content */}
        <main className="py-10">
          <div className="px-4 sm:px-6 lg:px-8">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );

  function SidebarContent() {
    return (
      <div className="flex flex-1 flex-col overflow-y-auto pt-5 pb-4">
        <div className="flex flex-shrink-0 items-center px-4">
          <img 
            src="/suproser-logo.png" 
            alt="SUPROSER" 
            className="h-10 w-auto"
          />
        </div>
        
        <nav className="mt-8 flex-1 space-y-1 px-2">
          {navigation.map((item) => (
            <Link
              key={item.name}
              to={item.href}
              className={`group flex items-center px-2 py-2 text-sm font-medium rounded-md transition-colors duration-200 ${
                isActive(item.href)
                  ? 'bg-blue-50 text-blue-600'
                  : 'text-gray-700 hover:bg-gray-50 hover:text-blue-600'
              }`}
            >
              <item.icon className={`mr-3 h-5 w-5 ${
                isActive(item.href) ? 'text-blue-600' : 'text-gray-400 group-hover:text-blue-600'
              }`} />
              {item.name}
            </Link>
          ))}
        </nav>
      </div>
    );
  }
}