import 'package:flutter/widgets.dart';

class AppStrings {
  static const Map<String, String> _en = {
    // Language Selection Screen
    'chooseLanguage': 'Choose language',
    'agreeTo': 'I agree to the',
    'termsAndConditions': 'Terms & Conditions',
    'and': 'and',
    'privacyPolicy': 'Privacy Policy',
    'getStarted': "Let's get started",

    // Onboarding Screen
    'onboarding1Title': 'Discover Your Aesthetic',
    'onboarding1Desc':
        'Explore curated furniture and decor collections for your unique style.',
    'onboarding2Title': 'Guaranteed Quality',
    'onboarding2Desc':
        'Every product is selected for the best quality materials and craftsmanship.',
    'onboarding3Title': 'Create Your Dream Space',
    'onboarding3Desc':
        'Start building and decorating a space that truly feels like home.',
    'skip': 'SKIP',
    'next': 'NEXT',
    'done': 'DONE',

    // Auth Page
    'welcome': 'Welcome',
    'email': 'Email',
    'password': 'Password',
    'login': 'Login',
    'loginGoogle': 'Continue with Google',
    'noAccount': "Don't have an account?",
    'registerNow': 'Register now',
    'createAccount': 'Create New Account',
    'confirmPassword': 'Confirm Password',
    'register': 'Register',
    'haveAccount': 'Already have an account?',
    'loginHere': 'Login here',
    'or': 'OR',
  };

  static const Map<String, String> _id = {
    // Language Selection Screen
    'chooseLanguage': 'Pilih bahasa',
    'agreeTo': 'Saya setuju dengan',
    'termsAndConditions': 'Syarat & Ketentuan',
    'and': 'dan',
    'privacyPolicy': 'Kebijakan Privasi',
    'getStarted': 'Mari kita mulai',

    // Onboarding Screen
    'onboarding1Title': 'Temukan Estetika Anda',
    'onboarding1Desc':
        'Jelajahi koleksi furnitur dan dekorasi yang dikurasi khusus untuk gaya unik Anda.',
    'onboarding2Title': 'Kualitas Terjamin',
    'onboarding2Desc':
        'Setiap produk dipilih berdasarkan kualitas bahan dan pengerjaan terbaik.',
    'onboarding3Title': 'Wujudkan Ruang Impian',
    'onboarding3Desc':
        'Mulai bangun dan hias ruang yang benar-benar terasa seperti rumah.',
    'skip': 'LEWATI',
    'next': 'LANJUT',
    'done': 'SELESAI',

    // Auth Page
    'welcome': 'Selamat Datang',
    'email': 'Email',
    'password': 'Password',
    'login': 'Masuk',
    'loginGoogle': 'Lanjutkan dengan Google',
    'noAccount': 'Belum punya akun?',
    'registerNow': 'Daftar sekarang',
    'createAccount': 'Buat Akun Baru',
    'confirmPassword': 'Konfirmasi Password',
    'register': 'Daftar',
    'haveAccount': 'Sudah punya akun?',
    'loginHere': 'Masuk di sini',
    'or': 'ATAU',
  };

  // Logika baru: Terima Locale, kembalikan String yang benar
  static String get(Locale locale, String key) {
    if (locale.languageCode == 'id') {
      return _id[key] ?? key;
    }
    return _en[key] ?? key;
  }
}
