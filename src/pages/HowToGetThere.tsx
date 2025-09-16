import React from 'react';
import { MapPin, Clock, Phone, Mail } from 'lucide-react';
import { GOOGLE_MAPS_EMBED_URL } from '../config/constants';

export default function HowToGetThere() {
  const schedules = [
    { day: 'Lunes - Viernes', hours: '8:00 AM - 6:00 PM' },
    { day: 'Sábados', hours: '8:00 AM - 2:00 PM' },
    { day: 'Domingos', hours: 'Cerrado' },
  ];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Cómo Llegar</h1>
        <p className="text-lg text-gray-600">Visítanos en nuestra sede principal.</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Contact Information */}
        <div className="space-y-8">
          <div className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">Información de Contacto</h2>
            
            <div className="space-y-4">
              <div className="flex items-start space-x-3">
                <MapPin className="h-5 w-5 text-blue-600 mt-1" />
                <div>
                  <h3 className="font-semibold text-gray-900">Dirección</h3>
                  <p className="text-gray-600">
                    Calle 123 #45-67<br />
                    Zona Industrial Norte<br />
                    Bogotá, Colombia
                  </p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <Phone className="h-5 w-5 text-blue-600 mt-1" />
                <div>
                  <h3 className="font-semibold text-gray-900">Teléfono</h3>
                  <p className="text-gray-600">+57 (1) 234-5678</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-3">
                <Mail className="h-5 w-5 text-blue-600 mt-1" />
                <div>
                  <h3 className="font-semibold text-gray-900">Email</h3>
                  <p className="text-gray-600">info@suproser.com</p>
                </div>
              </div>
            </div>
          </div>

          {/* Schedule */}
          <div className="bg-white p-6 rounded-lg shadow-md">
            <h2 className="text-2xl font-bold text-gray-900 mb-6 flex items-center">
              <Clock className="h-6 w-6 text-blue-600 mr-2" />
              Horarios de Atención
            </h2>
            
            <div className="space-y-3">
              {schedules.map((schedule, index) => (
                <div key={index} className="flex justify-between items-center py-2 border-b border-gray-100 last:border-b-0">
                  <span className="font-medium text-gray-900">{schedule.day}</span>
                  <span className="text-gray-600">{schedule.hours}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Additional Info */}
          <div className="bg-blue-50 p-6 rounded-lg">
            <h3 className="font-semibold text-blue-900 mb-3">Información Adicional</h3>
            <ul className="text-blue-800 text-sm space-y-2">
              <li>• Parqueadero disponible para clientes</li>
              <li>• Entrada por la puerta principal</li>
              <li>• Recepción en bodega Suproser.</li>
              <li>• Cita previa recomendada para asesorías.</li>
            </ul>
          </div>
        </div>

        {/* Map */}
        <div className="bg-white p-6 rounded-lg shadow-md">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Ubicación</h2>
          <div className="aspect-video rounded-lg overflow-hidden">
            <iframe
              src={GOOGLE_MAPS_EMBED_URL}
              width="100%"
              height="100%"
              style={{ border: 0 }}
              allowFullScreen
              loading="lazy"
              referrerPolicy="no-referrer-when-downgrade"
              title="Ubicación Lab-pro / Suproser - Río Abajo"
            />
          </div>
        </div>
      </div>
    </div>
  );
}