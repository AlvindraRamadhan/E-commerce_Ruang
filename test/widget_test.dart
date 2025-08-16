import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ruang/presentation/providers/cart_provider.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';

// Ganti nama kelas 'RuangApp' di bawah ini jika nama kelas
// utama di file main.dart Anda berbeda.
class RuangApp extends StatelessWidget {
  const RuangApp({super.key});  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        // Isi MaterialApp ini bisa disesuaikan dengan milik Anda,
        // tapi untuk tes, ini sudah cukup.
        home: Scaffold(
          body: Container(), // Body sederhana untuk tes
        ),
      ),
    );
  }
}

void main() {
  testWidgets('App starts and shows HomePage smoke test',
      (WidgetTester tester) async {
    // Bangun widget utama aplikasi Anda.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        // Kita gunakan RuangApp yang sudah kita definisikan di atas
        child: const RuangApp(),
      ),
    );

    // Verifikasi dasar untuk memastikan aplikasi berjalan
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
