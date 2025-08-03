import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/main/main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variabel untuk mengontrol animasi fade-in yang elegan
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Memberi jeda sesaat agar animasi fade-in terlihat
    Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // Navigasi otomatis setelah 1 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          // Menggunakan transisi fade agar perpindahan halaman lebih mulus
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainWrapper(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna cream dari tema Anda
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        // Dekorasi untuk efek cahaya dari kiri
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.9, 0.0), // Posisi cahaya di kiri
            radius: 1.5, // Radius cahaya agar terlihat lembut
            colors: [
              Colors.white.withAlpha(102), // Pusat cahaya yang lebih terang
              Theme.of(context)
                  .scaffoldBackgroundColor, // Memudar ke warna latar
            ],
          ),
        ),
        child: Center(
          // Animasi fade-in untuk logo
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            child: Container(
              // Memberi bayangan lembut agar logo terkesan sedikit terangkat
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logo RUANG.png', // Pastikan nama file ini benar
                width: 180,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
