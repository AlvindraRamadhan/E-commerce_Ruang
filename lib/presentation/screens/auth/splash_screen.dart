// Lokasi: presentation/screens/auth/splash_screen.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/auth/auth_page.dart';
import 'package:ruang/presentation/screens/auth/language_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimationAndNavigate();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    // Selama kita masih dalam tahap pengembangan (debug mode),
    // kita paksa 'onboardingComplete' menjadi false agar selalu
    // menampilkan alur perkenalan.
    if (kDebugMode) {
      onboardingComplete = false;
    }

    Widget destinationPage;
    if (onboardingComplete) {
      // Jika sudah selesai onboarding, langsung ke gerbang pengecekan login
      destinationPage = const AuthPage();
    } else {
      // Jika belum, mulai dari alur perkenalan
      destinationPage = const LanguageSelectionScreen();
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => destinationPage,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    }
  }

  void _startAnimationAndNavigate() {
    // Mulai animasi
    Timer(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _logoOpacity = 1.0);
    });
    Timer(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _textOpacity = 1.0);
    });

    // Setelah animasi selesai, jalankan logika navigasi
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.9, -0.5),
            radius: 1.5,
            colors: [
              Colors.white.withAlpha(128),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _logoOpacity,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo RUANG.png',
                    width: 180,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedOpacity(
                opacity: _textOpacity,
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                child: Text(
                  'RUANG',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 32,
                        letterSpacing: 2,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
