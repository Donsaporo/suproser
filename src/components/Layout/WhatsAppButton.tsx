import React from 'react';
import { MessageCircle } from 'lucide-react';
import { WHATSAPP_NUMBER } from '../../config/constants';

export default function WhatsAppButton() {
  const handleWhatsAppClick = () => {
    const message = encodeURIComponent('Hola, me interesa conocer más sobre los productos de limpieza SUPROSER.');
    window.open(`https://wa.me/${WHATSAPP_NUMBER.replace(/[^0-9]/g, '')}?text=${message}`, '_blank');
  };

  return (
    <button
      onClick={handleWhatsAppClick}
      className="fixed bottom-6 left-6 bg-green-500 hover:bg-green-600 text-white p-4 rounded-full shadow-lg transition-all duration-300 hover:scale-105 z-50"
      aria-label="Contactar por WhatsApp"
    >
      <MessageCircle className="h-6 w-6" />
    </button>
  );
}