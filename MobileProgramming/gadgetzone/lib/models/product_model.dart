class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String? description;
  final Map<String, String>? specifications;
  final bool isAvailable;
  final String category;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.description,
    this.specifications,
    this.isAvailable = true,
    required this.category,
    this.isFeatured = false,
  });
} 