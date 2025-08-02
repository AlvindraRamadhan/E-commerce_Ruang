import 'dart:ui';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  void _toggleCard() {
    _cardKey.currentState?.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang Gambar
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Efek Frost
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withAlpha(26)),
          ),
          // Kartu yang bisa dibalik
          Center(
            child: FlipCard(
              key: _cardKey,
              flipOnTouch: false,
              // PERBAIKAN: Menambahkan properti untuk animasi lebih smooth
              speed: 600, // Durasi animasi dalam milidetik
              front: LoginForm(onFlip: _toggleCard),
              back: RegisterForm(onFlip: _toggleCard),
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET UNTUK FORM LOGIN
class LoginForm extends StatefulWidget {
  final VoidCallback onFlip;
  const LoginForm({super.key, required this.onFlip});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message.toString())));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Selamat Datang',
      fields: [
        AuthTextField(controller: _emailController, labelText: 'Email'),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Password',
          obscureText: true,
        ),
      ],
      primaryButtonText: 'Masuk',
      onPrimaryButtonPressed: signIn,
      secondaryText: 'Belum punya akun? ',
      secondaryButtonText: 'Daftar sekarang',
      onSecondaryButtonPressed: widget.onFlip,
    );
  }
}

// WIDGET UNTUK FORM REGISTER
class RegisterForm extends StatefulWidget {
  final VoidCallback onFlip;
  const RegisterForm({super.key, required this.onFlip});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message.toString())));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Password tidak cocok.")));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthCard(
      title: 'Buat Akun Baru',
      fields: [
        AuthTextField(controller: _emailController, labelText: 'Email'),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          labelText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _confirmPasswordController,
          labelText: 'Konfirmasi Password',
          obscureText: true,
        ),
      ],
      primaryButtonText: 'Daftar',
      onPrimaryButtonPressed: signUp,
      secondaryText: 'Sudah punya akun? ',
      secondaryButtonText: 'Masuk di sini',
      onSecondaryButtonPressed: widget.onFlip,
    );
  }
}

// WIDGET REUSABLE UNTUK KARTU & TEXTFIELD
class AuthCard extends StatelessWidget {
  final String title;
  final List<Widget> fields;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String secondaryText;
  final String secondaryButtonText;
  final VoidCallback onSecondaryButtonPressed;

  const AuthCard({
    super.key,
    required this.title,
    required this.fields,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    required this.secondaryText,
    required this.secondaryButtonText,
    required this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(76), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ...fields,
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPrimaryButtonPressed,
                  child: Text(primaryButtonText),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    secondaryText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: onSecondaryButtonPressed,
                    child: Text(
                      secondaryButtonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withAlpha(128)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
