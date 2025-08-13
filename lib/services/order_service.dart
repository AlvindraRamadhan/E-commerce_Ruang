import 'dart:developer'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ruang/data/models/order_model.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createOrder(OrderModel order) async {
    try {
      await _db.collection('orders').add(order.toMap());
    } catch (e) {
      log('Error creating order: $e'); 
      rethrow;
    }
  }
}
