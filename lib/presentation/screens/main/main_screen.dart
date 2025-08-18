import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/providers/main_screen_provider.dart';
import 'package:ruang/presentation/screens/main/cart_page.dart';
import 'package:ruang/presentation/screens/main/home_page.dart';
import 'package:ruang/presentation/screens/main/profile_page.dart';
import 'package:ruang/presentation/screens/main/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = context.watch<MainScreenProvider>();
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      body: PageView(
        controller: mainScreenProvider.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mainScreenProvider.currentPage,
        onTap: (index) {
          context.read<MainScreenProvider>().setPage(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: AppStrings.get(locale, 'navHome'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            activeIcon: const Icon(Icons.search),
            label: AppStrings.get(locale, 'navSearch'),
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Badge(
                  label: Text(cart.totalUniqueItems.toString()),
                  isLabelVisible: cart.items.isNotEmpty,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            activeIcon: const Icon(Icons.shopping_cart),
            label: AppStrings.get(locale, 'navCart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppStrings.get(locale, 'navProfile'),
          ),
        ],
      ),
    );
  }
}