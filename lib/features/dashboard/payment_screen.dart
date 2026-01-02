import 'package:flutter/material.dart';
import 'package:bodh_flutter/models/cart.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'eSewa';

  @override
  Widget build(BuildContext context) {
    final CartItem item = Cart.items.first; // Assuming single-item checkout
    final double bookPrice = item.price * item.quantity;
    const double deliveryFee = 50;
    final double total = bookPrice + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/ikigai.jpg', // 🔁 Replace with your actual path
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Order summary
            Text('Book: ${item.title}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('Price: NPR ${bookPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            const Text('Delivery: NPR 50', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            Text('Total: NPR ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),

            // Payment method section
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // eSewa option
            RadioListTile(
              value: 'eSewa',
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() => selectedMethod = value!);
              },
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/esewa.png', // 🔁 Replace with your actual path
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('eSewa'),
                ],
              ),
            ),

            // Khalti option
            RadioListTile(
              value: 'Khalti',
              groupValue: selectedMethod,
              onChanged: (value) {
                setState(() => selectedMethod = value!);
              },
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/khalti.png', // 🔁 Replace with your actual path
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text('Khalti'),
                ],
              ),
            ),

            const Spacer(),

            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Payment method "$selectedMethod" selected. Proceeding...'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
