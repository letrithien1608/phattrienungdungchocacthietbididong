class Product {
  final String id;
  final String productName;
  final double salePrice;
  final int quantity;
  final String? shortDescription;
  final String? productType;
  final String? image;
  final double? comparePrice;
  final String? favoriteSize;

  Product({
    required this.id,
    required this.productName,
    required this.salePrice,
    required this.quantity,
    this.shortDescription,
    this.productType,
    this.image,
    this.comparePrice,
    this.favoriteSize,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      productName: json['productName'] ?? 'Unknown Product',
      salePrice: (json['salePrice'] != null) ? (json['salePrice'] as num).toDouble() : 0.0,
      comparePrice: (json['comparePrice'] != null) ? (json['comparePrice'] as num).toDouble() : null,
      quantity: json['quantity'] ?? 0,
      shortDescription: json['shortDescription'],
      productType: json['productType'],
      image: json['image'],
      favoriteSize: json['favoriteSize'],
    );
  }
}
