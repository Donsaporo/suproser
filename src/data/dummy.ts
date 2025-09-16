import { Product, Category, Promotion, Video } from '../types';

export const categories: Category[] = [
  { id: '1', name: 'Hogar', slug: 'hogar' },
  { id: '2', name: 'Hospitales y Clínicas', slug: 'hospitales-clinicas' },
  { id: '3', name: 'Cocinas y Restaurantes', slug: 'cocinas-restaurantes' },
  { id: '4', name: 'Escuelas/Gimnasios', slug: 'escuelas-gimnasios' },
  { id: '5', name: 'Oficinas', slug: 'oficinas' },
  { id: '6', name: 'Industria', slug: 'industria' },
];

export const products: Product[] = [
  {
    id: '1',
    slug: 'detergente-multiusos-profesional',
    name: 'Detergente Multiusos Profesional',
    description: 'Detergente concentrado ideal para limpieza general en espacios comerciales y residenciales. Fórmula biodegradable y de alta efectividad.',
    price: 25000,
    unit: 'Galón',
    image: 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800',
    images: [
      'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/5591581/pexels-photo-5591581.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/8129903/pexels-photo-8129903.jpeg?auto=compress&cs=tinysrgb&w=800'
    ],
    category: 'hogar',
    featured: true
  },
  {
    id: '2',
    slug: 'desinfectante-hospitalario',
    name: 'Desinfectante Hospitalario',
    description: 'Desinfectante de grado hospitalario, elimina 99.9% de bacterias y virus. Ideal para centros de salud y espacios que requieren alta desinfección.',
    price: 35000,
    unit: 'Litro',
    image: 'https://images.pexels.com/photos/5729023/pexels-photo-5729023.jpeg?auto=compress&cs=tinysrgb&w=800',
    images: [
      'https://images.pexels.com/photos/5729023/pexels-photo-5729023.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/4164703/pexels-photo-4164703.jpeg?auto=compress&cs=tinysrgb&w=800'
    ],
    category: 'hospitales-clinicas',
    featured: true
  },
  {
    id: '3',
    slug: 'desengrasante-cocina-industrial',
    name: 'Desengrasante Cocina Industrial',
    description: 'Potente desengrasante formulado especialmente para cocinas comerciales. Remueve grasa carbonizada y residuos difíciles.',
    price: 28000,
    unit: 'Galón',
    image: 'https://images.pexels.com/photos/4207707/pexels-photo-4207707.jpeg?auto=compress&cs=tinysrgb&w=800',
    images: [
      'https://images.pexels.com/photos/4207707/pexels-photo-4207707.jpeg?auto=compress&cs=tinysrgb&w=800'
    ],
    category: 'cocinas-restaurantes'
  },
  {
    id: '4',
    slug: 'limpiador-pisos-deportivos',
    name: 'Limpiador Pisos Deportivos',
    description: 'Limpiador especializado para pisos de gimnasios y centros deportivos. No deja residuos y mantiene la adherencia.',
    price: 22000,
    unit: 'Galón',
    image: 'https://images.pexels.com/photos/6256090/pexels-photo-6256090.jpeg?auto=compress&cs=tinysrgb&w=800',
    images: [
      'https://images.pexels.com/photos/6256090/pexels-photo-6256090.jpeg?auto=compress&cs=tinysrgb&w=800'
    ],
    category: 'escuelas-gimnasios',
    featured: true
  }
];

export const promotions: Promotion[] = [
  {
    id: '1',
    title: 'Detergente Multiusos - Oferta Especial',
    image: 'https://images.pexels.com/photos/4099354/pexels-photo-4099354.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 20000,
    originalPrice: 25000,
    productSlug: 'detergente-multiusos-profesional'
  },
  {
    id: '2',
    title: 'Desinfectante Hospitalario - Pack x2',
    image: 'https://images.pexels.com/photos/5729023/pexels-photo-5729023.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 60000,
    originalPrice: 70000,
    productSlug: 'desinfectante-hospitalario'
  },
  {
    id: '3',
    title: 'Combo Limpieza Cocina',
    image: 'https://images.pexels.com/photos/4207707/pexels-photo-4207707.jpeg?auto=compress&cs=tinysrgb&w=600',
    price: 45000,
    originalPrice: 55000,
    productSlug: 'desengrasante-cocina-industrial'
  }
];

export const videos: Video[] = [
  {
    id: '1',
    title: 'Técnicas de Limpieza Profesional',
    description: 'Aprende las mejores técnicas para usar nuestros productos de limpieza profesional',
    url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail: 'https://images.pexels.com/photos/4239013/pexels-photo-4239013.jpeg?auto=compress&cs=tinysrgb&w=600'
  },
  {
    id: '2',
    title: 'Desinfección en Centros de Salud',
    description: 'Protocolos de desinfección recomendados para hospitales y clínicas',
    url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail: 'https://images.pexels.com/photos/3825578/pexels-photo-3825578.jpeg?auto=compress&cs=tinysrgb&w=600'
  },
  {
    id: '3',
    title: 'Limpieza Industrial en Cocinas',
    description: 'Cómo mantener la higiene en cocinas comerciales con nuestros productos',
    url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail: 'https://images.pexels.com/photos/2291367/pexels-photo-2291367.jpeg?auto=compress&cs=tinysrgb&w=600'
  },
  {
    id: '4',
    title: 'Mantenimiento de Espacios Deportivos',
    description: 'Guía completa para el cuidado de gimnasios y centros deportivos',
    url: 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    thumbnail: 'https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=600'
  }
];

export const benefits = [
  {
    icon: 'Truck',
    title: 'Entrega a Domicilio y Envíos en Panamá',
    description: 'Entregas a domicilio GRATIS en la Ciudad de Panamá con compras mayores de $50. Compras menores a $49.99 tendrá un cargo de $3.99'
  },
  {
    icon: 'Shield',
    title: 'Certificación BPM',
    description: 'Suproser. Fabrica de productos de limpieza y desinfección con Certificación de Buenas Prácticas de Manufactura y Registros Sanitarios otorgados por el Departamento de Farmacias y Drogas'
  },
  {
    icon: 'Headphones',
    title: 'SERVICIO AL CLIENTE',
    description: 'Asesoría Profesional y ventas +507 6349-9962'
  },
  {
    icon: 'CreditCard',
    title: 'Haga su pedido hoy',
    description: 'Yappy / Efectivo / ACH / Tarjetas de Crédito y Débito'
  }
];