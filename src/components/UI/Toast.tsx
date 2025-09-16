import React, { useState, useEffect } from 'react';
import { CheckCircle, AlertCircle, X, Info } from 'lucide-react';

export interface ToastData {
  id: string;
  type: 'success' | 'error' | 'info' | 'warning';
  title: string;
  message?: string;
  duration?: number;
}

interface ToastProps {
  toast: ToastData;
  onDismiss: (id: string) => void;
}

export function Toast({ toast, onDismiss }: ToastProps) {
  const [isVisible, setIsVisible] = useState(false);
  const [isExiting, setIsExiting] = useState(false);

  useEffect(() => {
    // Animate in
    const timer = setTimeout(() => setIsVisible(true), 10);
    
    // Auto dismiss
    if (toast.duration !== 0) { // 0 means don't auto-dismiss
      const dismissTimer = setTimeout(() => {
        handleDismiss();
      }, toast.duration || 5000);
      
      return () => {
        clearTimeout(timer);
        clearTimeout(dismissTimer);
      };
    }
    
    return () => clearTimeout(timer);
  }, [toast.duration]);

  const handleDismiss = () => {
    setIsExiting(true);
    setTimeout(() => {
      onDismiss(toast.id);
    }, 300);
  };

  const getIcon = () => {
    switch (toast.type) {
      case 'success':
        return <CheckCircle className="h-5 w-5 text-green-600" />;
      case 'error':
        return <AlertCircle className="h-5 w-5 text-red-600" />;
      case 'warning':
        return <AlertCircle className="h-5 w-5 text-yellow-600" />;
      case 'info':
        return <Info className="h-5 w-5 text-blue-600" />;
    }
  };

  const getStyles = () => {
    switch (toast.type) {
      case 'success':
        return 'bg-green-50 border-green-200 text-green-800';
      case 'error':
        return 'bg-red-50 border-red-200 text-red-800';
      case 'warning':
        return 'bg-yellow-50 border-yellow-200 text-yellow-800';
      case 'info':
        return 'bg-blue-50 border-blue-200 text-blue-800';
    }
  };

  return (
    <div
      className={`flex items-start space-x-3 p-4 border rounded-lg shadow-lg transition-all duration-300 ${
        isVisible && !isExiting 
          ? 'opacity-100 transform translate-x-0' 
          : 'opacity-0 transform translate-x-full'
      } ${getStyles()}`}
    >
      {getIcon()}
      <div className="flex-1 min-w-0">
        <div className="font-semibold">{toast.title}</div>
        {toast.message && (
          <div className="text-sm mt-1 opacity-90">{toast.message}</div>
        )}
      </div>
      <button
        onClick={handleDismiss}
        className="flex-shrink-0 ml-2 text-gray-400 hover:text-gray-600 transition-colors duration-200"
      >
        <X className="h-4 w-4" />
      </button>
    </div>
  );
}

export default function ToastContainer() {
  const [toasts, setToasts] = useState<ToastData[]>([]);

  useEffect(() => {
    const handleToast = (event: CustomEvent<ToastData>) => {
      const newToast = { ...event.detail, id: Date.now().toString() };
      setToasts(prev => [...prev, newToast]);
    };

    window.addEventListener('toast', handleToast as EventListener);
    return () => window.removeEventListener('toast', handleToast as EventListener);
  }, []);

  const dismissToast = (id: string) => {
    setToasts(prev => prev.filter(toast => toast.id !== id));
  };

  return (
    <div className="fixed top-20 right-4 z-50 space-y-3 max-w-sm w-full">
      {toasts.map(toast => (
        <Toast key={toast.id} toast={toast} onDismiss={dismissToast} />
      ))}
    </div>
  );
}