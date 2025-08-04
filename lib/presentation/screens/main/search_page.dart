import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pencarian')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/error_animation.json', width: 250),
            const SizedBox(height: 24),
            Text('Fitur Ini Sedang Dikembangkan',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Nantikan pembaruan selanjutnya!',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
