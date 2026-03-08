import 'package:bodh_flutter/core/api/api_endpoints.dart';
import 'package:bodh_flutter/features/dashboard/presentation/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:bodh_flutter/features/dashboard/models/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increaseQuantity(int index) {
    setState(() {
      Cart.items[index] = Cart.items[index].copyWith(
        quantity: Cart.items[index].quantity + 1,
      );
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (Cart.items[index].quantity > 1) {
        Cart.items[index] = Cart.items[index].copyWith(
          quantity: Cart.items[index].quantity - 1,
        );
      } else {
        Cart.remove(Cart.items[index]);
      }
    });
  }

  void _removeBook(int index) {
    setState(() {
      Cart.remove(Cart.items[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double total = Cart.total;
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final isTablet = screenWidth >= 700;
    final maxContentWidth = isTablet ? 760.0 : 560.0;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: Cart.items.isEmpty
                      ? const Center(
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(horizontalPadding),
                          itemCount: Cart.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = Cart.items[index];
                            return CartItemCard(
                              item: item,
                              isTablet: isTablet,
                              onIncrease: () => _increaseQuantity(index),
                              onDecrease: () => _decreaseQuantity(index),
                              onDelete: () => _removeBook(index),
                            );
                          },
                        ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    14,
                    horizontalPadding,
                    media.padding.bottom > 0 ? media.padding.bottom + 8 : 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x11000000),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'NPR ${total.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Cart.items.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Your cart is empty!'),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;
  final bool isTablet;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
    required this.isTablet,
  });

  String _resolveImage(String image) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    if (image.startsWith('/')) {
      return '${ApiEndpoints.baseUrl}$image';
    }
    return image;
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.menu_book_outlined,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCartImage(double width, double height) {
    if (item.image.isEmpty) {
      return _buildPlaceholder(width, height);
    }

    final isNetworkImage = item.image.startsWith('/') ||
        item.image.startsWith('http://') ||
        item.image.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        _resolveImage(item.image),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildPlaceholder(width, height);
        },
      );
    }

    return Image.asset(
      item.image,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildPlaceholder(width, height);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = isTablet ? 72.0 : 60.0;
    final imageHeight = isTablet ? 96.0 : 80.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildCartImage(imageWidth, imageHeight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NPR ${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 2,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: onDecrease,
                    ),
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}