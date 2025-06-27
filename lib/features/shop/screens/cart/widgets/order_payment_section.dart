import 'package:flutter/material.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/cart_item.dart';
import 'package:do_an_mobile/services/checkout_service.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/services/cart_service.dart';
import 'package:do_an_mobile/services/coupon_service.dart';

class OrderPaymentSection extends StatefulWidget {
  final List<CartItem> cartItems;
  final double shipping;
  final bool isShippingSubmitted;
  final ShippingAddressData? shippingAddress;
  
  const OrderPaymentSection({
    super.key, 
    required this.cartItems, 
    required this.shipping,
    required this.isShippingSubmitted,
    this.shippingAddress,
  });

  @override
  State<OrderPaymentSection> createState() => _OrderPaymentSectionState();
}

class _OrderPaymentSectionState extends State<OrderPaymentSection> {
  String selectedPayment = 'stripe';
  final TextEditingController couponController = TextEditingController();
  bool isViewDetailsExpanded = false;
  
  // Biến cho coupon và membership discount
  double couponDiscount = 0.0;
  double membershipDiscount = 0.0;
  String appliedCouponCode = '';
  int appliedCouponId = 0;
  bool isApplyingCoupon = false;

  double get subtotal => widget.cartItems.fold<double>(0, (sum, item) => sum + item.price * item.quantity);
  double get totalDiscount => couponDiscount + membershipDiscount;
  double get estimatedTotal => subtotal - totalDiscount + (widget.shipping > 0 ? widget.shipping : 0);

  bool get canCheckout => widget.isShippingSubmitted && widget.shippingAddress != null;

  @override
  void initState() {
    super.initState();
    _loadUserDiscountInfo();
  }

  // 🔹 SỬA LẠI: Tải thông tin giảm giá membership của user
  Future<void> _loadUserDiscountInfo() async {
    try {
      final userEmail = await AuthService.getCurrentUserEmail();
      if (userEmail != null) {
        // 🔹 SỬA: SỬ DỤNG METHOD MỚI TRONG AuthService
        final discountRate = await AuthService.getCurrentUserDiscountRate();
        final points = await AuthService.getCurrentUserPoints();
        final tier = await AuthService.getCurrentUserMembershipTier();
        
        setState(() {
          membershipDiscount = subtotal * discountRate;
        });
        
        print('User Email: $userEmail');
        print('Points: $points');
        print('Membership Tier: $tier');
        print('Membership discount rate: ${discountRate * 100}%');
        print('Membership discount amount: \$${membershipDiscount.toStringAsFixed(2)}');
      }
    } catch (e) {
      print('Error loading user discount info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 16),

          // COUPON CODE SECTION
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  enabled: !isApplyingCoupon && appliedCouponCode.isEmpty,
                  decoration: InputDecoration(
                    hintText: appliedCouponCode.isNotEmpty 
                      ? 'Applied: $appliedCouponCode'
                      : 'Enter Coupon Code',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (appliedCouponCode.isEmpty)
                ElevatedButton(
                  onPressed: isApplyingCoupon ? null : _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: isApplyingCoupon 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Apply'),
                )
              else
                ElevatedButton(
                  onPressed: _removeCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Remove'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // MEMBERSHIP DISCOUNT
          if (membershipDiscount > 0) ...[
            _buildSummaryRow(
              'Membership Discount',
              '- \$${membershipDiscount.toStringAsFixed(0)}',
              color: Colors.green,
            ),
            const SizedBox(height: 8),
          ],

          // COUPON DISCOUNT
          if (couponDiscount > 0) ...[
            _buildSummaryRow(
              'Coupon Discount',
              '- \$${couponDiscount.toStringAsFixed(0)}',
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
          ],

          // Shipping
          if (widget.shipping > 0) ...[
            _buildSummaryRow('Shipping', '\$${widget.shipping.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
          ],

          const Divider(),
          _buildSummaryRow(
            'Estimated Total',
            '\$${estimatedTotal.toStringAsFixed(0)}',
            isTotal: true,
          ),
          const SizedBox(height: 20),
          
          // VIEW DETAILS Section
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
                    '\$${widget.shipping.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Estimated Tax', '\$0'),
                  const SizedBox(height: 8),
                  // 🔹 SỬA: THAY ĐỔI TỪ discount THÀNH totalDiscount
                  if (totalDiscount > 0) ...[
                    _buildDetailRow(
                      'Total Discount Applied',
                      '- \$${totalDiscount.toStringAsFixed(0)}',
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

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: canCheckout ? _handleCheckout : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canCheckout ? Colors.black : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: Text(
                canCheckout ? 'Checkout' : 'Complete Shipping Information First',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          
          // Warning message
          if (!canCheckout) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      !widget.isShippingSubmitted 
                        ? 'Please submit your shipping information first!'
                        : 'Shipping information is incomplete!',
                      style: TextStyle(
                        color: Colors.red.shade700, 
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _handleCheckout() async {
    if (widget.shippingAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter shipping information first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final userEmail = await AuthService.getCurrentUserEmail();
      
      final isLoggedIn = await AuthService.isLoggedIn();
      if (!isLoggedIn || userEmail == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to continue checkout'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final cartItemsData = widget.cartItems.map((item) => CartItemData(
        productId: item.productId,
        variationId: item.variationId ?? 0,
        productName: item.productName,
        price: item.price,
        quantity: item.quantity,
        imageUrl: item.imageUrl,
      )).toList();

      // 🔹 SỬA: TRUYỀN couponDiscount THAY VÌ discount VÀ THÊM couponCode
      final request = CheckoutRequest(
        paymentMethod: selectedPayment,
        userEmail: userEmail,
        cartItems: cartItemsData,
        shippingPrice: widget.shipping,
        discountAmount: couponDiscount, // Chỉ truyền coupon discount
        shippingAddress: widget.shippingAddress!,
        couponCode: appliedCouponCode, // Truyền coupon code
      );

      final result = await CheckoutService.processCheckout(request);

      Navigator.pop(context);

      if (result['success'] == true) {
        final data = result['data'];
        final redirectUrl = data['redirectUrl'];
        final paymentMethod = data['paymentMethod'];
        final orderCode = data['orderCode'];
        final savedAddress = data['shippingAddress'];
        final membershipDiscountFromAPI = data['membershipDiscount'] ?? 0.0;
        final couponDiscountFromAPI = data['couponDiscount'] ?? 0.0;
        final totalDiscountFromAPI = data['totalDiscount'] ?? 0.0;

        print('Order created successfully!');
        print('Membership discount: \$${membershipDiscountFromAPI}');
        print('Coupon discount: \$${couponDiscountFromAPI}');
        print('Total discount: \$${totalDiscountFromAPI}');
        print('Shipping address saved: $savedAddress');

        if (paymentMethod.toLowerCase() == 'cod') {
          await _clearCartAndShowSuccess(orderCode);
        } else {
          await CheckoutService.launchPaymentUrl(redirectUrl);
          await CartService.clearCart();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Payment opened in browser. Order Code: $orderCode'),
              backgroundColor: Colors.blue,
            ),
          );
          
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checkout failed: ${result['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearCartAndShowSuccess(String orderCode) async {
    await CartService.clearCart();
    _showOrderConfirmation(orderCode);
  }

  void _showOrderConfirmation(String orderCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text('Order Code: $orderCode'),
            const SizedBox(height: 8),
            const Text('You will receive a confirmation email shortly.'),
            // 🔹 THÊM HIỂN THỊ DISCOUNT INFO
            if (membershipDiscount > 0 || couponDiscount > 0) ...[
              const SizedBox(height: 8),
              Text('Total Discount Applied: \$${totalDiscount.toStringAsFixed(2)}'),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  // Apply coupon method
  Future<void> _applyCoupon() async {
    // 🔹 KIỂM TRA USER ĐĂNG NHẬP
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to apply coupon'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (couponController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a coupon code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isApplyingCoupon = true;
    });

    try {
      print('🔹 STARTING APPLY COUPON');
      print('Coupon Code: ${couponController.text.trim()}');
      print('Subtotal: $subtotal');
      
      final result = await CouponService.applyCoupon(
        couponController.text.trim(),
        subtotal,
      );

      print('🔹 COUPON SERVICE RESULT: $result');

      if (result['success'] == true) {
        final data = result['data'];
        print('🔹 COUPON DATA: $data');
        
        setState(() {
          couponDiscount = (data['discountAmount'] as num).toDouble();
          appliedCouponCode = data['couponCode'];
          appliedCouponId = data['couponId'] ?? 0; // 🔹 LƯU COUPON ID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Coupon applied successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('🔹 COUPON ERROR: ${result['error']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to apply coupon'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('🔹 COUPON EXCEPTION: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isApplyingCoupon = false;
      });
    }
  }

  // Remove coupon method
  Future<void> _removeCoupon() async {
    try {
      final result = await CouponService.removeCoupon();

      if (result['success'] == true) {
        setState(() {
          couponDiscount = 0.0;
          appliedCouponCode = '';
          appliedCouponId = 0; // 🔹 RESET COUPON ID
          couponController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Coupon removed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing coupon: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isTotal ? Colors.black : Colors.grey[700]),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? (isTotal ? Colors.black : Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }
}
