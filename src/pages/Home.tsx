import React from 'react';
import { Link } from 'react-router-dom';
import { Home as HomeIcon, Building2, ChefHat, Dumbbell, Truck, Shield, Headphones, CreditCard, ArrowRight } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useAuthRedirect } from '../hooks/useAuthRedirect';
import { useProducts } from '../hooks/useProducts';
import { useCategories } from '../hooks/useCategories';
import { benefits } from '../data/dummy';
import ProductCard from '../components/UI/ProductCard';
import CategoryChip from '../components/UI/CategoryChip';
import LoadingSpinner from '../components/UI/LoadingSpinner';

export default function Home() {
  const { user } = useAuth();
  
  // Use redirect hook (it handles user state internally)
  useAuthRedirect();

  // Fetch 3 featured products
  const { data: featuredProducts, isLoading: productsLoading } = useProducts({
    limit: 3,
    page: 1
  });

  // Fetch all categories
  const { categories, isLoading: categoriesLoading } = useCategories();

  const categoryIcons = {
    'hogar': <HomeIcon className="h-6 w-6" />,
    'hospitales-clinicas': <Building2 className="h-6 w-6" />,
    'cocinas-restaurantes': <ChefHat className="h-6 w-6" />,
    'escuelas-gimnasios': <Dumbbell className="h-6 w-6" />
  };

  const benefitIcons = {
    'Truck': <Truck className="h-8 w-8" />,
    'Shield': <Shield className="h-8 w-8" />,
    'Headphones': <Headphones className="h-8 w-8" />,
    'CreditCard': <CreditCard className="h-8 w-8" />
  };

  return (
    <div className="space-y-20">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-600 to-blue-800 text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              Productos de Limpieza
              <span className="block text-blue-200">Profesional</span>
            </h1>
            <p className="text-xl md:text-2xl mb-8 text-blue-100 max-w-3xl mx-auto">
              Proveedor líder en soluciones de limpieza para empresas, hospitales, restaurantes y más.
            </p>
            <div className="space-x-4">
              <Link
                to="/productos"
                className="inline-block bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-all duration-300 transform hover:scale-105"
              >
                Ver Catálogo
              </Link>
              <Link
                to="/contactenos"
                className="inline-block border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition-all duration-300"
              >
                Contáctanos
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Products Section */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">Nuestros Productos</h2>
          <p className="text-lg text-gray-600">Descubre nuestra línea de productos profesionales.</p>
        </div>
        
        {productsLoading ? (
          <div className="flex justify-center py-12">
            <LoadingSpinner size="lg" />
          </div>
        ) : (
          <>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
              {featuredProducts.slice(0, 3).map((product) => (
                <ProductCard key={product.id} product={product} />
              ))}
            </div>

            <div className="text-center">
              <Link
                to="/productos"
                className="inline-flex items-center bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-all duration-300 transform hover:scale-105"
              >
                Ver Todos los Productos
                <ArrowRight className="ml-2 h-5 w-5" />
              </Link>
            </div>
          </>
        )}
      </section>

      {/* Categories Section */}
      <section className="bg-gray-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Nuestras Categorías</h2>
            <p className="text-lg text-gray-600">Soluciones especializadas para cada sector.</p>
          </div>
          
          {categoriesLoading ? (
            <div className="flex justify-center py-12">
              <LoadingSpinner size="lg" />
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              {categories.map((category) => {
                const icon = categoryIcons[category.slug as keyof typeof categoryIcons] || <HomeIcon className="h-6 w-6" />;
                return (
                  <CategoryChip 
                    key={category.id} 
                    name={category.name} 
                    slug={category.slug} 
                    icon={icon} 
                  />
                );
              })}
            </div>
          )}
        </div>
      </section>

      {/* Benefits Section - Improved styling */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-6">¿Por qué elegir SUPROSER?</h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            Beneficios que nos hacen únicos en el mercado de productos de limpieza profesional.
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {benefits.map((benefit) => {
            const IconComponent = benefitIcons[benefit.icon as keyof typeof benefitIcons];
            return (
              <div 
                key={benefit.title} 
                className="bg-white p-8 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 text-center group hover:-translate-y-2"
              >
                <div className="text-blue-600 mb-6 flex justify-center group-hover:scale-110 transition-transform duration-300">
                  {IconComponent}
                </div>
                <h3 className="text-xl font-bold text-gray-900 mb-4 group-hover:text-blue-600 transition-colors duration-300">
                  {benefit.title}
                </h3>
                <p className="text-gray-600 leading-relaxed">
                  {benefit.description}
                </p>
              </div>
            );
          })}
        </div>
        
        {/* Call to Action */}
        <div className="text-center mt-16">
          <div className="bg-gradient-to-r from-blue-600 to-blue-800 rounded-2xl p-12 text-white">
            <h3 className="text-2xl font-bold mb-4">¿Listo para comenzar?</h3>
            <p className="text-blue-100 mb-8 max-w-2xl mx-auto">
              Únete a cientos de empresas en Panamá que confían en nuestros productos de limpieza profesional.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/productos"
                className="bg-white text-blue-600 px-8 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-all duration-300 transform hover:scale-105"
              >
                Explorar Productos
              </Link>
              <Link
                to="/contactenos"
                className="border-2 border-white text-white px-8 py-3 rounded-lg font-semibold hover:bg-white hover:text-blue-600 transition-all duration-300"
              >
                Solicitar Asesoría
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}