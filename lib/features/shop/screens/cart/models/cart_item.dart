class CartItem {
  final int productId;
  final int? variationId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double price;

  CartItem({
    required this.productId,
    this.variationId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variationId': variationId,
      'productName': productName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? 0,
      variationId: json['variationId'],
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, variationId: $variationId, name: $productName, qty: $quantity, price: \$${price.toStringAsFixed(2)})';
  }
}