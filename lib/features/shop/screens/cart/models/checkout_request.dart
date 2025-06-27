class CheckoutRequest {
  final String paymentMethod;
  final String? userEmail;
  final List<CartItemData> cartItems;
  final double shippingPrice;
  final double discountAmount; // Coupon discount
  final ShippingAddressData shippingAddress;
  final String couponCode; // 🔹 THÊM COUPON CODE

  CheckoutRequest({
    required this.paymentMethod,
    this.userEmail,
    required this.cartItems,
    required this.shippingPrice,
    required this.discountAmount,
    required this.shippingAddress,
    required this.couponCode, // 🔹 THÊM PARAMETER
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'userEmail': userEmail,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
      'shippingPrice': shippingPrice,
      'discountAmount': discountAmount,
      'shippingAddress': shippingAddress.toJson(),
      'couponCode': couponCode, // 🔹 THÊM VÀO JSON
    };
  }
}

class CartItemData {
  final int productId;
  final int variationId;
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItemData({
    required this.productId,
    required this.variationId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variationId': variationId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

// 🔹 THÊM CLASS ĐỊA CHỈ
class ShippingAddressData {
  final String city;
  final String district;
  final String ward;
  final String detailAddress;

  ShippingAddressData({
    required this.city,
    required this.district,
    required this.ward,
    required this.detailAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'district': district,
      'ward': ward,
      'detailAddress': detailAddress,
    };
  }

  String getFullAddress() {
    return '$detailAddress, $ward, $district, $city';
  }
}