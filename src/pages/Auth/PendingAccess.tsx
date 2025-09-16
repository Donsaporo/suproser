import React from 'react';
import { Clock, Mail, Phone } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

export default function PendingAccess() {
  const { user, profile } = useAuth();

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div className="text-center">
          <Clock className="mx-auto h-16 w-16 text-yellow-500" />
          <h2 className="mt-6 text-3xl font-bold text-gray-900">
            Acceso Pendiente
          </h2>
          <p className="mt-2 text-sm text-gray-600">
            Tu cuenta está siendo revisada
          </p>
        </div>
        
        <div className="bg-white rounded-lg shadow-md p-6 space-y-4">
          <div className="text-center">
            <h3 className="text-lg font-medium text-gray-900 mb-4">
              Hola {profile?.display_name || user?.email}
            </h3>
            <p className="text-gray-600 mb-4">
              Tu rol aún no está configurado en el sistema. Un administrador debe 
              asignarte los permisos necesarios para acceder a tu panel de control.
            </p>
            <p className="text-sm text-gray-500">
              Este proceso puede tomar hasta 24 horas hábiles.
            </p>
          </div>
          
          <div className="border-t border-gray-200 pt-4">
            <h4 className="font-medium text-gray-900 mb-3">
              ¿Necesitas ayuda?
            </h4>
            <div className="space-y-2 text-sm text-gray-600">
              <div className="flex items-center space-x-2">
                <Mail className="h-4 w-4 text-blue-600" />
                <span>info@suproser.com</span>
              </div>
              <div className="flex items-center space-x-2">
                <Phone className="h-4 w-4 text-blue-600" />
                <span>+57 (1) 234-5678</span>
              </div>
            </div>
          </div>
        </div>
        
        <div className="text-center">
          <button
            onClick={() => window.location.reload()}
            className="text-blue-600 hover:text-blue-700 text-sm font-medium"
          >
            Actualizar estado
          </button>
        </div>
      </div>
    </div>
  );
}