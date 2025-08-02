import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('RUANG', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Text(
          'Berhasil Login sebagai: ${user.email}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
