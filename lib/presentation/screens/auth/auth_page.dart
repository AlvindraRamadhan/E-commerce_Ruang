import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/main/admin_dashboard_page.dart';
import 'package:ruang/presentation/screens/auth/login_or_register_page.dart';
import 'package:ruang/presentation/screens/main/main_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const String adminEmail = "admin@ruang.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            if (snapshot.data!.email == adminEmail) {
              return const AdminDashboardPage();
            } else {
              return const MainScreen();
            }
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
