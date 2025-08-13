import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:http/http.dart' as http;
import 'package:ruang/data/models/address_model.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';

class PaymentService {
  static final String _serverKey = dotenv.env['MIDTRANS_SERVER_KEY']!;
  static const _sandboxSnapUrl =
      'https://app.sandbox.midtrans.com/snap/v1/transactions';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_serverKey:'))}',
      };

  static Future<String?> createTransactionToken(
    CartProvider cart,
    Address address,
    double shippingCost,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final double totalPayment = cart.totalPrice + shippingCost;
    final transactionDetails = {
      'order_id': 'RUANG-${DateTime.now().millisecondsSinceEpoch}',
      'gross_amount': totalPayment.toInt(),
    };

    final itemDetails = cart.items.map((item) {
      return {
        'id': item.product.id,
        'price': item.product.price.toInt(),
        'quantity': item.quantity,
        'name': item.product.name,
      };
    }).toList();

    itemDetails.add({
      'id': 'SHIPPING_COST',
      'price': shippingCost.toInt(),
      'quantity': 1,
      'name': 'Ongkos Kirim',
    });

    final customerDetails = {
      'first_name': address.fullName.split(' ').first,
      'last_name': address.fullName.split(' ').length > 1
          ? address.fullName.split(' ').last
          : '',
      'email': user.email,
      'phone': address.phoneNumber,
      'shipping_address': {
        'first_name': address.fullName.split(' ').first,
        'last_name': address.fullName.split(' ').length > 1
            ? address.fullName.split(' ').last
            : '',
        'address': address.address,
        'city': address.city,
        'postal_code': address.postalCode,
        'phone': address.phoneNumber,
      }
    };

    final requestBody = {
      'transaction_details': transactionDetails,
      'item_details': itemDetails,
      'customer_details': customerDetails,
    };

    try {
      final response = await http.post(
        Uri.parse(_sandboxSnapUrl),
        headers: _headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final String transactionToken = responseBody['token'];
        log('Transaction Token: $transactionToken');
        return transactionToken;
      } else {
        log('Failed to create transaction: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error creating transaction: $e');
      return null;
    }
  }
}
