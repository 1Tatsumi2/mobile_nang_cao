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

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'variationId': variationId,
    'productName': productName,
    'imageUrl': imageUrl,
    'quantity': quantity,
    'price': price,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'],
    variationId: json['variationId'],
    productName: json['productName'],
    imageUrl: json['imageUrl'],
    quantity: json['quantity'],
    price: (json['price'] as num).toDouble(),
  );
}