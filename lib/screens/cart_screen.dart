import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _orderSuccess = false;

  void _proceedToCheckout() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    // VALIDATION: Ensure cart is not empty
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty! Add some items first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // NAVIGATION: Navigate to checkout screen
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const CheckoutScreen())
    );

    // SUCCESS HANDLING: If order was placed, show success state locally
    if (result == true) {
      if (mounted) {
        setState(() {
          _orderSuccess = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = Provider.of<CartProvider>(context);

    if (_orderSuccess) return _buildSuccessState(l);

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.yourCart, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: cart.items.isEmpty
          ? _buildEmptyState(l)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items.values.toList()[i];
                      return _CartItemTile(
                        item: item,
                        onAdd: () => cart.addToCart(kProducts.firstWhere((p) => p.id == item.id)),
                        onRemove: () => cart.removeOne(item.id),
                        onDelete: () => cart.removeItem(item.id),
                        l: l,
                      );
                    },
                  ),
                ),
                _buildTotalsFooter(l, cart),
              ],
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.05), shape: BoxShape.circle),
            child: const Text('🛒', style: TextStyle(fontSize: 80)),
          ),
          const SizedBox(height: 24),
          Text(l.emptyCart, style: const TextStyle(color: AppTheme.primary, fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text('Your wellness kit is waiting.', style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.5))),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            child: Text(l.continueShopping, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsFooter(AppLocalizations l, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primary)),
                Text('₹${cart.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: AppTheme.primary)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(l.proceedToCheckout, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(AppLocalizations l) {
    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              Text(l.orderPlaced, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.primary)),
              const SizedBox(height: 16),
              Text(l.orderSuccess, textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.6), fontSize: 16, height: 1.5)),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.continueShopping),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;
  final AppLocalizations l;

  const _CartItemTile({required this.item, required this.onAdd, required this.onRemove, required this.onDelete, required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppTheme.accentPink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primary, fontSize: 15)),
                const SizedBox(height: 4),
                Text('₹${item.price.toStringAsFixed(0)}', style: TextStyle(color: AppTheme.primary.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20)),
              Container(
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _QtyBtn(icon: Icons.remove, onTap: onRemove),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primary)),
                    ),
                    _QtyBtn(icon: Icons.add, onTap: onAdd, isPrimary: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  const _QtyBtn({required this.icon, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: isPrimary ? AppTheme.primary : Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16, color: isPrimary ? Colors.white : AppTheme.primary),
      ),
    );
  }
}

