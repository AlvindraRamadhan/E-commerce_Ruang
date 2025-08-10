import 'dart:ui';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/auth/contact_us_page.dart';
import 'package:ruang/presentation/screens/auth/faq_page.dart';
import 'package:ruang/presentation/screens/main/main_screen.dart';
import 'package:ruang/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.black.withAlpha(26)),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipCard(
                    key: _cardKey,
                    flipOnTouch: false,
                    speed: 600,
                    front: LoginForm(onFlip: _toggleCard),
                    back: RegisterForm(onFlip: _toggleCard),
                  ),
                  const SizedBox(height: 24),
                  const _HelpSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// === LOGIN FORM ===
class LoginForm extends StatefulWidget {
  final VoidCallback onFlip;
  const LoginForm({super.key, required this.onFlip});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showErrorDialog() {
    final locale = context.read<LocaleProvider>().locale;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/images/failed.json', width: 120),
              const SizedBox(height: 16),
              Text(
                AppStrings.get(locale, 'loginFailedTitle'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.get(locale, 'loginFailedDesc'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onFlip();
              },
              child: Text(AppStrings.get(locale, 'register')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.get(locale, 'tryAgain')),
            )
          ],
        );
      },
    );
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on Exception {
      _showErrorDialog();
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithGoogle();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on Exception {
      _showErrorDialog();
    }
    if (mounted) {
      setState(() => _isLoading = false);
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
    final locale = context.watch<LocaleProvider>().locale;
    return AuthCard(
      isLoading: _isLoading,
      title: AppStrings.get(locale, 'welcome'),
      fields: [
        AuthTextField(
            controller: _emailController,
            labelText: AppStrings.get(locale, 'email')),
        const SizedBox(height: 16),
        AuthTextField(
            controller: _passwordController,
            labelText: AppStrings.get(locale, 'password'),
            obscureText: true),
      ],
      primaryButtonText: AppStrings.get(locale, 'login'),
      onPrimaryButtonPressed: _signIn,
      googleButtonText: AppStrings.get(locale, 'loginGoogle'),
      onGoogleButtonPressed: _signInWithGoogle,
      separatorText: AppStrings.get(locale, 'or'),
      secondaryText: '${AppStrings.get(locale, 'noAccount')} ',
      secondaryButtonText: AppStrings.get(locale, 'registerNow'),
      onSecondaryButtonPressed: widget.onFlip,
    );
  }
}

// === REGISTER FORM ===
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
  bool _isLoading = false;

  Future<void> _signUp() async {
    final locale = context.read<LocaleProvider>().locale;
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get(locale, 'passwordMismatch'))));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService().createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
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
    final locale = context.watch<LocaleProvider>().locale;
    return AuthCard(
      isLoading: _isLoading,
      title: AppStrings.get(locale, 'createAccount'),
      fields: [
        AuthTextField(
            controller: _emailController,
            labelText: AppStrings.get(locale, 'email')),
        const SizedBox(height: 16),
        AuthTextField(
            controller: _passwordController,
            labelText: AppStrings.get(locale, 'password'),
            obscureText: true),
        const SizedBox(height: 16),
        AuthTextField(
            controller: _confirmPasswordController,
            labelText: AppStrings.get(locale, 'confirmPassword'),
            obscureText: true),
      ],
      primaryButtonText: AppStrings.get(locale, 'register'),
      onPrimaryButtonPressed: _signUp,
      secondaryText: '${AppStrings.get(locale, 'haveAccount')} ',
      secondaryButtonText: AppStrings.get(locale, 'loginHere'),
      onSecondaryButtonPressed: widget.onFlip,
    );
  }
}

// === AUTH CARD ===
class AuthCard extends StatelessWidget {
  final bool isLoading;
  final String title;
  final List<Widget> fields;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String? googleButtonText;
  final VoidCallback? onGoogleButtonPressed;
  final String? separatorText;
  final String secondaryText;
  final String secondaryButtonText;
  final VoidCallback onSecondaryButtonPressed;

  const AuthCard({
    super.key,
    required this.isLoading,
    required this.title,
    required this.fields,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    this.googleButtonText,
    this.onGoogleButtonPressed,
    this.separatorText,
    required this.secondaryText,
    required this.secondaryButtonText,
    required this.onSecondaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Colors.white.withAlpha(76), width: 1.5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ...fields,
                const SizedBox(height: 24),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: onPrimaryButtonPressed,
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ))
                            : Text(primaryButtonText))),
                if (onGoogleButtonPressed != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white70)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(separatorText ?? 'OR',
                            style: const TextStyle(color: Colors.white)),
                      ),
                      const Expanded(child: Divider(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onGoogleButtonPressed,
                    icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                    label: Text(googleButtonText ?? 'Continue with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(secondaryText,
                        style: const TextStyle(color: Colors.white)),
                    GestureDetector(
                      onTap: onSecondaryButtonPressed,
                      child: Text(
                        secondaryButtonText,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// === AUTH TEXT FIELD ===
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

// === HELP SECTION WIDGET ===
class _HelpSection extends StatelessWidget {
  const _HelpSection();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final linkStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        );

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // PERBAIKAN: .withOpacity(0.2) diganti dengan .withAlpha(51)
        color: Colors.black.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
            children: [
              TextSpan(text: "${AppStrings.get(locale, 'needHelp')} "),
              TextSpan(
                text: AppStrings.get(locale, 'faq'),
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FaqPage()));
                  },
              ),
              TextSpan(text: " ${AppStrings.get(locale, 'or')} "),
              TextSpan(
                text: AppStrings.get(locale, 'contactUs'),
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ContactUsPage()));
                  },
              ),
            ]),
      ),
    );
  }
}
