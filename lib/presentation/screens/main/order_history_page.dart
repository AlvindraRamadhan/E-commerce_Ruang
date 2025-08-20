// Lokasi: presentation/screens/main/order_history_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/widgets/order_history_card.dart';
import 'package:ruang/services/order_service.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'profileOrderHistory')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService.getOrdersStreamForUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(AppStrings.get(locale, 'profileNoOrders')),
            );
          }

          final orders = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OrderModel.fromMap(data, documentId: doc.id);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderHistoryCard(
                order: orders[index],
                onTap: () {
                  // Aksi untuk Fase 6.3: Pindah ke halaman detail pesanan
                },
              );
            },
          );
        },
      ),
    );
  }
}
