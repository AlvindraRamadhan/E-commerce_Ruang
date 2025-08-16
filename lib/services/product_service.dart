import 'dart:developer';
import 'package:flutter/material.dart'; // <-- Tambahkan import ini
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruang/data/models/product_model.dart';

class ProductService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _productCollection =
      _db.collection('products');

  // UBAH DARI String locale MENJADI Locale locale
  static Future<List<Product>> searchProducts(
      String query, Locale locale) async {
    if (query.isEmpty) {
      return [];
    }

    String capitalizedQuery = query[0].toUpperCase() + query.substring(1);

    try {
      final snapshot = await _productCollection
          .where('name.en', isGreaterThanOrEqualTo: capitalizedQuery)
          .where('name.en', isLessThanOrEqualTo: '$capitalizedQuery\uf8ff')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // SEKARANG TIPE DATA 'locale' SUDAH BENAR (Locale)
        return Product.fromFirestore(data, doc.id, locale);
      }).toList();
    } catch (e) {
      log("Error searching products: $e");
      return [];
    }
  }
}
