// Lokasi: services/order_service.dart

import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruang/data/models/order_model.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _orderCollection = _db.collection('orders');

  static Future<void> createOrder(OrderModel order) async {
    try {
      await _orderCollection.add(order.toMap());
    } catch (e) {
      developer.log('Error creating order: $e');
      rethrow;
    }
  }

  static Stream<QuerySnapshot> getOrdersStreamForUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // PERBAIKAN: Menambahkan 'const'
      return const Stream.empty();
    }

    try {
      return _orderCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('orderDate', descending: true)
          .snapshots();
    } catch (e) {
      developer.log("Error getting orders stream for user: $e");
      // PERBAIKAN: Menambahkan 'const'
      return const Stream.empty();
    }
  }
}
