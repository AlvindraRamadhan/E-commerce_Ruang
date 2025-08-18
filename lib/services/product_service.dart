// Lokasi: services/product_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _productCollection =
      _db.collection('products');

  /// Mengambil stream produk dengan filter satu kategori.
  /// Digunakan di HomePage. (Ini sudah benar)
  static Stream<QuerySnapshot> getProductsStream({String? category}) {
    Query query = _productCollection;
    if (category != null && category != 'All') {
      query = query.where('translations.en.category', isEqualTo: category);
    }
    return query.snapshots();
  }

  /// PERBAIKAN: Ini adalah fungsi yang hilang yang dibutuhkan oleh SearchPage.
  /// Mengambil stream produk dengan filter multi-kategori.
  static Stream<QuerySnapshot> searchProductsStream({
    List<String>? categories,
  }) {
    Query query = _productCollection;

    // Filter berdasarkan beberapa kategori, jika dipilih.
    if (categories != null && categories.isNotEmpty) {
      query = query.where('translations.en.category', whereIn: categories);
    }

    return query.snapshots();
  }
}
