export interface Product {
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
  effectivePrice?: number;
}

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
}

export interface Promotion {
  id: string;
  title: string;
  image: string;
  price: number;
  originalPrice?: number;
  productSlug: string;
}

export interface Video {
  id: string;
  title: string;
  description: string;
  url: string;
  thumbnail: string;
}