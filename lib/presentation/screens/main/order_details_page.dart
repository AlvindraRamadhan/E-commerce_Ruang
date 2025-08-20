// Lokasi: presentation/screens/main/order_details_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  int _getStatusStep(String status) {
    switch (status) {
      case 'processing':
        return 0;
      case 'shipped':
        return 1;
      case 'completed':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final currentStep = _getStatusStep(order.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'orderDetailsTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            title: AppStrings.get(locale, 'orderDetailsInfo'),
            children: [
              _buildInfoRow(AppStrings.get(locale, 'orderId'),
                  '#${order.paymentDetails["transactionId"]?.substring(0, 8) ?? order.id}'),
              _buildInfoRow(AppStrings.get(locale, 'orderDate'),
                  DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate)),
            ],
          ),
          const SizedBox(height: 16),
          Stepper(
            physics: const ClampingScrollPhysics(),
            currentStep: currentStep,
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            steps: [
              Step(
                title: Text(AppStrings.get(locale, 'stepOrderPlaced')),
                content: Text(AppStrings.get(locale, 'stepOrderPlacedDesc')),
                isActive: currentStep >= 0,
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text(AppStrings.get(locale, 'stepShipped')),
                content: Text(AppStrings.get(locale, 'stepShippedDesc')),
                isActive: currentStep >= 1,
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text(AppStrings.get(locale, 'stepCompleted')),
                content: Text(AppStrings.get(locale, 'stepCompletedDesc')),
                isActive: currentStep >= 2,
                state:
                    currentStep >= 2 ? StepState.complete : StepState.indexed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: AppStrings.get(locale, 'orderShippingAddress'),
            children: [
              Text(order.shippingAddress['fullName'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(order.shippingAddress['phoneNumber']),
              const SizedBox(height: 4),
              Text(
                  '${order.shippingAddress['address']}, ${order.shippingAddress['city']}, ${order.shippingAddress['province']} ${order.shippingAddress['postalCode']}'),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title:
                '${AppStrings.get(locale, 'orderProducts')} (${order.items.length})',
            children: [
              Column(
                children: order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['productName'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${item['quantity']} x ${currencyFormatter.format(item['price'])}'),
                            ],
                          ),
                        ),
                        Text(currencyFormatter
                            .format(item['quantity'] * item['price'])),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const Divider(height: 24),
              _buildPriceRow(context, AppStrings.get(locale, 'subtotal'),
                  currencyFormatter.format(order.subtotal)),
              _buildPriceRow(context, AppStrings.get(locale, 'shippingCost'),
                  currencyFormatter.format(order.shippingCost)),
              const SizedBox(height: 8),
              _buildPriceRow(context, AppStrings.get(locale, 'totalPayment'),
                  currencyFormatter.format(order.total),
                  isTotal: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    final theme = Theme.of(context);
    final style = TextStyle(
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      fontSize: isTotal ? 16 : 14,
      color: isTotal ? theme.colorScheme.primary : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
