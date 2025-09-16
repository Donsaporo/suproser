import { useState, useEffect } from 'react';

interface CartItem {
  product: {
    id: string;
    slug: string;
    name: string;
    description: string;
    price: number;
    unit: string;
    image: string;
    images: string[];
    category: string;
    featured?: boolean;
  };
  quantity: number;
}

const CART_STORAGE_KEY = 'suproser-cart-v2'; // Changed key to reset any corrupted data

export function useCart() {
  const [items, setItems] = useState<CartItem[]>([]);
  const [isInitialized, setIsInitialized] = useState(false);

  // Load cart from localStorage on mount
  useEffect(() => {
    try {
      console.debug('cart:init:start');
      const savedCart = localStorage.getItem(CART_STORAGE_KEY);
      console.debug('cart:init:raw', { savedCart: savedCart ? savedCart.slice(0, 100) + '...' : 'null' });
      
      if (savedCart) {
        const parsed = JSON.parse(savedCart);
        console.debug('cart:init:parsed', { 
          isArray: Array.isArray(parsed), 
          length: parsed?.length,
          sample: parsed?.[0] ? {
            productId: parsed[0].product?.id,
            productName: parsed[0].product?.name,
            quantity: parsed[0].quantity
          } : null
        });
        
        if (Array.isArray(parsed)) {
          // Validate each item structure
          const validItems = parsed.filter(item => 
            item && 
            typeof item === 'object' && 
            item.product && 
            typeof item.product === 'object' &&
            item.product.id && 
            item.product.name && 
            typeof item.quantity === 'number' &&
            item.quantity > 0
          );
          
          console.debug('cart:init:validated', { 
            original: parsed.length, 
            valid: validItems.length 
          });
          
          setItems(validItems);
          
          if (validItems.length !== parsed.length) {
            // Save cleaned data back to localStorage
            localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(validItems));
            console.debug('cart:init:cleaned');
          }
        } else {
          console.warn('cart:init:invalid-format', 'Not an array, clearing');
          localStorage.removeItem(CART_STORAGE_KEY);
          setItems([]);
        }
      } else {
        console.debug('cart:init:empty');
        setItems([]);
      }
    } catch (error) {
      console.error('cart:init:error', error);
      localStorage.removeItem(CART_STORAGE_KEY);
      setItems([]);
    } finally {
      setIsInitialized(true);
      console.debug('cart:init:complete');
    }
  }, []);

  // Save cart to localStorage whenever items change (but only after initialization)
  useEffect(() => {
    if (!isInitialized) return;
    
    try {
      const cartData = JSON.stringify(items);
      localStorage.setItem(CART_STORAGE_KEY, cartData);
      console.debug('cart:save:ok', { 
        itemsCount: items.length,
        dataSize: cartData.length,
        sample: items[0] ? {
          productId: items[0].product.id,
          productName: items[0].product.name,
          quantity: items[0].quantity
        } : null
      });
    } catch (error) {
      console.error('cart:save:error', error);
    }
  }, [items, isInitialized]);

  const addItem = (product: CartItem['product'], quantity: number = 1): boolean => {
    try {
      console.debug('cart:add:start', { 
        productId: product.id, 
        productName: product.name,
        quantity,
        initialized: isInitialized
      });

      // Validate product structure
      if (!product || !product.id || !product.name || typeof product.price !== 'number') {
        console.error('cart:add:invalid-product', product);
        return false;
      }

      if (typeof quantity !== 'number' || quantity <= 0) {
        console.error('cart:add:invalid-quantity', quantity);
        return false;
      }

      setItems(currentItems => {
        const existingIndex = currentItems.findIndex(item => item.product.id === product.id);
        
        if (existingIndex >= 0) {
          console.debug('cart:add:update-existing', { 
            oldQty: currentItems[existingIndex].quantity, 
            newQty: currentItems[existingIndex].quantity + quantity 
          });
          
          const updatedItems = currentItems.map((item, index) =>
            index === existingIndex 
              ? { ...item, quantity: item.quantity + quantity }
              : item
          );
          
          return updatedItems;
        } else {
          console.debug('cart:add:new-item', { productName: product.name });
          
          const newItem: CartItem = { 
            product: {
              id: product.id,
              slug: product.slug,
              name: product.name,
              description: product.description || '',
              price: product.price,
              unit: product.unit || 'Unidad',
              image: product.image,
              images: product.images || [product.image],
              category: product.category,
              featured: product.featured || false
            }, 
            quantity 
          };
          
          const updatedItems = [...currentItems, newItem];
          console.debug('cart:add:new-total', updatedItems.length);
          return updatedItems;
        }
      });
      
      console.debug('cart:add:success');
      return true;
    } catch (error) {
      console.error('cart:add:error', error);
      return false;
    }
  };

  const updateQuantity = (productId: string, quantity: number): void => {
    try {
      if (quantity <= 0) {
        removeItem(productId);
        return;
      }
      
      console.debug('cart:update:start', { productId, quantity });
      
      setItems(currentItems =>
        currentItems.map(item =>
          item.product.id === productId
            ? { ...item, quantity }
            : item
        )
      );
      
      console.debug('cart:update:success');
    } catch (error) {
      console.error('cart:update:error', error);
    }
  };

  const removeItem = (productId: string): void => {
    try {
      console.debug('cart:remove:start', productId);
      
      setItems(currentItems =>
        currentItems.filter(item => item.product.id !== productId)
      );
      
      console.debug('cart:remove:success');
    } catch (error) {
      console.error('cart:remove:error', error);
    }
  };

  const clearCart = (): void => {
    try {
      console.debug('cart:clear:start');
      setItems([]);
      localStorage.removeItem(CART_STORAGE_KEY);
      console.debug('cart:clear:success');
    } catch (error) {
      console.error('cart:clear:error', error);
    }
  };

  const getTotalItems = (): number => {
    try {
      const total = items.reduce((total, item) => total + item.quantity, 0);
      return total;
    } catch (error) {
      console.error('cart:total-items:error', error);
      return 0;
    }
  };

  const getTotalPrice = (): number => {
    try {
      const total = items.reduce((total, item) => total + (item.product.price * item.quantity), 0);
      return total;
    } catch (error) {
      console.error('cart:total-price:error', error);
      return 0;
    }
  };

  return {
    items,
    addItem,
    updateQuantity,
    removeItem,
    clearCart,
    getTotalItems,
    getTotalPrice,
    isInitialized
  };
}