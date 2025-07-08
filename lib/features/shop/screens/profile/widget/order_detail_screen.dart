import 'package:flutter/material.dart';
import 'package:do_an_mobile/services/order_service.dart';
import 'package:do_an_mobile/features/shop/screens/cart/widgets/order_tracking_screen.dart';
import 'package:do_an_mobile/navigation_menu.dart';
import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderCode;

  const OrderDetailScreen({super.key, required this.orderCode});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? orderData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await OrderService.getOrderDetails(widget.orderCode);
      setState(() {
        orderData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Error loading order details: $e');
    }
  }

  Future<void> _cancelOrder() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });

      final success = await OrderService.cancelOrder(widget.orderCode);
      
      if (success) {
        _showSuccessSnackBar('Order canceled successfully');
        await _loadOrderDetails();
      } else {
        _showErrorSnackBar('Failed to cancel order');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelivery() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delivery'),
        content: const Text('Have you received your order? Confirming delivery will mark this order as completed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not Yet'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Yes, Received'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });

      final success = await OrderService.confirmDelivery(widget.orderCode);
      
      if (success) {
        _showSuccessSnackBar('Order confirmed as received');
        await _loadOrderDetails();
      } else {
        _showErrorSnackBar('Failed to confirm delivery');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new order':
        return Colors.blue;
      case 'confirmed':
        return Colors.orange;
      case 'in transit':
        return TColors.warning;
      case 'delivered':
        return Colors.green;
      case 'completed':
        return Colors.teal;
      case 'cancelled':
        return Colors.red;
      default:
        return TColors.textSecondary;
    }
  }

  Widget _buildOrderItem({
    required String image,
    required String name,
    required String variant,
    required double originalPrice,   // 🔹 THÊM giá gốc
    required double finalPrice,      // 🔹 Giá sau giảm
    required int quantity,
    required double discountAmount,  // 🔹 THÊM discount amount
  }) {
    final hasDiscount = discountAmount > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TColors.light,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.dark.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'http://localhost:5139/media/variations/$image',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: TColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: TColors.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: TSizes.fontSizeMd,
                    color: TColors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  variant,
                  style: const TextStyle(
                    fontSize: TSizes.fontSizeSm,
                    color: TColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // 🔹 HIỂN THỊ GIÁ GIỐNG WEB
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasDiscount) ...[
                          // Giá gốc (gạch ngang)
                          Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: TSizes.fontSizeSm,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Giá sau giảm (màu xanh, đậm)
                          Text(
                            '\$${finalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else ...[
                          // Không có giảm giá - hiển thị giá bình thường
                          Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      'Quantity: $quantity',
                      style: const TextStyle(
                        color: TColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: TSizes.fontSizeMd,
              color: TColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: TSizes.fontSizeMd,
                fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
                color: isPrimary ? TColors.primary : TColors.dark,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: TColors.light,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (orderData == null) {
      return Scaffold(
        backgroundColor: TColors.light,
        appBar: AppBar(
          title: const Text('Order Details'),
          backgroundColor: TColors.primary,
          foregroundColor: TColors.light,
        ),
        body: const Center(
          child: Text('Order not found'),
        ),
      );
    }

    final order = orderData!['order'];
    final orderDetails = orderData!['orderDetails'] as List;
    final status = order['statusName'] as String;
    final statusColor = _getStatusColor(status);

    // 🔹 Lấy thông tin địa chỉ giao hàng
    final shippingAddress = order['address'] as String? ?? 'N/A';
    final addressParts = shippingAddress.split(',').map((e) => e.trim()).toList();
    final recipientName = addressParts.isNotEmpty ? addressParts[0] : 'N/A';
    final phoneNumber = addressParts.length > 1 ? addressParts[1] : 'N/A';
    final fullAddress = addressParts.length > 2 
        ? addressParts.sublist(2).join(', ') 
        : 'N/A';

    // 🔹 Lấy thông tin payment method
    final paymentMethod = order['paymentMethod'] as String? ?? 'Cash on Delivery';
    IconData paymentIcon = Icons.money;
    String paymentDisplay = paymentMethod;
    String cardNumber = '';
    
    if (paymentMethod.contains('Stripe')) {
      paymentIcon = Icons.credit_card;
      paymentDisplay = 'Stripe';
      cardNumber = '**** **** **** 4242';
    } else if (paymentMethod.contains('PayPal')) {
      paymentIcon = Icons.payment;
      paymentDisplay = 'PayPal';
    }

    return Scaffold(
      backgroundColor: TColors.light,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: TColors.dark,
            foregroundColor: TColors.light,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: TColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const FlexibleSpaceBar(
                title: Text(
                  'Order Details',
                  style: TextStyle(
                    color: TColors.light,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: _loadOrderDetails,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 ORDER HEADER
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TColors.light,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.dark.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order #${order['orderCode']}",
                                style: const TextStyle(
                                  fontSize: TSizes.fontSizeLg,
                                  fontWeight: FontWeight.bold,
                                  color: TColors.dark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Ordered on ${_formatDate(order['createdDate'])}",
                            style: const TextStyle(
                              color: TColors.dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 🔹 ITEMS HEADER
                    const Text(
                      "Items",
                      style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: TColors.dark,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 🔹 ORDER ITEMS từ API
                    ...orderDetails.map((item) {
  final originalPrice = (item['price'] as double?) ?? 0.0;
  final discountPerItem = ((item['discountAmount'] as double?) ?? 0.0) / ((item['quantity'] as int?) ?? 1);
  final finalPrice = originalPrice - discountPerItem;
  
  return _buildOrderItem(
    image: item['imageUrl'] ?? '',
    name: item['productName'] ?? 'Unknown Product',
    variant: 'Color: ${item['color']} | Material: ${item['material']} | Size: ${item['size']}',
    originalPrice: originalPrice,
    finalPrice: finalPrice,
    quantity: item['quantity'] as int? ?? 0,
    discountAmount: discountPerItem,
  );
}),
                    
                    const SizedBox(height: 24),
                    
                    // 🔹 ORDER SUMMARY
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TColors.light,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.dark.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: TSizes.fontSizeLg,
                              fontWeight: FontWeight.bold,
                              color: TColors.dark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem("Subtotal", '\$${(order['productTotal'] as double).toStringAsFixed(2)}'),
                          _buildDetailItem('Shipping', '\$${(order['shippingCost'] as double).toStringAsFixed(2)}'),
                          const Divider(height: 24),
                          _buildDetailItem('Total', '\$${(order['grandTotal'] as double).toStringAsFixed(2)}', isPrimary: true),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 🔹 SHIPPING DETAILS
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TColors.light,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.dark.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shipping Details",
                            style: TextStyle(
                              fontSize: TSizes.fontSizeLg,
                              fontWeight: FontWeight.bold,
                              color: TColors.dark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailItem('Name', recipientName),
                          _buildDetailItem('Phone', phoneNumber),
                          _buildDetailItem('Address', fullAddress),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 🔹 PAYMENT METHOD
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TColors.light,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: TColors.dark.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: TSizes.fontSizeLg,
                              fontWeight: FontWeight.bold,
                              color: TColors.dark,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: TColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  paymentIcon,
                                  color: TColors.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      paymentDisplay,
                                      style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd,
                                        color: TColors.dark,
                                      ),
                                    ),
                                    if (cardNumber.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        cardNumber,
                                        style: const TextStyle(
                                          color: TColors.dark,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TColors.light,
          boxShadow: [
            BoxShadow(
              color: TColors.dark.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 MAIN BUTTONS
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      text: "Tracking Order", 
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const OrderTrackingScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: "Home", 
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const NavigationMenu()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              // 🔹 ACTION BUTTONS (Cancel/Confirm)
              if (order['canCancel'] == true || order['status'] == 4) ...[
                const SizedBox(height: 12),
                
                if (order['canCancel'] == true)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Order'),
                      onPressed: _cancelOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                
                if (order['status'] == 4) // Delivered
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Received'),
                      onPressed: _confirmDelivery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}