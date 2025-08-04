import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ruang/presentation/screens/main/cart_page.dart';
import 'package:ruang/presentation/screens/main/home_page.dart';
import 'package:ruang/presentation/screens/main/profile_page.dart';
import 'package:ruang/presentation/screens/main/search_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  bool _isInitialLoading = true;
  bool _isPageSwitching = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    });
  }

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index || _isPageSwitching) return;

    setState(() {
      _isPageSwitching = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _selectedIndex = index;
          _isPageSwitching = false;
        });
      }
    });
  }

  Widget _buildBody() {
    if (_isPageSwitching) {
      return Center(
          child:
              Lottie.asset('assets/images/loading_animation.json', width: 150));
    }
    return Skeletonizer(
      enabled: _isInitialLoading,
      effect: ShimmerEffect(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.green.shade100,
      ),
      child: _pages.elementAt(_selectedIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Pencarian',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
