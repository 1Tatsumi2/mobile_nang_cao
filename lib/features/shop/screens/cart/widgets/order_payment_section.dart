import 'package:flutter/material.dart';

class OrderPaymentSection extends StatefulWidget {
  const OrderPaymentSection({super.key});

  @override
  State<OrderPaymentSection> createState() => _OrderPaymentSectionState();
}

class _OrderPaymentSectionState extends State<OrderPaymentSection> {
  String selectedPayment = 'stripe';
  final TextEditingController couponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isShippingComplete = false;
  bool isViewDetailsExpanded = false;
  double subtotal = 920.0;
  double discount = 0.0;
  double shipping = 0.0;

  double get estimatedTotal => subtotal - discount + shipping;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ORDER SUMMARY SECTION
        const Text(
          'ORDER SUMMARY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        // Subtotal
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(fontSize: 16)),
            Text(
              '\$${subtotal.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Coupon Code Section
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: couponController,
                decoration: const InputDecoration(
                  hintText: 'Enter Coupon Code',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                // Apply coupon logic here
                setState(() {
                  if (couponController.text.isNotEmpty) {
                    discount = 50.0; // Example discount
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Discount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount (${discount > 0 ? "${(discount / subtotal * 100).toStringAsFixed(0)}%" : "0%"})',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '- \$${discount.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Shipping
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shipping', style: TextStyle(fontSize: 16)),
            Text(
              '\$${shipping.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),

        const Divider(thickness: 1),
        const SizedBox(height: 16),

        // Estimated Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Estimated Total',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '\$${estimatedTotal.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 20), // VIEW DETAILS Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: InkWell(
            onTap: () {
              setState(() {
                isViewDetailsExpanded = !isViewDetailsExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'VIEW DETAILS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  isViewDetailsExpanded ? Icons.remove : Icons.add,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Expandable Details Section
        if (isViewDetailsExpanded) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  'Item Subtotal',
                  '\$${subtotal.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Shipping & Handling',
                  '\$${shipping.toStringAsFixed(0)}',
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Estimated Tax', '\$0'),
                const SizedBox(height: 8),
                if (discount > 0) ...[
                  _buildDetailRow(
                    'Discount Applied',
                    '- \$${discount.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                ],
                const Divider(),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Order Total',
                  '\$${estimatedTotal.toStringAsFixed(0)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Disclaimer Text
        const Text(
          'You will be charged at the time of shipment. If this is a personalized or made-to-order purchase, you will be charged at the time of purchase.',
          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
        ),

        const SizedBox(height: 32),

        // PAYMENT METHOD SECTION
        const Text(
          'Select Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),

        // Payment Options
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'stripe',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
                title: const Text('Pay with Stripe'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'paypal',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
                title: const Text('Pay with PayPal'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'cod',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
                title: const Text('Pay with COD (Cash on Delivery)'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Email Input
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Enter your email',
            hintText: 'example@email.com',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              // Giả sử shipping information đã hoàn thành nếu email không rỗng
              // Trong thực tế, bạn sẽ kiểm tra từ widget shipping information
              isShippingComplete = value.isNotEmpty;
            });
          },
        ),
        const SizedBox(height: 24), // Checkout Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              // Handle checkout
              _handleCheckout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: Text(
              'Checkout',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ), // Warning message
        if (!isShippingComplete || emailController.text.isEmpty) ...[
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Please enter your shipping information first!',
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  void _handleCheckout() {
    // Implement checkout logic here
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Checkout Confirmation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total: \$${estimatedTotal.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Payment Method: ${selectedPayment.toUpperCase()}'),
                if (emailController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Email: ${emailController.text}'),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Process the actual checkout here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order placed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    couponController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
