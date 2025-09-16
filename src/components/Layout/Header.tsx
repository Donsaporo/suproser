import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Menu, X, User, ShoppingCart, Search, ChevronDown, LogIn } from 'lucide-react';
import { useCart } from '../../hooks/useCart';
import { useAuth } from '../../contexts/AuthContext';
import SearchOverlay from './SearchOverlay';
import AuthModal from '../Auth/AuthModal';
import UserMenu from '../Auth/UserMenu';
import { useCategories } from '../../hooks/useCategories';

export default function Header() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [isProductsDropdownOpen, setIsProductsDropdownOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [isAuthModalOpen, setIsAuthModalOpen] = useState(false);
  const { getTotalItems } = useCart();
  const { user, loading } = useAuth();
  const location = useLocation();
  const { categories, isLoading: categoriesLoading } = useCategories();

  const navigation = [
    { name: 'Inicio', href: '/' },
    { name: 'Cómo Llegar', href: '/como-llegar' },
    { name: 'Contáctenos', href: '/contactenos' },
    { name: 'Videos', href: '/videos' },
    { name: 'Catálogo Digital', href: '/catalogo-digital' },
  ];

  const isActive = (path: string) => location.pathname === path;
  
  // Check if we're in a dashboard (admin, master, gerente)
  const isDashboard = location.pathname.startsWith('/admin') || 
                     location.pathname.startsWith('/mi-empresa') || 
                     location.pathname.startsWith('/mi-sucursal');

  const handleSearchSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      window.location.href = `/productos?search=${encodeURIComponent(searchQuery.trim())}`;
    }
  };

  return (
    <header className="bg-white shadow-md sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* TOP PART: Logo + Search + User/Cart */}
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link to="/" className="flex-shrink-0">
            <img 
              src="/suproser-logo.png" 
              alt="SUPROSER" 
              className="h-10 w-auto"
            />
          </Link>

          {/* Search Bar - CENTER */}
          <div className="flex-1 max-w-lg mx-8">
            <form onSubmit={handleSearchSubmit} className="relative">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Buscar productos..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </form>
          </div>

          {/* Right Icons: User + Cart */}
          <div className="flex items-center space-x-4">
            {/* Always show login button if no user, even during loading */}
            {!user && (
              <div className="flex items-center space-x-2">
                <button
                  onClick={() => setIsAuthModalOpen(true)}
                  className="p-2 text-gray-600 hover:text-blue-600 transition-colors duration-200"
                  title="Iniciar Sesión" 
                >
                  <User className="h-5 w-5" />
                </button>
              </div>
            )}

            {/* Show user menu only when user exists */}
            {user && <UserMenu />}
            
            <Link
              to="/carrito"
              className="relative p-2 text-gray-600 hover:text-blue-600 transition-all duration-200"
              title="Ver carrito"
            >
              <ShoppingCart className="h-5 w-5" />
              {getTotalItems() > 0 && (
                <span className="absolute -top-1 -right-1 bg-blue-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                  {getTotalItems()}
                </span>
              )}
            </Link>

            {/* Mobile menu button */}
            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className="md:hidden p-2 text-gray-600 hover:text-blue-600 transition-colors duration-200"
            >
              {isMobileMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
            </button>
          </div>
        </div>

        {/* BOTTOM PART: Navigation - Only show on public pages */}
        {!isDashboard && (
          <div className="border-t border-gray-100">
            <div className="hidden md:flex items-center justify-center space-x-8 h-12">
              {navigation.map((item) => (
                <Link
                  key={item.name}
                  to={item.href}
                  className={`px-3 py-2 rounded-md text-sm font-medium transition-colors duration-200 ${
                    isActive(item.href)
                      ? 'text-blue-600 bg-blue-50'
                      : 'text-gray-700 hover:text-blue-600 hover:bg-gray-50'
                  }`}
                >
                  {item.name}
                </Link>
              ))}
              
              {/* Products Dropdown */}
              <div className="relative">
                <button
                  onClick={() => setIsProductsDropdownOpen(!isProductsDropdownOpen)}
                  className="flex items-center px-3 py-2 rounded-md text-sm font-medium text-gray-700 hover:text-blue-600 hover:bg-gray-50 transition-colors duration-200"
                >
                  Productos
                  <ChevronDown className="ml-1 h-4 w-4" />
                </button>
                
                {isProductsDropdownOpen && (
                  <div className="absolute top-full left-0 mt-2 w-64 bg-white rounded-md shadow-lg border border-gray-200 z-10">
                    <div className="py-2">
                      <Link
                        to="/productos"
                        className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                        onClick={() => setIsProductsDropdownOpen(false)}
                      >
                        Ver Todos los Productos
                      </Link>
                      <hr className="my-2" />
                      {categoriesLoading ? (
                        <div className="px-4 py-2 text-sm text-gray-500">Cargando categorías...</div>
                      ) : (
                        categories.map((category) => (
                          <Link
                            key={category.id}
                            to={`/productos?categoria=${category.slug}`}
                            className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50"
                            onClick={() => setIsProductsDropdownOpen(false)}
                          >
                            {category.name}
                          </Link>
                        ))
                      )}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Mobile Navigation - Only show on public pages */}
        {!isDashboard && isMobileMenuOpen && (
          <div className="md:hidden border-t border-gray-200 bg-white">
            <div className="px-2 pt-2 pb-3 space-y-1">
              {navigation.map((item) => (
                <Link
                  key={item.name}
                  to={item.href}
                  className={`block px-3 py-2 rounded-md text-base font-medium transition-colors duration-200 ${
                    isActive(item.href)
                      ? 'text-blue-600 bg-blue-50'
                      : 'text-gray-700 hover:text-blue-600 hover:bg-gray-50'
                  }`}
                  onClick={() => setIsMobileMenuOpen(false)}
                >
                  {item.name}
                </Link>
              ))}
              <Link
                to="/productos"
                className="block px-3 py-2 rounded-md text-base font-medium text-gray-700 hover:text-blue-600 hover:bg-gray-50 transition-colors duration-200"
                onClick={() => setIsMobileMenuOpen(false)}
              >
                Productos
              </Link>
              {categories.map((category) => (
                <Link
                  key={category.id}
                  to={`/productos?categoria=${category.slug}`}
                  className="block px-6 py-2 rounded-md text-sm text-gray-600 hover:text-blue-600 hover:bg-gray-50 transition-colors duration-200"
                  onClick={() => setIsMobileMenuOpen(false)}
                >
                  {category.name}
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>

      <AuthModal isOpen={isAuthModalOpen} onClose={() => setIsAuthModalOpen(false)} />
    </header>
  );
}