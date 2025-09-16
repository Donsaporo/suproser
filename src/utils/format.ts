export function formatPrice(price: number, currency: string = 'USD'): string {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(price);
}

export function formatPriceSimple(price: number): string {
  return new Intl.NumberFormat('es-CO').format(price);
}