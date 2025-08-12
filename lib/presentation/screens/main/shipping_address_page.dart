import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/address_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/main/add_address_page.dart';
import 'package:ruang/presentation/screens/main/checkout_summary_page.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  String? _selectedAddressId;
  bool _isFabAtRight = true;

  Stream<List<Address>> _getAddressesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Address.fromSnapshot(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar:
          AppBar(title: Text(AppStrings.get(locale, 'shippingAddressTitle'))),
      body: Stack(
        children: [
          StreamBuilder<List<Address>>(
            stream: _getAddressesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final addresses = snapshot.data!;
                if (addresses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.get(locale, 'noAddressYet')),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddAddressPage(),
                            ));
                          },
                          child: Text(
                              AppStrings.get(locale, 'addNewAddressButton')),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: RadioListTile<String>(
                              title: Text(address.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${address.address}, ${address.city}, ${address.province} ${address.postalCode}\nTel: ${address.phoneNumber}'),
                              value: address.id,
                              groupValue: _selectedAddressId,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAddressId = value;
                                });
                              },
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedAddressId == null
                              ? null
                              : () {
                                  final selectedAddressObject =
                                      addresses.firstWhere((addr) =>
                                          addr.id == _selectedAddressId);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CheckoutSummaryPage(
                                        selectedAddress: selectedAddressObject),
                                  ));
                                },
                          child: Text(AppStrings.get(
                              locale, 'continueToSummaryButton')),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return const Center(child: Text('Memuat alamat...'));
            },
          ),
          Positioned(
            right: _isFabAtRight ? 20 : null,
            left: _isFabAtRight ? null : 20,
            bottom: 100,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                if (details.offset.dx < screenSize.width / 2) {
                  setState(() => _isFabAtRight = false);
                } else {
                  setState(() => _isFabAtRight = true);
                }
              },
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddAddressPage(),
                  ));
                },
                tooltip: AppStrings.get(locale, 'addNewAddressButton'),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
