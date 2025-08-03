class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final num price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  // Factory method untuk membuat instance Product dari data Firestore
  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
    );
  }
}
