import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ruang/presentation/screens/auth/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'RUANG | Premium Furniture & Decor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A4F33),
          primary: const Color(0xFF0A4F33),
          surface: const Color(0xFFF8F8F8),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(textTheme).copyWith(
          displayLarge:
              GoogleFonts.playfairDisplayTextTheme(textTheme).displayLarge,
          displayMedium:
              GoogleFonts.playfairDisplayTextTheme(textTheme).displayMedium,
          displaySmall:
              GoogleFonts.playfairDisplayTextTheme(textTheme).displaySmall,
          headlineMedium:
              GoogleFonts.playfairDisplayTextTheme(textTheme).headlineMedium,
          headlineSmall:
              GoogleFonts.playfairDisplayTextTheme(textTheme).headlineSmall,
          titleLarge:
              GoogleFonts.playfairDisplayTextTheme(textTheme).titleLarge,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0A4F33),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
