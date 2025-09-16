import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Trash2, Plus, Minus, ArrowLeft, ShoppingBag, X } from 'lucide-react';
import { useCart } from '../hooks/useCart';
import { useAuth } from '../contexts/AuthContext';
import { useState } from 'react';
import { formatPrice } from '../utils/format';
import { showSuccess, showError } from '../utils/toast';
import LoadingSpinner from '../components/UI/LoadingSpinner';
import { createOrder, addOrderItem, createGuestOrderDetails, updateOrderStatus } from '../services/orders';
import YappyButton from '../components/Payments/YappyButton';

export default function Cart() {
  const { 
    items, 
    updateQuantity, 
    removeItem, 
    getTotalPrice, 
    getTotalItems,
    clearCart
  } = useCart();
  
  const { user, profile } = useAuth();
  const navigate = useNavigate();
  
  const [showCheckoutForm, setShowCheckoutForm] = useState(false);
  const [checkoutData, setCheckoutData] = useState({
    name: '',
    email: '',
    phone: '',
    company: '',
    address: '',
    notes: ''
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [currentOrderId, setCurrentOrderId] = useState<string | null>(null);
  const [showPaymentOptions, setShowPaymentOptions] = useState(false);

  // Guest Client and Branch IDs (these are fixed in the DB migration)
  const GUEST_CLIENT_ID = '00000000-0000-0000-0000-000000000001';
  const GUEST_BRANCH_ID = '00000000-0000-0000-0000-000000000002';

  const handleClearCart = () => {
    if (confirm('¿Estás seguro de que quieres vaciar el carrito?')) {
      clearCart();
      showSuccess('Carrito vaciado', 'Todos los productos fueron removidos');
    }
  };

  const handleRemoveItem = (productId: string) => {
    removeItem(productId);
    showSuccess('Producto removido', 'El producto fue eliminado del carrito');
  };

  const handleCheckoutFormChange = (field: string, value: string) => {
    setCheckoutData(prev => ({
      ...prev,
      [field]: value
    }));
  };

  const handleSubmitGuestOrder = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isSubmitting) return;

    // Validate required fields
    if (!checkoutData.name.trim() || !checkoutData.email.trim() || !checkoutData.phone.trim()) {
      showError('Campos requeridos', 'Por favor completa todos los campos obligatorios');
      return;
    }

    try {
      setIsSubmitting(true);
      console.debug('cart:guest-order:start', { 
        itemsCount: items.length,
        total: getTotalPrice(),
        customer: checkoutData.name
      });

      // 1. Get or create an anonymous user ID via Edge Function
      const anonymousUserResponse = await fetch('/functions/v1/create-anonymous-user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${import.meta.env.VITE_SUPABASE_ANON_KEY}`
        },
        body: JSON.stringify({}) // No body needed for this function
      });

      if (!anonymousUserResponse.ok) {
        const errorData = await anonymousUserResponse.json();
        throw new Error(errorData.error || 'Failed to get anonymous user ID');
      }

      const { user_id: anonymousUserId } = await anonymousUserResponse.json();
      console.debug('cart:guest-order:anonymous-user-id', anonymousUserId);

      // 2. Create the order with generic IDs and the anonymous user ID
      const order = await createOrder({
        client_id: GUEST_CLIENT_ID,
        branch_id: GUEST_BRANCH_ID,
        created_by: anonymousUserId // Use the dynamically created anonymous user ID
      });

      setCurrentOrderId(order.id);
      console.debug('cart:guest-order:order-created', order.id);

      // 2. Add items to the order
      for (const item of items) {
        await addOrderItem({
          order_id: order.id,
          product_id: item.product.id,
          qty: item.quantity,
          unit_price: item.product.price
        });
      }
      console.debug('cart:guest-order:items-added', items.length);

      // 3. Save guest details
      await createGuestOrderDetails({
        order_id: order.id,
        name: checkoutData.name,
        email: checkoutData.email,
        phone: checkoutData.phone,
        company: checkoutData.company || null,
        address: checkoutData.address || null,
        notes: checkoutData.notes || null
      });
      console.debug('cart:guest-order:details-saved');
      
      showSuccess(
        'Pedido creado', 
        'Ahora puedes proceder con el pago.'
      );
      
      setShowCheckoutForm(false);
      setShowPaymentOptions(true); // Show payment options after order is created
      
    } catch (error) {
      console.error('cart:guest-order:error', error);
      showError('Error', 'No se pudo crear el pedido. Inténtalo de nuevo.');
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleYappySuccess = () => {
    showSuccess('¡Pago exitoso!', 'Tu pedido ha sido confirmado.');
    clearCart();
    setCheckoutData({
      name: '', email: '', phone: '', company: '', address: '', notes: ''
    });
    setCurrentOrderId(null);
    setShowPaymentOptions(false);
    navigate('/contactenos'); // Redirect to a confirmation or contact page
  };

  const handleYappyError = (errorMessage: string) => {
    showError('Error en el pago', errorMessage);
    // Optionally, update order status to 'error' in DB
    if (currentOrderId) {
      updateOrderStatus(currentOrderId, 'error');
    }
  };

  if (items.length === 0) {
    return (
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="text-center">
          <ShoppingBag className="h-16 w-16 text-gray-300 mx-auto mb-4" />
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Tu carrito está vacío</h1>
          <p className="text-gray-600 mb-8">Agrega algunos productos para comenzar tu compra</p>
          <Link
            to="/productos"
            className="inline-block bg-blue-600 text-white px-8 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200"
          >
            Ver Productos
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Header */}
      <div className="mb-8">
        <Link
          to="/productos"
          className="inline-flex items-center text-blue-600 hover:text-blue-700 transition-colors duration-200 mb-4"
        >
          <ArrowLeft className="h-4 w-4 mr-2" />
          Continuar comprando
        </Link>
        <h1 className="text-3xl font-bold text-gray-900">Carrito de Compras</h1>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Cart Items */}
        <div className="lg:col-span-2 space-y-4">
          {items.map((item) => (
            <div key={item.product.id} className="bg-white p-6 rounded-lg shadow-md">
              <div className="flex items-center space-x-4">
                <img
                  src={item.product.image}
                  alt={item.product.name}
                  className="w-20 h-20 object-cover rounded-lg"
                  loading="lazy"
                />
                
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900">{item.product.name}</h3>
                  <p className="text-sm text-gray-600">{item.product.unit}</p>
                  <p className="text-lg font-bold text-blue-600">
                    {formatPrice(item.product.price)}
                  </p>
                </div>
                
                <div className="flex items-center space-x-3">
                  <button
                    onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
                    className="p-1 border border-gray-300 rounded hover:bg-gray-50 transition-colors duration-200"
                  >
                    <Minus className="h-4 w-4" />
                  </button>
                  <span className="w-12 text-center font-semibold">{item.quantity}</span>
                  <button
                    onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
                    className="p-1 border border-gray-300 rounded hover:bg-gray-50 transition-colors duration-200"
                  >
                    <Plus className="h-4 w-4" />
                  </button>
                </div>
                
                <div className="text-right">
                  <p className="font-bold text-lg text-blue-600">
                    {formatPrice(item.product.price * item.quantity)}
                  </p>
                  <button
                    onClick={() => handleRemoveItem(item.product.id)}
                    className="text-red-600 hover:text-red-700 transition-colors duration-200 mt-2"
                    title="Eliminar del carrito"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
            </div>
          ))}
          
          <button
            onClick={handleClearCart}
            className="text-red-600 hover:text-red-700 transition-colors duration-200 text-sm hover:underline"
          >
            Vaciar carrito ({getTotalItems()} productos)
          </button>
        </div>

        {/* Order Summary */}
        <div className="bg-white p-6 rounded-lg shadow-md h-fit">
          <h2 className="text-xl font-bold text-gray-900 mb-6">Resumen del Pedido</h2>
          
          <div className="space-y-4 mb-6">
            <div className="flex justify-between">
              <span className="text-gray-600">Subtotal:</span>
              <span className="font-semibold">{formatPrice(getTotalPrice())}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Total productos:</span>
              <span className="font-semibold">{getTotalItems()} items</span>
            </div>
            <div className="border-t border-gray-200 pt-4">
              <div className="flex justify-between">
                <span className="text-lg font-bold">Total:</span>
                <span className="text-lg font-bold text-blue-600">
                  {formatPrice(getTotalPrice())}
                </span>
              </div>
            </div>
          </div>
          
          {user ? (
            <div className="space-y-3">
              <button 
                onClick={() => {
                  // Redirect to appropriate dashboard for business orders
                  if (profile?.role_app === 'admin') {
                    showError('Acceso no permitido', 'Los administradores no pueden crear órdenes');
                  } else if (profile?.role_app === 'cliente_master') {
                    navigate('/mi-empresa/nueva-orden');
                  } else if (profile?.role_app === 'cliente_gerente_sucursal') {
                    navigate('/mi-sucursal/nuevo-pedido');
                  } else {
                    navigate('/acceso-pendiente');
                  }
                }}
                className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200"
              >
                Crear Pedido Empresarial
              </button>
              <div className="text-center">
                <p className="text-xs text-gray-600 mb-2">O comprar como cliente particular:</p>
                <button
                  onClick={() => setShowCheckoutForm(true)}
                  className="w-full bg-green-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-green-700 transition-colors duration-200"
                >
                  Proceder al Pago
                </button>
              </div>
            </div>
          ) : (
            <div className="space-y-3">
              <button 
                onClick={() => setShowCheckoutForm(true)}
                className="w-full bg-blue-600 text-white py-3 px-6 rounded-lg font-semibold hover:bg-blue-700 transition-colors duration-200"
              >
                Proceder al Pago
              </button>
              <div className="text-center">
                <p className="text-xs text-gray-600 mb-2">¿Eres cliente empresarial?</p>
                <button
                  onClick={() => navigate('/', { state: { showAuth: true } })}
                  className="text-blue-600 hover:text-blue-700 text-sm font-medium"
                >
                  Iniciar sesión para precios especiales
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Checkout Form Modal for Guest Users */}
      {showCheckoutForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-gray-900">
                Información de Contacto y Envío
              </h3>
              <button
                onClick={() => setShowCheckoutForm(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
            
            <form onSubmit={handleSubmitGuestOrder} className="p-6 space-y-6">
              {/* Customer Information */}
              <div>
                <h4 className="text-md font-semibold text-gray-900 mb-4">Tus Datos</h4>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Nombre completo *
                    </label>
                    <input
                      type="text"
                      name="name"
                      value={checkoutData.name}
                      onChange={(e) => handleCheckoutFormChange('name', e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
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
                      value={checkoutData.email}
                      onChange={(e) => handleCheckoutFormChange('email', e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Teléfono *
                    </label>
                    <input
                      type="tel"
                      name="phone"
                      value={checkoutData.phone}
                      onChange={(e) => handleCheckoutFormChange('phone', e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      required
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">
                      Empresa
                    </label>
                    <input
                      type="text"
                      name="company"
                      value={checkoutData.company}
                      onChange={(e) => handleCheckoutFormChange('company', e.target.value)}
                      className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                  </div>
                </div>

                <div className="mt-4">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Dirección de entrega
                  </label>
                  <textarea
                    name="address"
                    value={checkoutData.address}
                    onChange={(e) => handleCheckoutFormChange('address', e.target.value)}
                    rows={3}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Dirección completa donde requiere la entrega"
                  />
                </div>

                <div className="mt-4">
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Notas adicionales
                  </label>
                  <textarea
                    name="notes"
                    value={checkoutData.notes}
                    onChange={(e) => handleCheckoutFormChange('notes', e.target.value)}
                    rows={2}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Requisitos especiales, fechas de entrega preferidas, etc."
                  />
                </div>
              </div>

              {/* Order Summary */}
              <div>
                <h4 className="text-md font-semibold text-gray-900 mb-4">Resumen del Pedido</h4>
                <div className="bg-gray-50 p-4 rounded-lg">
                  <div className="space-y-2">
                    {items.map((item) => (
                      <div key={item.product.id} className="flex justify-between text-sm">
                        <span>{item.quantity}x {item.product.name}</span>
                        <span>{formatPrice(item.product.price * item.quantity)}</span>
                      </div>
                    ))}
                    <div className="border-t border-gray-200 pt-2 mt-2">
                      <div className="flex justify-between font-semibold">
                        <span>Total:</span>
                        <span className="text-blue-600">{formatPrice(getTotalPrice())}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <div className="flex justify-end space-x-3 pt-4 border-t">
                <button
                  type="button"
                  onClick={() => setShowCheckoutForm(false)}
                  className="px-6 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors duration-200"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200 disabled:opacity-50 flex items-center space-x-2"
                >
                  {isSubmitting ? (
                    <>
                      <LoadingSpinner size="sm" />
                      <span>Creando Pedido...</span>
                    </>
                  ) : (
                    <>
                      <span>Continuar al Pago</span>
                    </>
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Payment Options Modal */}
      {showPaymentOptions && currentOrderId && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg shadow-xl w-full max-w-md">
            <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-gray-900">
                Procesar Pago
              </h3>
              <button
                onClick={() => setShowPaymentOptions(false)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-5 w-5" />
              </button>
            </div>
            
            <div className="p-6 space-y-4">
              <div className="text-center">
                <p className="text-gray-700 mb-2">Total a pagar:</p>
                <p className="text-2xl font-bold text-blue-600">{formatPrice(getTotalPrice())}</p>
              </div>
              
              <div className="border-t border-gray-200 pt-4">
                <h4 className="text-sm font-semibold text-gray-900 mb-3">Métodos de pago disponibles:</h4>
                
                {/* Yappy Payment Button */}
                <YappyButton
                  orderId={currentOrderId}
                  amount={getTotalPrice()}
                  onSuccess={handleYappySuccess}
                  onError={handleYappyError}
                  size="lg"
                  className="mb-3"
                />
                
                {/* Future payment methods can be added here */}
                <div className="text-center">
                  <p className="text-xs text-gray-500">
                    Más métodos de pago próximamente
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}