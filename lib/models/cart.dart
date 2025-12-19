import 'book.dart';

/// Represents a single item in the cart
class CartItem {
  final String title;
  final String image;
  final double price; // NPR
  final int quantity;

  const CartItem({
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    String? title,
    String? image,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Shared cart manager
class Cart {
  static final List<CartItem> items = [];

  /// Add a book to the cart
  static void add(Book book, {double price = 500}) {
    final index = items.indexWhere((item) => item.title == book.title);
    if (index != -1) {
      // Increase quantity if already in cart
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
    } else {
      // Add new item
      items.add(CartItem(
        title: book.title,
        image: book.image,
        price: price,
        quantity: 1,
      ));
    }
  }

  /// Remove a book completely
  static void remove(CartItem item) {
    items.remove(item);
  }

  /// Clear all items
  static void clear() {
    items.clear();
  }

  /// Calculate total price
  static double get total {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
