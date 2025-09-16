import React, { useState } from 'react';
import { Mail, Phone, MapPin, Send } from 'lucide-react';
import { GOOGLE_MAPS_EMBED_URL } from '../config/constants';

export default function Contact() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    company: '',
    phone: '',
    message: ''
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Form submitted:', formData);
    // Aquí iría la lógica de envío
  };

  const steps = [
    'Explora nuestro catálogo de productos',
    'Selecciona los productos que necesitas',
    'Agrega los productos a tu carrito',
    'Completa el formulario de cotización',
    'Recibe tu cotización personalizada',
    'Confirma tu pedido y método de pago'
  ];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Contáctenos</h1>
        <p className="text-lg text-gray-600">Estamos aquí para ayudarte con todas tus necesidades de limpieza.</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* About Us */}
        <div className="lg:col-span-2 space-y-8">
          <section className="bg-white p-8 rounded-lg shadow-md">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Nosotros</h2>
            <div className="prose prose-gray">
              <p className="text-gray-600 leading-relaxed mb-4">
                SUPROSER con más de 15 años de experiencia se dedica a la distribución de productos de limpieza de alta calidad, cuya principal utilidad son las de: aseo personal, limpieza y desinfección para industrias, supermercados, hospitales, hoteles, oficinas, veterinarias, talleres y hogares, llegando a los canales de distribución, mayoristas y minoristas con nuestra amplia y variada línea de productos que comercializamos para satisfacer las necesidades y la demanda de nuestra selecta clientela porque lo que nos motiva es llegar al cliente con nuestros productos de calidad comprobada para mejorar su vida.
              </p>
              <p className="text-gray-600 leading-relaxed mb-4">
                Nos preocupamos por un entorno ecológico limpio y sostenible. Por ello invertimos en la investigación y mejora de formulas y productos que sean consecuentes con nuestra filosofía verde de cuidado del ambiente.
              </p>
              <p className="text-gray-600 leading-relaxed">
                Compartir técnicas y métodos de limpieza con nuestros clientes y demostrar la eficiencia de los productos que proveemos. Ayudar a elegir el o los productos para mantener la limpieza al menor costo, haciendo una combinación adecuada puede ahorrar costos y aumentar la eficiencia.
              </p>
            </div>
          </section>

          {/* How to Buy */}
          <section className="bg-white p-8 rounded-lg shadow-md">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">¿Cómo Comprar?</h2>
            
            <div className="aspect-video mb-6 rounded-lg overflow-hidden bg-gray-100">
              <iframe
                src="https://www.youtube.com/embed/dQw4w9WgXcQ"
                title="Cómo comprar en SUPROSER"
                className="w-full h-full"
                frameBorder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
              />
            </div>
            
            <div className="space-y-3">
              {steps.map((step, index) => (
                <div key={index} className="flex items-start space-x-3">
                  <div className="bg-blue-600 text-white rounded-full w-6 h-6 flex items-center justify-center text-sm font-semibold flex-shrink-0 mt-0.5">
                    {index + 1}
                  </div>
                  <p className="text-gray-700">{step}</p>
                </div>
              ))}
            </div>
          </section>
        </div>

        {/* Contact Form */}
        <div className="bg-white p-8 rounded-lg shadow-md h-fit">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Formulario de Contacto</h2>
          
          <form onSubmit={handleSubmit} className="space-y-6">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Nombre completo *
                </label>
                <input
                  type="text"
                  name="name"
                  value={formData.name}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Email *
                </label>
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  required
                />
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Empresa
                </label>
                <input
                  type="text"
                  name="company"
                  value={formData.company}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Teléfono
                </label>
                <input
                  type="tel"
                  name="phone"
                  value={formData.phone}
                  onChange={handleInputChange}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Mensaje *
              </label>
              <textarea
                name="message"
                value={formData.message}
                onChange={handleInputChange}
                rows={5}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Cuéntanos sobre tus necesidades de limpieza..."
                required
              />
            </div>

            <button
              type="submit"
              className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200 flex items-center justify-center space-x-2"
            >
              <Send className="h-4 w-4" />
              <span>Enviar Mensaje</span>
            </button>
          </form>

          {/* Contact Info */}
          <div className="mt-8 pt-8 border-t border-gray-200 space-y-4">
            <div className="text-sm text-gray-700 mb-4">
              <p className="font-medium text-gray-900 mb-2">Nuestros asesores están atento para brindarle la mejor atención, puedes contactarnos:</p>
              <p>Calle 9, Río Abajo, bodega Suproser</p>
              <p>Teléfono: +507 213-2929 / +507 6349 9962</p>
              <p>jgb@suproser.com</p>
            </div>
            <div className="flex items-center space-x-3 text-gray-600">
              <Phone className="h-5 w-5 text-blue-600" />
              <span>+507 213-2929 / +507 6349 9962</span>
            </div>
            <div className="flex items-center space-x-3 text-gray-600">
              <Mail className="h-5 w-5 text-blue-600" />
              <span>jgb@suproser.com</span>
            </div>
            <div className="flex items-center space-x-3 text-gray-600">
              <MapPin className="h-5 w-5 text-blue-600" />
              <span>Calle 9, Río Abajo, bodega Suproser, Panamá</span>
            </div>
          </div>
        </div>
      </div>

      {/* Map Section */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden mt-8">
        <div className="p-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Nuestra Ubicación</h2>
          <div className="aspect-video rounded-lg overflow-hidden">
            <iframe
              src={GOOGLE_MAPS_EMBED_URL}
              width="100%"
              height="100%"
              style={{ border: 0 }}
              allowFullScreen
              loading="lazy"
              referrerPolicy="no-referrer-when-downgrade"
              title="Ubicación Lab-pro / SUPROSER"
            />
          </div>
        </div>
      </div>
    </div>
  );
}