import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> shippingAddress;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String status; 
  final DateTime orderDate;
  final Map<String, dynamic> paymentDetails; 

  OrderModel({
    this.id,
    required this.userId,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.status,
    required this.orderDate,
    required this.paymentDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'shippingAddress': shippingAddress,
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'total': total,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),
      'paymentDetails': paymentDetails,
    };
  }
}