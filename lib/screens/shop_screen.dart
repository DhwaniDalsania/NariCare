import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = Provider.of<CartProvider>(context);

    final categories = [
      {'key': 'all', 'label': l.allProducts},
      {'key': 'pads', 'label': l.pads},
      {'key': 'tampons', 'label': l.tampons},
      {'key': 'cups', 'label': l.cups},
      {'key': 'painRelief', 'label': l.painRelief},
    ];

    final filtered = _selectedCategory == 'all'
        ? kProducts
        : kProducts.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.emergencyKit, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppTheme.primary),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    child: Text('${cart.totalItems}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = _selectedCategory == cat['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat['key']!),
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: isSelected ? AppTheme.primary : Colors.grey.shade200),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Product Grid
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Adjust crossAxisCount and childAspectRatio based on screen width
                int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                double aspectRatio = constraints.maxWidth > 400 ? 0.72 : 0.68;
                
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _ProductCard(product: filtered[i], l: l),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final AppLocalizations l;

  const _ProductCard({required this.product, required this.l});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final inCart = cart.contains(product.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji banner
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.accentPink.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 36))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand, 
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name, 
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.primary, height: 1.2), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}', 
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primary)
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: inCart
                        ? _CartCounterWidget(product: product)
                        : ElevatedButton(
                            onPressed: () => cart.addToCart(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(l.addToCart, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartCounterWidget extends StatelessWidget {
  final Product product;
  const _CartCounterWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final qty = cart.getQuantity(product.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => cart.removeOne(product.id),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppTheme.accentPink.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.remove, color: AppTheme.primary, size: 14),
          ),
        ),
        Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primary, fontSize: 14)),
        GestureDetector(
          onTap: () => cart.addToCart(product),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.add, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }
}
