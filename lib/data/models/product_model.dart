import 'package:flutter/widgets.dart';

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

  factory Product.fromFirestore(
      Map<String, dynamic> data, String documentId, Locale locale) {
    final langCode = locale.languageCode; // 'en' atau 'id'

    final translations = data['translations'] as Map<String, dynamic>? ?? {};

    // Ambil data terjemahan sesuai langCode.
    // Jika tidak ada, gunakan 'en' sebagai fallback.
    // Jika 'en' juga tidak ada, gunakan map kosong.
    final localizedData = translations[langCode] as Map<String, dynamic>? ??
        translations['en'] as Map<String, dynamic>? ??
        {};

    return Product(
      id: documentId,
      name: localizedData['name'] ?? '',
      description: localizedData['description'] ?? '',
      category: localizedData['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
    );
  }
}
