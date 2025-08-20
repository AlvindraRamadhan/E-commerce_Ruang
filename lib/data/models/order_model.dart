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

  factory OrderModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      shippingAddress: Map<String, dynamic>.from(map['shippingAddress'] ?? {}),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      shippingCost: (map['shippingCost'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: map['status'] ?? 'unknown',
      orderDate: (map['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      paymentDetails: Map<String, dynamic>.from(map['paymentDetails'] ?? {}),
    );
  }
}
