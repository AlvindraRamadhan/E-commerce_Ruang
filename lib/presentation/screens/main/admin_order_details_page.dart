// Lokasi: presentation/screens/main/admin_order_details_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/services/order_service.dart';

class AdminOrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  const AdminOrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final adminEmail = FirebaseAuth.instance.currentUser?.email ?? 'Admin';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pesanan Admin")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: "Informasi Pesanan",
            children: [
              _buildInfoRow(
                  "ID Pesanan", '#${order.id?.substring(0, 8) ?? 'N/A'}'),
              _buildInfoRow("Tanggal Pesan",
                  DateFormat('d MMMM yyyy, HH:mm').format(order.orderDate)),
              _buildInfoRow("Email Pemesan",
                  order.shippingAddress['email'] ?? 'Tidak diketahui'),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: "Alamat Pengiriman",
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
            title: 'Produk Dipesan (${order.items.length})',
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
              _buildPriceRow(context, "Subtotal",
                  currencyFormatter.format(order.subtotal)),
              _buildPriceRow(context, "Ongkos Kirim",
                  currencyFormatter.format(order.shippingCost)),
              const SizedBox(height: 8),
              _buildPriceRow(
                  context, "Total", currencyFormatter.format(order.total),
                  isTotal: true),
            ],
          ),
          Card(
            color: Colors.amber.shade50,
            margin: const EdgeInsets.only(top: 24),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Panel Kontrol Admin",
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text("Status Saat Ini: ${order.status.toUpperCase()}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (order.processedBy != null)
                    Text("Diproses oleh: ${order.processedBy}"),
                  const Divider(height: 24),
                  if (order.status == 'processing')
                    ElevatedButton.icon(
                      icon: const Icon(Icons.local_shipping_outlined),
                      label: const Text("Tandai Telah Dikirim"),
                      onPressed: () async {
                        await OrderService.updateOrderStatus(
                            order.id!, 'shipped', adminEmail);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  if (order.status == 'shipped')
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text("Tandai Telah Selesai"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        await OrderService.updateOrderStatus(
                            order.id!, 'completed', adminEmail);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  if (order.status == 'completed')
                    const Text("Pesanan ini telah selesai.",
                        textAlign: TextAlign.center),
                ],
              ),
            ),
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
