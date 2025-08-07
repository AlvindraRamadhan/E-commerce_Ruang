import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/auth/auth_page.dart'; 
import 'package:ruang/presentation/screens/main/main_screen.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan loading jika koneksi masih menunggu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Jika sudah login, arahkan ke MainScreen (Beranda)
        if (snapshot.hasData) {
          return const MainScreen();
        }
        // Jika belum login, arahkan ke AuthPage (Login/Register)
        else {
          return const AuthPage();
        }
      },
    );
  }
}
