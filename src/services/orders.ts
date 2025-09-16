import { supabase } from '../lib/supabase';

export interface Order {
  id: string;
  client_id: string;
  branch_id: string;
  created_by: string;
  status: string;
  subtotal: number | null;
  total: number | null;
  currency: string | null;
  created_at: string | null;
  updated_at: string | null;
  // Related data
  client_branches?: {
    name: string;
  };
  user_profiles?: {
    display_name: string | null;
  };
}

export interface OrderItem {
  id: string;
  order_id: string;
  product_id: string;
  qty: string;
  unit_price: number;
  line_total: number;
  created_at: string | null;
  products?: {
    name: string;
    unit: string | null;
    image_url?: string;
    sku?: string;
  };
}

export interface OrderWithItems extends Order {
  order_items: OrderItem[];
}

export interface OrderFilters {
  status?: string;
  branchId?: string;
  page?: number;
  limit?: number;
}

export interface OrdersResponse {
  data: Order[];
  count: number;
}

export interface CreateOrderData {
  client_id: string;
  branch_id: string;
  created_by: string;
}

export interface CreateOrderItemData {
  order_id: string;
  product_id: string;
  qty: number;
  unit_price: number;
}

export interface UpdateOrderItemData {
  qty?: number;
  unit_price?: number;
}

export interface GuestOrderDetails {
  order_id: string;
  name: string;
  email: string;
  phone: string;
  company?: string | null;
  address?: string | null;
  notes?: string | null;
}

export interface EffectivePrice {
  product_id: string;
  client_id: string;
  effective_price: number;
}

// Create a new order
export async function createOrder(orderData: CreateOrderData): Promise<Order> {
  console.debug('orders:create:start', orderData);
  
  const { data, error } = await supabase
    .from('orders')
    .insert([{
      client_id: orderData.client_id,
      branch_id: orderData.branch_id,
      created_by: orderData.created_by,
      status: 'borrador',
      subtotal: 0,
      total: 0,
      currency: 'USD'
    }])
    .select()
    .single();

  if (error) {
    console.error('orders:create:error', error);
    throw error;
  }

  console.debug('orders:create:ok', data.id);
  return data;
}

// Add item to order
export async function addOrderItem(itemData: CreateOrderItemData): Promise<OrderItem> {
  console.debug('orders:add-item:start', { orderId: itemData.order_id, productId: itemData.product_id });
  
  const { data, error } = await supabase
    .from('order_items')
    .insert([{
      order_id: itemData.order_id,
      product_id: itemData.product_id,
      qty: itemData.qty,
      unit_price: itemData.unit_price
    }])
    .select()
    .single();

  if (error) {
    console.error('orders:add-item:error', error);
    throw error;
  }

  console.debug('orders:add-item:ok', data.id);
  return data;
}

// Update order item
export async function updateOrderItem(itemId: string, updates: UpdateOrderItemData): Promise<OrderItem> {
  console.debug('orders:update-item:start', { itemId, updates });
  
  const { data, error } = await supabase
    .from('order_items')
    .update(updates)
    .eq('id', itemId)
    .select()
    .single();

  if (error) {
    console.error('orders:update-item:error', error);
    throw error;
  }

  console.debug('orders:update-item:ok', data.id);
  return data;
}

// Delete order item
export async function deleteOrderItem(itemId: string): Promise<void> {
  console.debug('orders:delete-item:start', itemId);
  
  const { error } = await supabase
    .from('order_items')
    .delete()
    .eq('id', itemId);

  if (error) {
    console.error('orders:delete-item:error', error);
    throw error;
  }

  console.debug('orders:delete-item:ok', itemId);
}

// Get orders with filters
export async function getOrders(clientId: string, filters: OrderFilters = {}): Promise<OrdersResponse> {
  console.debug('orders:get:start', { clientId, filters });
  
  const { status, branchId, page = 1, limit = 10 } = filters;
  const from = (page - 1) * limit;
  const to = from + limit - 1;

  let query = supabase
    .from('orders')
    .select(`
      *,
      client_branches!inner(name),
      user_profiles!inner(display_name)
    `, { count: 'exact' })
    .eq('client_id', clientId)
    .order('created_at', { ascending: false });

  if (status && status !== 'all') {
    query = query.eq('status', status);
  }

  if (branchId) {
    query = query.eq('branch_id', branchId);
  }

  query = query.range(from, to);

  const { data, error, count } = await query;

  if (error) {
    console.error('orders:get:error', error);
    throw error;
  }

  console.debug('orders:get:ok', { count: data?.length || 0, total: count });
  
  return {
    data: data || [],
    count: count || 0
  };
}

// Get single order with items
export async function getOrder(orderId: string): Promise<OrderWithItems> {
  console.debug('orders:get-one:start', orderId);
  
  const { data, error } = await supabase
    .from('orders')
    .select(`
      *,
      client_branches(name),
      user_profiles(display_name),
      order_items(
        *,
        products(name, unit)
      )
    `)
    .eq('id', orderId)
    .single();

  if (error) {
    console.error('orders:get-one:error', error);
    throw error;
  }

  console.debug('orders:get-one:ok', { itemsCount: data.order_items?.length || 0 });
  return data;
}

// Update order status
export async function updateOrderStatus(orderId: string, newStatus: string, note?: string): Promise<void> {
  console.debug('orders:update-status:start', { orderId, newStatus, note });
  
  const { error } = await supabase
    .from('orders')
    .update({ 
      status: newStatus,
      updated_at: new Date().toISOString()
    })
    .eq('id', orderId);

  if (error) {
    console.error('orders:update-status:error', error);
    throw error;
  }

  // If there's a note, it will be handled by the database trigger
  // that creates entries in order_status_history
  
  console.debug('orders:update-status:ok', orderId);
}

// Create guest order details
export async function createGuestOrderDetails(guestData: GuestOrderDetails): Promise<void> {
  console.debug('orders:guest-details:start', { orderId: guestData.order_id, email: guestData.email });
  
  const { error } = await supabase
    .from('guest_order_details')
    .insert([{
      order_id: guestData.order_id,
      name: guestData.name,
      email: guestData.email,
      phone: guestData.phone,
      company: guestData.company || null,
      address: guestData.address || null,
      notes: guestData.notes || null
    }]);

  if (error) {
    console.error('orders:guest-details:error', error);
    throw error;
  }

  console.debug('orders:guest-details:ok', guestData.order_id);
}

// Get effective prices for client
export async function getEffectivePrices(clientId: string, productIds: string[]): Promise<EffectivePrice[]> {
  console.debug('orders:effective-prices:start', { clientId, productCount: productIds.length });
  
  if (productIds.length === 0) {
    return [];
  }

  const { data, error } = await supabase
    .from('v_effective_prices')
    .select('*')
    .eq('client_id', clientId)
    .in('product_id', productIds);

  if (error) {
    console.error('orders:effective-prices:error', error);
    throw error;
  }

  console.debug('orders:effective-prices:ok', data?.length || 0);
  return data || [];
}