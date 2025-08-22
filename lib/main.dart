// Lokasi: lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/providers/main_screen_provider.dart';
// PERBAIKAN DI SINI: Path ke splash_screen.dart diperbaiki
import 'package:ruang/presentation/screens/auth/splash_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainScreenProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..loadLocale()),
      ],
      child: const RuangApp(),
    ),
  );
}

class RuangApp extends StatelessWidget {
  const RuangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
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
              surfaceContainerHighest: Colors.grey[200]!,
              onSurface: Colors.black87,
              error: Colors.red[700],
              onError: Colors.white,
              primaryContainer: const Color(0xFFD4E7DE),
              onPrimaryContainer: const Color(0xFF002113),
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(textTheme).copyWith(
              displayLarge:
                  GoogleFonts.playfairDisplayTextTheme(textTheme).displayLarge,
              displayMedium:
                  GoogleFonts.playfairDisplayTextTheme(textTheme).displayMedium,
              displaySmall:
                  GoogleFonts.playfairDisplayTextTheme(textTheme).displaySmall,
              headlineMedium: GoogleFonts.playfairDisplayTextTheme(textTheme)
                  .headlineMedium,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ),
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('id', ''), // Indonesian
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}
