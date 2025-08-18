import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _productCollection =
      _db.collection('products');

  static Stream<QuerySnapshot> getProductsStream({String? category}) {
    Query query = _productCollection;
    if (category != null && category != 'All') {
      query = query.where('translations.en.category', isEqualTo: category);
    }
    return query.snapshots();
  }

  static Stream<QuerySnapshot> searchProductsStream({
    List<String>? categories,
  }) {
    Query query = _productCollection;

    if (categories != null && categories.isNotEmpty) {
      query = query.where('translations.en.category', whereIn: categories);
    }

    return query.snapshots();
  }
}
