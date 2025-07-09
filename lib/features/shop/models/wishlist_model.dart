class WishlistItem {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final String? image;

  WishlistItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.image,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'WishlistItem(id: $id, productId: $productId, productName: $productName, price: $price)';
  }
}
