abstract class PaymentService {
  Future<String> processPayment({
    required String orderCode,
    required List<Map<String, dynamic>> cartItems,
    required double shippingPrice,
    required double discountAmount,
    required String paymentMethod,
    String? userEmail,
  });
}