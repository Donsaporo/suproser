import React from 'react';
import { Download, FileText } from 'lucide-react';
import { CATALOG_DOWNLOAD_URL } from '../config/constants';

export default function DigitalCatalog() {
  const handleDownload = () => {
    // Create a temporary anchor element to trigger download
    const link = document.createElement('a');
    link.href = CATALOG_DOWNLOAD_URL;
    link.download = 'Catalogo-Suproser-2020.pdf';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Catálogo Digital</h1>
        <p className="text-lg text-gray-600 max-w-2xl mx-auto">
          Descarga nuestro catálogo completo con toda la información detallada de nuestros productos de limpieza profesional.
        </p>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="p-8 text-center">
          <div className="mb-6">
            <FileText className="h-16 w-16 text-blue-600 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-900 mb-2">Catálogo Completo 2025</h2>
            <p className="text-gray-600">
              Más de 200 productos organizados por categorías con especificaciones técnicas completas.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-8 text-sm text-gray-600">
            <div className="text-center">
              <div className="font-semibold text-gray-900">200+</div>
              <div>Productos</div>
            </div>
            <div className="text-center">
              <div className="font-semibold text-gray-900">8</div>
              <div>Categorías</div>
            </div>
            <div className="text-center">
              <div className="font-semibold text-gray-900">PDF</div>
              <div>Alta calidad</div>
            </div>
          </div>

          <button
            onClick={handleDownload}
            className="inline-flex items-center bg-blue-600 text-white px-8 py-4 rounded-lg font-semibold hover:bg-blue-700 transition-all duration-300 transform hover:scale-105"
          >
            <Download className="h-5 w-5 mr-2" />
            Descargar Catálogo (PDF)
          </button>
          
          <p className="text-xs text-gray-500 mt-4">
            Archivo PDF - Aproximadamente 15 MB
          </p>
        </div>
      </div>
    </div>
  );
}