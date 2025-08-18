import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  int _currentPage = 0;
  PageController pageController = PageController();

  int get currentPage => _currentPage;

  void setPage(int page) {
    if (_currentPage == page) return;
    _currentPage = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
}
