import React, { useEffect } from 'react';
import LoadingSpinner from '../UI/LoadingSpinner';
import { useYappyPayment } from '../../hooks/useYappyPayment';

interface YappyButtonProps {
  orderId: string;
  amount: number;
  onSuccess?: () => void;
  onError?: (error: string) => void;
  disabled?: boolean;
  className?: string;
  variant?: 'primary' | 'outline';
  size?: 'md' | 'lg';
}

export default function YappyButton({ 
  orderId, 
  amount, 
  onSuccess, 
  onError, 
  disabled = false,
  className = '',
  variant = 'primary',
  size = 'lg'
}: YappyButtonProps) {
  const { 
    isLoading, 
    error, 
    paymentData, 
    isScriptLoaded, 
    initiatePayment 
  } = useYappyPayment(orderId);

  useEffect(() => {
    if (error && onError) {
      onError(error);
    }
  }, [error, onError]);

  useEffect(() => {
    if (paymentData && onSuccess) {
      onSuccess();
    }
  }, [paymentData, onSuccess]);

  const handleClick = () => {
    if (disabled || isLoading || !isScriptLoaded || !amount || amount <= 0) return;
    initiatePayment?.();
  };

  const formatAmount = (amount: number) => {
    if (!amount || isNaN(amount) || amount <= 0) {
      return 'USD 0.00';
    }
    return new Intl.NumberFormat('es-PA', {
      style: 'currency',
      currency: 'USD',
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    }).format(amount);
  };

  const sizeClasses = {
    md: 'h-11 px-5 text-sm',
    lg: 'h-12 px-6 text-base'
  };

  const variantClasses = {
    primary: 'bg-yappy-primary hover:bg-yappy-primary-600 active:bg-yappy-primary-700 text-white border-transparent',
    outline: 'bg-white hover:bg-teal-50 border-yappy-primary text-yappy-primary'
  };

  const isDisabled = disabled || isLoading || !isScriptLoaded || !amount || amount <= 0;

  return (
    <div className={`space-y-2 ${className}`}>
      <button
        onClick={handleClick}
        disabled={isDisabled}
        className={`
          w-full rounded-full font-semibold border-2 
          transition-all duration-150 ease-out
          focus:outline-none focus:ring-2 focus:ring-yappy-primary focus:ring-offset-2
          disabled:opacity-60 disabled:cursor-not-allowed disabled:shadow-none
          active:scale-98
          flex items-center justify-center space-x-2
          ${sizeClasses[size]}
          ${isDisabled 
            ? 'bg-gray-300 text-gray-500 border-gray-300' 
            : variantClasses[variant]
          }
          ${!isDisabled && variant === 'primary' ? 'hover:shadow-lg shadow-yappy-shadow' : ''}
        `}
      >
        {isLoading ? (
          <>
            <LoadingSpinner size="sm" />
            <span>Procesando...</span>
          </>
        ) : (
          <>
            {/* Yappy Icon */}
            <div className={`
              w-6 h-6 rounded-full flex items-center justify-center font-bold text-sm
              ${variant === 'primary' ? 'bg-white text-yappy-primary' : 'bg-yappy-primary text-white'}
            `}>
              Y
            </div>
            <div className="flex flex-col items-center">
              <span>Pagar con Yappy</span>
              <span className="text-xs opacity-90 hidden sm:inline">
                {formatAmount(amount)}
              </span>
            </div>
          </>
        )}
      </button>

      {/* Hidden native Yappy button for events */}
      <div style={{ display: 'none' }}>
        <btn-yappy
          onclick="YappyButtonEvents.eventClick()"
          onsuccess="YappyButtonEvents.eventSuccess(arguments[0])"
          onerror="YappyButtonEvents.eventError(arguments[0])"
          oncancel="YappyButtonEvents.eventCancel()"
        />
      </div>

      {/* Error display */}
      {error && (
        <p className="text-xs text-red-600 bg-red-50 p-2 rounded">
          Error: {error}
        </p>
      )}

      {/* Success message */}
      {paymentData && (
        <p className="text-xs text-green-600 bg-green-50 p-2 rounded">
          ✅ Pago iniciado - ID: {paymentData.transactionId}
        </p>
      )}
    </div>
  );
}