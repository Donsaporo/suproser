import { useState, useEffect } from 'react';

declare global {
  interface Window {
    btnyappy: {
      eventPayment: (data: {
        transactionId: string;
        token: string;
        documentName: string;
      }) => void;
    };
    YappyButtonEvents: {
      eventClick: () => void;
      eventSuccess: (data: any) => void;
      eventError: (error: any) => void;
      eventCancel: () => void;
    };
  }
}

interface YappyPaymentData {
  transactionId: string;
  token: string;
  documentName: string;
  shortOrderId: string;
  total: number;
}

export function useYappyPayment(orderId: string | null) {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [paymentData, setPaymentData] = useState<YappyPaymentData | null>(null);
  const [isScriptLoaded, setIsScriptLoaded] = useState(false);

  // Load Yappy script on mount
  useEffect(() => {
    loadYappyScript();
  }, []);

  const loadYappyScript = () => {
    if (document.querySelector('script[src*="yappy"]')) {
      setIsScriptLoaded(true);
      return;
    }

    // Use UAT for development (change to prod later)
    // Always use UAT in development environment
    const scriptUrl = 'https://bt-cdn-uat.yappycloud.com/v1/cdn/web-component-btn-yappy.js';

    const script = document.createElement('script');
    script.src = scriptUrl;
    script.onload = () => {
      console.log('yappy:script:loaded');
      setIsScriptLoaded(true);
      setupYappyEvents();
    };
    script.onerror = () => {
      console.error('yappy:script:failed');
      setError('Failed to load Yappy payment script');
    };
    document.head.appendChild(script);
  };

  const setupYappyEvents = () => {
    // Setup global event handlers
    window.YappyButtonEvents = {
      eventClick: () => {
        console.log('yappy:event:click');
        if (orderId) {
          initiatePayment(orderId);
        }
      },
      eventSuccess: (data) => {
        console.log('yappy:event:success', data);
        setError(null);
        // Don't change order status here - wait for IPN
        alert('¡Pago exitoso! Verificando transacción...');
      },
      eventError: (error) => {
        console.error('yappy:event:error', error);
        setError('Error en el pago: ' + (error.message || 'Error desconocido'));
      },
      eventCancel: () => {
        console.log('yappy:event:cancel');
        setError('Pago cancelado por el usuario');
      }
    };
  };

  const initiatePayment = async (orderIdToProcess: string) => {
    if (isLoading) return;

    try {
      setIsLoading(true);
      setError(null);
      console.log('yappy:payment:start', orderIdToProcess);

      // Call backend to create payment
      const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/yappy-create`;
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ orderId: orderIdToProcess })
      });

      const result = await response.json();
      
      if (!result.success) {
        throw new Error(result.error || 'Failed to create payment');
      }

      const data: YappyPaymentData = result;
      setPaymentData(data);
      
      console.log('yappy:payment:created', { 
        transactionId: data.transactionId,
        total: data.total 
      });

      // Trigger Yappy payment UI
      if (window.btnyappy && window.btnyappy.eventPayment) {
        window.btnyappy.eventPayment({
          transactionId: data.transactionId,
          token: data.token,
          documentName: data.documentName
        });
        console.log('yappy:payment:triggered');
      } else {
        throw new Error('Yappy button not available');
      }

    } catch (err) {
      console.error('yappy:payment:error', err);
      setError(err instanceof Error ? err.message : 'Error creating payment');
    } finally {
      setIsLoading(false);
    }
  };

  return {
    isLoading,
    error,
    paymentData,
    isScriptLoaded,
    initiatePayment: orderId ? () => initiatePayment(orderId) : undefined
  };
}