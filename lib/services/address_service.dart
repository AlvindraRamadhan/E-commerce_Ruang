import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruang/data/models/address_model.dart';

class AddressService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static CollectionReference? _getAddressCollection() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return _db.collection('users').doc(user.uid).collection('addresses');
  }

  static Future<List<Address>> getAddressesForUser() async {
    final addressCollection = _getAddressCollection();
    if (addressCollection == null) return [];

    try {
      final snapshot = await addressCollection.get();
      return snapshot.docs
          .map((doc) =>
              Address.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      developer.log("Error getting addresses: $e");
      return [];
    }
  }
}
