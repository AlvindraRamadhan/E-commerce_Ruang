import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/address_model.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/main/order_success_page.dart';
import 'package:ruang/services/order_service.dart';
import 'package:ruang/services/payment_service.dart';
import 'package:ruang/services/web_payment_service.dart' as web_payment;
import 'dart:js_interop';

class CheckoutSummaryPage extends StatefulWidget {
  final Address selectedAddress;
  const CheckoutSummaryPage({super.key, required this.selectedAddress});

  @override
  State<CheckoutSummaryPage> createState() => _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
  bool _isLoading = false;
  MidtransSDK? _midtransSDK;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initMidtransSDK();
    }
  }

  void _initMidtransSDK() async {
    _midtransSDK = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dotenv.env['MIDTRANS_CLIENT_KEY']!,
        merchantBaseUrl: "",
      ),
    );
    _midtransSDK?.setTransactionFinishedCallback((result) {
      _handleTransactionResult(result);
    });
  }

  void _handleTransactionResult(TransactionResult result) {
    final status = result.status;

    if (status == 'settlement') {
      _onPaymentSuccess(result.transactionId ?? 'N/A', result.paymentType);
    } else if (status == 'pending') {
      _onPaymentPending(result.transactionId ?? 'N/A');
    } else {
      _onPaymentError('Pembayaran Gagal atau Dibatalkan (Status: $status)');
    }
  }

  void _onPaymentSuccess(String transactionId, String? paymentMethod) {
    log("Pembayaran Sukses! Transaction ID: $transactionId");
    _createOrderAndNavigate(transactionId, paymentMethod);
  }

  void _onPaymentPending(String transactionId) {
    log("Pembayaran Pending. Transaction ID: $transactionId");
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pembayaran Anda sedang diproses.'),
        backgroundColor: Colors.orange));
  }

  void _onPaymentError(String errorMessage) {
    log("Pembayaran Gagal. Error: $errorMessage");
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pembayaran Gagal: $errorMessage'),
        backgroundColor: Colors.red));
  }

  Future<void> _createOrderAndNavigate(
      String transactionId, String? paymentMethod) async {
    final cart = context.read<CartProvider>();
    final user = FirebaseAuth.instance.currentUser;
    const double shippingCost = 15000;
    if (user == null) return;

    final newOrder = OrderModel(
      userId: user.uid,
      items: cart.items
          .map((cartItem) => {
                'productId': cartItem.product.id,
                'productName': cartItem.product.name,
                'quantity': cartItem.quantity,
                'price': cartItem.product.price,
              })
          .toList(),
      shippingAddress: widget.selectedAddress.toMap(),
      subtotal: cart.totalPrice.toDouble(),
      shippingCost: shippingCost,
      total: (cart.totalPrice + shippingCost).toDouble(),
      status: 'processing',
      orderDate: DateTime.now(),
      paymentDetails: {
        'transactionId': transactionId,
        'paymentMethod': paymentMethod ?? 'N/A'
      },
    );

    try {
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      await OrderService.createOrder(newOrder);
      cart.clearCart();

      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Pembayaran Berhasil! Pesanan dibuat.'),
          backgroundColor: Colors.green));

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      log("Gagal membuat pesanan: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan pesanan: $e'),
          backgroundColor: Colors.red));
    }
  }

  Future<void> _processPayment() async {
    setState(() => _isLoading = true);
    final cart = context.read<CartProvider>();
    const double shippingCost = 15000;

    if (!mounted) return;
    final token = await PaymentService.createTransactionToken(
        cart, widget.selectedAddress, shippingCost);

    if (!mounted) return;
    if (token == null) {
      _onPaymentError('Gagal mendapatkan token transaksi.');
      setState(() => _isLoading = false);
      return;
    }

    if (kIsWeb) {
      web_payment.pay(
          token,
          web_payment.PayOptions(
            onSuccess: (JSObject result) {
              final jsResult = result as web_payment.TransactionResult;
              _onPaymentSuccess(
                  jsResult.transactionId.toDart, jsResult.paymentType.toDart);
            }.toJS,
            onPending: (JSObject result) {
              final jsResult = result as web_payment.TransactionResult;
              _onPaymentPending(jsResult.transactionId.toDart);
            }.toJS,
            onError: (JSObject result) {
              final jsResult = result as web_payment.TransactionResult;
              _onPaymentError(jsResult.statusMessage.toDart);
            }.toJS,
          ).jsify());
    } else {
      _midtransSDK?.startPaymentUiFlow(token: token);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _midtransSDK?.removeTransactionFinishedCallback();
    super.dispose();
  }

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
            _buildAddressCard(context, widget.selectedAddress),
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
          onPressed: _isLoading ? null : _processPayment,
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white))
              : Text(AppStrings.get(locale, 'proceedToPaymentButton')),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppStrings.get(locale, 'subtotal')),
              Text(formatter.format(cart.totalPrice))
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppStrings.get(locale, 'shippingCost')),
              Text(formatter.format(shipping))
            ]),
            const Divider(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(AppStrings.get(locale, 'totalPayment'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(formatter.format(total),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary)),
            ]),
          ],
        ),
      ),
    );
  }
}
