import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Flag untuk memastikan precache hanya berjalan sekali
  bool _isImagePrecached = false;

  @override
  void initState() {
    super.initState();
    // Navigasi otomatis setelah 3 detik. Logika ini tetap di sini.
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // PERBAIKAN: Pindahkan precaching ke sini.
    // Kode ini akan memuat gambar untuk halaman login/register di latar belakang
    // agar transisinya mulus dan tidak flicker.
    if (!_isImagePrecached) {
      precacheImage(const AssetImage("assets/images/background.jpg"), context);
      _isImagePrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kode untuk UI tetap sama, tidak perlu diubah.
    // Kita hanya memindahkan logika, bukan tampilan.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                Image.asset('assets/images/logo RUANG.png', width: 180),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
