import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ruang/presentation/screens/main/main_wrapper.dart';

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
    _startAnimation();
  }

  void _startAnimation() {
    const totalDuration = Duration(seconds: 3);

    Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _logoOpacity = 1.0;
        });
      }
    });

    Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _textOpacity = 1.0;
        });
      }
    });

    Future.delayed(totalDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainWrapper(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
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
