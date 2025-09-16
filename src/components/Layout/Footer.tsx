import React from 'react';
import { Link } from 'react-router-dom';
import { Facebook, Instagram, Linkedin } from 'lucide-react';

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-12 gap-8">
          {/* Company Info */}
          <div className="lg:col-span-5 space-y-4">
            <img 
              src="/suproser-logo.png" 
              alt="SUPROSER" 
              className="h-12 w-auto"
            />
            <p className="text-gray-300 text-sm">
              SUPROSER con más de 15 años de experiencia se dedica a la distribución de productos de limpieza de alta calidad para industrias, hospitales, hoteles, oficinas y hogares.
            </p>
            <div className="flex space-x-4">
              <a href="#" className="text-gray-400 hover:text-white transition-colors duration-200">
                <Facebook className="h-5 w-5" />
              </a>
              <a href="#" className="text-gray-400 hover:text-white transition-colors duration-200">
                <Instagram className="h-5 w-5" />
              </a>
              <a 
                href="https://pa.linkedin.com/in/suproser-panam%C3%A1" 
                target="_blank"
                rel="noopener noreferrer"
                className="text-gray-400 hover:text-white transition-colors duration-200"
              >
                <Linkedin className="h-5 w-5" />
              </a>
            </div>
          </div>

          {/* Navigation */}
          <div className="lg:col-span-3">
            <h3 className="text-lg font-semibold mb-4">Navegación</h3>
            <ul className="space-y-2">
              <li><Link to="/" className="text-gray-300 hover:text-white transition-colors duration-200">Inicio</Link></li>
              <li><Link to="/productos" className="text-gray-300 hover:text-white transition-colors duration-200">Productos</Link></li>
              <li><Link to="/catalogo-digital" className="text-gray-300 hover:text-white transition-colors duration-200">Catálogo Digital</Link></li>
              <li><Link to="/videos" className="text-gray-300 hover:text-white transition-colors duration-200">Videos</Link></li>
              <li><Link to="/contactenos" className="text-gray-300 hover:text-white transition-colors duration-200">Contáctenos</Link></li>
              <li><Link to="/como-llegar" className="text-gray-300 hover:text-white transition-colors duration-200">Cómo Llegar</Link></li>
            </ul>
          </div>

          {/* Contact */}
          <div className="lg:col-span-4">
            <h3 className="text-lg font-semibold mb-4">Contacto</h3>
            <div className="space-y-2 text-gray-300 text-sm">
              <p>Calle 9, Río Abajo, bodega Suproser</p>
              <p>Panamá, Ciudad de Panamá</p>
              <p>Teléfono: +507 213-2929 / +507 6349 9962</p>
              <p>Email: jgb@suproser.com</p>
            </div>
            
            <div className="mt-6 pt-4 border-t border-gray-700">
              <h4 className="text-md font-medium text-white mb-2">Horarios de Atención</h4>
              <div className="text-gray-300 text-sm space-y-1">
                <p>Lunes - Viernes: 8:00 AM - 6:00 PM</p>
                <p>Sábados: 8:00 AM - 2:00 PM</p>
                <p>Domingos: Cerrado</p>
              </div>
            </div>
          </div>
        </div>

        <div className="border-t border-gray-700 mt-8 pt-8 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400 text-sm">
            © {currentYear} SUPROSER. Todos los derechos reservados.
          </p>
          <div className="flex space-x-6 mt-4 md:mt-0">
            <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors duration-200">
              Política de Privacidad
            </a>
            <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors duration-200">
              Términos y Condiciones
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}