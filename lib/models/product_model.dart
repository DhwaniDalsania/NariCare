class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category; // 'pads', 'tampons', 'cups', 'painRelief'
  final String emoji;
  final String brand;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.emoji,
    required this.brand,
  });
}

final List<Product> kProducts = [
  const Product(
    id: 'p1',
    name: 'Ultra-Thin Day Pads',
    description: 'Extra absorbent for light to medium flow. Breathable cover.',
    price: 89.0,
    category: 'pads',
    emoji: '🩹',
    brand: 'Stayfree',
  ),
  const Product(
    id: 'p2',
    name: 'Overnight Maxi Pads',
    description: 'Extra-long protection for overnight comfort. 360° leakage barrier.',
    price: 120.0,
    category: 'pads',
    emoji: '🌙',
    brand: 'Whisper',
  ),
  const Product(
    id: 'p3',
    name: 'Organic Cotton Pads',
    description: 'Chemical-free, soft organic cotton. Ideal for sensitive skin.',
    price: 199.0,
    category: 'pads',
    emoji: '🌿',
    brand: 'Carmesi',
  ),
  const Product(
    id: 't1',
    name: 'Regular Tampons (10 pack)',
    description: 'LeakGuard braid for built-in protection. Easy to use.',
    price: 149.0,
    category: 'tampons',
    emoji: '💧',
    brand: 'Tampax',
  ),
  const Product(
    id: 't2',
    name: 'Super Tampons (10 pack)',
    description: 'Extra protection for heavier flow days.',
    price: 175.0,
    category: 'tampons',
    emoji: '💦',
    brand: 'Tampax',
  ),
  const Product(
    id: 'c1',
    name: 'Menstrual Cup (S)',
    description: 'Reusable silicone cup. Lasts up to 12 hours. Eco-friendly.',
    price: 499.0,
    category: 'cups',
    emoji: '🥤',
    brand: 'Sirona',
  ),
  const Product(
    id: 'c2',
    name: 'Menstrual Cup (L)',
    description: 'For heavier flow. FDA-approved medical-grade silicone.',
    price: 549.0,
    category: 'cups',
    emoji: '🫙',
    brand: 'Pee Safe',
  ),
  const Product(
    id: 'r1',
    name: 'Period Pain Relief Patches',
    description: 'Instant relief from cramps. Heat-activated. 8 hours.',
    price: 249.0,
    category: 'painRelief',
    emoji: '🔥',
    brand: 'Sirona',
  ),
  const Product(
    id: 'r2',
    name: 'Meftal-Spas (10 tabs)',
    description: 'Effective anti-spasmodic for period cramp relief.',
    price: 85.0,
    category: 'painRelief',
    emoji: '💊',
    brand: 'Blue Cross',
  ),
  const Product(
    id: 'r3',
    name: 'Heating Pad',
    description: 'Reusable electric heating pad for abdominal cramps.',
    price: 699.0,
    category: 'painRelief',
    emoji: '🌡️',
    brand: 'Wellkang',
  ),
];
