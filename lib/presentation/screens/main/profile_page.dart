import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/order_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/auth/auth_page.dart';
import 'package:ruang/presentation/screens/main/address_list_page.dart';
import 'package:ruang/presentation/screens/main/order_history_page.dart';
import 'package:ruang/presentation/widgets/order_history_card.dart';
import 'package:ruang/services/order_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  void _showLogoutDialog(BuildContext context) {
    final locale = context.read<LocaleProvider>().locale;
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(AppStrings.get(locale, 'logoutConfirmTitle')),
          content: Text(AppStrings.get(locale, 'logoutConfirmDesc')),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.get(locale, 'cancel')),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppStrings.get(locale, 'logout')),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final dialogNavigator = Navigator.of(ctx);
                await FirebaseAuth.instance.signOut();
                dialogNavigator.pop();
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'profileTitle')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: user == null
          ? Center(child: Text(AppStrings.get(locale, 'noUser')))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                _buildUserHeader(context, locale),
                const SizedBox(height: 24),
                _buildSection(
                  context: context,
                  title: "Akun Saya",
                  children: [
                    _buildProfileTile(
                      context,
                      icon: Icons.location_on_outlined,
                      title: "Alamat Pengiriman",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressListPage()));
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildProfileTile(
                      context,
                      icon: Icons.shield_outlined,
                      title: "Keamanan Akun",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader(
                        context, AppStrings.get(locale, 'profileOrderHistory')),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderHistoryPage()));
                        },
                        child: const Text("Lihat Semua")),
                  ],
                ),
                _buildOrderHistoryPreview(),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: () => _showLogoutDialog(context),
                  child: Text(AppStrings.get(locale, 'logout')),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildUserHeader(BuildContext context, Locale locale) {
    return Row(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            user!.email?.substring(0, 1).toUpperCase() ?? 'U',
            style: TextStyle(
                fontSize: 28,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user!.displayName ??
                    AppStrings.get(locale, 'profileUnnamedUser'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(user!.email ?? ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
      {required BuildContext context,
      required String title,
      required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, title),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildOrderHistoryPreview() {
    return StreamBuilder<QuerySnapshot>(
      stream: OrderService.getOrdersStreamForUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300)),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                AppStrings.get(
                    context.watch<LocaleProvider>().locale, 'profileNoOrders'),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final allOrders = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return OrderModel.fromMap(data, documentId: doc.id);
        }).toList();

        final recentOrders = allOrders.take(2).toList();

        return Column(
          children: [
            ...recentOrders.map((order) {
              return OrderHistoryCard(order: order);
            }),
          ],
        );
      },
    );
  }
}
