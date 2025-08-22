import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/widgets/order_history_card.dart';
import 'package:ruang/services/order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _statuses = ['processing', 'shipped', 'completed'];
  final List<String> _tabTitleKeys = [
    'orderStatusProcessing',
    'orderStatusShipped',
    'orderStatusCompleted'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitleKeys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'profileOrderHistory')),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabTitleKeys
              .map((key) => Tab(text: AppStrings.get(locale, key)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statuses.map((status) {
          return _buildOrderList(locale, status: status);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderList(Locale locale, {String? status}) {
    return StreamBuilder<QuerySnapshot>(
      stream: OrderService.getOrdersStreamForUser(status: status),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(AppStrings.get(locale, 'noOrdersWithStatus')),
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
            return OrderHistoryCard(order: orders[index]);
          },
        );
      },
    );
  }
}
