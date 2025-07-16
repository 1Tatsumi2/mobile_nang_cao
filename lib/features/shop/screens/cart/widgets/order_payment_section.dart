import 'package:flutter/material.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/cart_item.dart';
import 'package:do_an_mobile/services/checkout_service.dart';
import 'package:do_an_mobile/features/shop/screens/cart/models/checkout_request.dart';
import 'package:do_an_mobile/services/auth_service.dart';
import 'package:do_an_mobile/services/cart_service.dart';
import 'package:do_an_mobile/services/coupon_service.dart';
import 'package:get/get.dart';
import 'package:do_an_mobile/controllers/cart_controller.dart';

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

      final request = CheckoutRequest(
        paymentMethod: selectedPayment,
        userEmail: userEmail,
        cartItems: cartItemsData,
        shippingPrice: widget.shipping,
        discountAmount: couponDiscount,
        shippingAddress: widget.shippingAddress!,
        couponCode: appliedCouponCode,
      );

      final result = await CheckoutService.processCheckout(request);

      Navigator.pop(context); // Đóng loading dialog

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
        print('Membership discount: \$$membershipDiscountFromAPI');
        print('Coupon discount: \$$couponDiscountFromAPI');
        print('Total discount: \$$totalDiscountFromAPI');
        print('Shipping address saved: $savedAddress');

        // 🔹 XÓA CART VÀ CẬP NHẬT CART CONTROLLER NGAY LẬP TỨC
        try {
          final cartController = Get.find<CartController>();
          await cartController.clearCartAndUpdate();
          print('✅ Cart cleared and updated');
        } catch (e) {
          print('❌ Error clearing cart: $e');
        }

        // 🔹 XỬ LÝ THEO PAYMENT METHOD
        if (paymentMethod.toLowerCase() == 'cod') {
          // 🔹 COD: HIỂN THỊ SUCCESS DIALOG
          _showSuccessDialog(context, orderCode, paymentMethod, null);
        } else {
          // 🔹 STRIPE/PAYPAL: TỰ ĐỘNG MỞ TRANG THANH TOÁN
          if (redirectUrl != null && redirectUrl.isNotEmpty) {
            try {
              print('🔗 Auto-opening payment URL: $redirectUrl');
              await CheckoutService.launchPaymentUrl(redirectUrl);
              
              // 🔹 HIỂN THỊ THÔNG BÁO NGẮN VÀ QUAY VỀ TRANG CHỦ
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order $orderCode created! Opening payment page...'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
              
              // 🔹 QUAY VỀ TRANG CHỦ SAU KHI MỞ PAYMENT
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.popUntil(context, (route) => route.isFirst);
              });
              
            } catch (e) {
              print('❌ Error launching payment URL: $e');
              
              // 🔹 NẾU KHÔNG MỞ ĐƯỢC PAYMENT URL, HIỂN THỊ DIALOG VỚI NÚT MANUAL
              _showPaymentErrorDialog(context, orderCode, redirectUrl, e.toString());
            }
          } else {
            // 🔹 KHÔNG CÓ REDIRECT URL
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment URL not available'),
                backgroundColor: Colors.red,
              ),
            );
          }
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

  // 🔹 DIALOG CHO TRƯỜNG HỢP LỖI MỞ PAYMENT URL
  void _showPaymentErrorDialog(BuildContext context, String orderCode, String paymentUrl, String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 30),
            SizedBox(width: 12),
            Text('Payment Page Error'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Code: $orderCode',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Your order was created successfully, but we couldn\'t automatically open the payment page.'),
              const SizedBox(height: 8),
              Text('Error: $error'),
            ],
          ),
        ),
        actions: [
          // 🔹 NÚT MỞ PAYMENT MANUAL
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await CheckoutService.launchPaymentUrl(paymentUrl);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Still cannot open payment: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Payment Again'),
          ),
          
          // 🔹 NÚT VỀ TRANG CHỦ
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  // 🔹 SỬA SUCCESS DIALOG CHỈ DÀNH CHO COD
  void _showSuccessDialog(BuildContext context, String orderCode, String paymentMethod, String? redirectUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 12),
            Text('Order Placed Successfully!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Code: $orderCode',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Payment Method: ${_getPaymentMethodName(paymentMethod)}'),
              const SizedBox(height: 8),
              const Text('You will receive a confirmation email shortly.'),
              
              // 🔹 HIỂN THỊ DISCOUNT INFO
              if (membershipDiscount > 0 || couponDiscount > 0) ...[
                const SizedBox(height: 12),
                const Divider(),
                const Text(
                  'Discounts Applied:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (membershipDiscount > 0)
                  Text('Membership Discount: -\$${membershipDiscount.toStringAsFixed(2)}'),
                if (couponDiscount > 0)
                  Text('Coupon Discount: -\$${couponDiscount.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text(
                  'Total Discount: -\$${totalDiscount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
              
              // 🔹 HIỂN THỊ TOTAL
              const SizedBox(height: 12),
              const Divider(),
              Text(
                'Total: \$${estimatedTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              
              // 🔹 THÔNG BÁO CHO COD
              if (paymentMethod.toLowerCase() == 'cod') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You will pay cash when the order is delivered.',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          // 🔹 CHỈ CÓ NÚT CONTINUE SHOPPING CHO COD
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
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

  // 🔹 HELPER METHOD ĐỂ HIỂN THỊ TÊN PAYMENT METHOD
  String _getPaymentMethodName(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'stripe':
        return 'Credit Card (Stripe)';
      case 'paypal':
        return 'PayPal';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return paymentMethod;
    }
  }

  // 🔹 THÊM CÁC HELPER METHODS BỊ THIẾU
  Widget _buildSummaryRow(String label, String value, {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // 🔹 APPLY COUPON METHOD
  Future<void> _applyCoupon() async {
    final couponCode = couponController.text.trim();
    if (couponCode.isEmpty) {
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
      final userEmail = await AuthService.getCurrentUserEmail();
      if (userEmail == null) {
        throw Exception('User not logged in');
      }

      final result = await CouponService.applyCoupon(couponCode, subtotal);
      
      if (result['success']) {
        setState(() {
          couponDiscount = result['discountAmount'].toDouble();
          appliedCouponCode = couponCode;
          appliedCouponId = result['couponId'] ?? 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon applied! Discount: \$${couponDiscount.toStringAsFixed(2)}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error'] ?? 'Failed to apply coupon'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
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

  // 🔹 REMOVE COUPON METHOD
  void _removeCoupon() {
    setState(() {
      couponDiscount = 0.0;
      appliedCouponCode = '';
      appliedCouponId = 0;
      couponController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coupon removed'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }
}