import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/address_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';

class CheckoutSummaryPage extends StatelessWidget {
  final Address selectedAddress;
  const CheckoutSummaryPage({super.key, required this.selectedAddress});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final cart = context.watch<CartProvider>();
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    const double shippingCost = 15000;
    final double totalPayment = cart.totalPrice + shippingCost;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get(locale, 'summaryTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
                context, AppStrings.get(locale, 'shippingAddressHeader')),
            _buildAddressCard(context, selectedAddress),
            const SizedBox(height: 24),
            _buildSectionHeader(
                context, AppStrings.get(locale, 'orderItemsHeader')),
            _buildItemsList(cart, currencyFormatter),
            const SizedBox(height: 24),
            _buildSectionHeader(
                context, AppStrings.get(locale, 'priceDetailsHeader')),
            _buildPriceDetails(
                context, cart, currencyFormatter, shippingCost, totalPayment),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Proses pembayaran akan diimplementasikan selanjutnya!')),
            );
          },
          child: Text(AppStrings.get(locale, 'proceedToPaymentButton')),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(address.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(address.phoneNumber),
            const SizedBox(height: 4),
            Text(
                '${address.address}, ${address.city}, ${address.province} ${address.postalCode}'),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(CartProvider cart, NumberFormat formatter) {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cart.items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return ListTile(
            leading: Image.network(item.product.imageUrl,
                width: 50, height: 50, fit: BoxFit.cover),
            title: Text(item.product.name),
            subtitle: Text(
                '${item.quantity} x ${formatter.format(item.product.price)}'),
            trailing: Text(formatter.format(item.subtotal),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }

  Widget _buildPriceDetails(BuildContext context, CartProvider cart,
      NumberFormat formatter, double shipping, double total) {
    final locale = context.read<LocaleProvider>().locale;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.get(locale, 'subtotal')),
                Text(formatter.format(cart.totalPrice)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.get(locale, 'shippingCost')),
                Text(formatter.format(shipping)),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.get(locale, 'totalPayment'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(formatter.format(total),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
