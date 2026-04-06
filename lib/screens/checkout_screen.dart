import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isOrdering = false;

  Future<void> _completeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Ensure cart isn't empty (redundant check for safety)
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty. Redirecting...')),
      );
      Navigator.pop(context);
      return;
    }

    setState(() => _isOrdering = true);

    try {
      final firestore = FirestoreService();
      bool success = false;
      
      // OPTION 1: Authenticated User (Firestore)
      if (auth.isAuthenticated && auth.user != null) {
        try {
          await firestore.placeOrder(auth.user!.id, {
            'items': cart.toOrderItems(),
            'total': cart.totalPrice,
          });
          success = true;
        } catch (e) {
          debugPrint('Checkout Firestore Error: $e');
          success = false;
        }
      } 
      // OPTION 2: Guest/Demo User (Mock)
      else {
        await Future.delayed(const Duration(seconds: 2));
        success = true;
      }


      if (success) {
        if (mounted) {
          // CRITICAL: Clear cart ONLY after successful order
          cart.clearCart();
          
          // Show success message and pop with 'true' to signal success to CartScreen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to place order. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Checkout General Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isOrdering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: Text(l.checkout, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            _buildSectionHeader(l.checkoutSummary, Icons.shopping_bag_outlined),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  ...cart.items.values.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(color: AppTheme.accentPink.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 18))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text('${item.quantity}x ${item.name}', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13))),
                        Text('₹${(item.price * item.quantity).toStringAsFixed(0)}', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Shipping & Payment
            Row(
              children: [
                Expanded(child: _buildInfoCard(l.shippingAddress, user?.name ?? l.guest, '123 Health Ave,\nNaricare Zone,\n380001')),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard(l.paymentMethod, l.cashOnDelivery, 'Pay at your doorstep', icon: Icons.payments_outlined)),
              ],
            ),
            const SizedBox(height: 32),

            // Totals
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                   _buildTotalRow(l.subtotal, '₹${cart.totalPrice.toStringAsFixed(0)}'),
                   const SizedBox(height: 10),
                   _buildTotalRow(l.shipping, l.free),
                   const Divider(height: 32, thickness: 1),
                   _buildTotalRow(l.total, '₹${cart.totalPrice.toStringAsFixed(0)}', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: _isOrdering ? null : _completeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  shadowColor: AppTheme.primary.withValues(alpha: 0.3),
                ),
                child: _isOrdering 
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                  : Text(l.placeOrder, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 22),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.primary)),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, String content, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.primary)),
        const SizedBox(height: 12),
        Container(
          height: 110,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.primary.withValues(alpha: 0.05))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppTheme.primary, size: 24),
                const SizedBox(height: 8),
              ],
              Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primary)),
              const SizedBox(height: 4),
              Text(content, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(
          color: AppTheme.primary, 
          fontSize: isBold ? 20 : 15, 
          fontWeight: isBold ? FontWeight.w900 : FontWeight.bold
        )),
        Text(value, style: TextStyle(
          color: AppTheme.primary, 
          fontSize: isBold ? 28 : 15, 
          fontWeight: isBold ? FontWeight.w900 : FontWeight.bold
        )),
      ],
    );
  }
}
