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
    'loginFailedTitle': 'Login Failed',
    'loginFailedDesc':
        'The email or password you entered is incorrect or not registered.',
    'tryAgain': 'Try Again',
    'passwordMismatch': 'Passwords do not match.',

    // Home Page
    'searchHint': 'Search for your dream furniture...',
    'exploreCategories': 'Explore Categories',
    'allProducts': 'All Products',
    'categoryChair': 'Chair',
    'categoryTable': 'Table',
    'categoryLamp': 'Lamp',
    'categorySofa': 'Sofa',
    'categoryCabinet': 'Cabinet',
    'categoryDecoration': 'Decoration',

    // Navigation Bar
    'navHome': 'Home',
    'navSearch': 'Search',
    'navCart': 'Cart',
    'navProfile': 'Profile',

    // Product Detail Page
    'description': 'Description',
    'addToCart': 'Add to Cart',
    'itemAddedToCart': 'added to cart.',

    // Cart Page
    'cartTitle': 'Cart',
    'emptyCartTitle': 'Your cart is empty',
    'emptyCartDesc': 'Let\'s explore products and build your dream space!',
    'total': 'Total:',
    'checkout': 'Proceed to Checkout',
    'checkoutFeatureMessage': 'Checkout feature is under development.',

    // Chat Screen
    'chatTitle': 'RUANG Virtual Assistant',
    'chatHint': 'Ask about furniture...',
    'chatPlaceholder':
        'Sorry, the RUANG Virtual Assistant is currently under development and will be available soon!',
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
    'loginFailedTitle': 'Login Gagal',
    'loginFailedDesc':
        'Email atau password yang Anda masukkan salah atau belum terdaftar.',
    'tryAgain': 'Coba Lagi',
    'passwordMismatch': 'Password tidak cocok.',

    // Home Page
    'searchHint': 'Cari furnitur impianmu...',
    'exploreCategories': 'Jelajahi Kategori',
    'allProducts': 'Semua Produk',
    'categoryChair': 'Kursi',
    'categoryTable': 'Meja',
    'categoryLamp': 'Lampu',
    'categorySofa': 'Sofa',
    'categoryCabinet': 'Lemari',
    'categoryDecoration': 'Dekorasi',

    // Navigation Bar
    'navHome': 'Beranda',
    'navSearch': 'Pencarian',
    'navCart': 'Keranjang',
    'navProfile': 'Profil',

    // Product Detail Page
    'description': 'Deskripsi',
    'addToCart': 'Tambah ke Keranjang',
    'itemAddedToCart': 'ditambahkan ke keranjang.',

    // Cart Page
    'cartTitle': 'Keranjang',
    'emptyCartTitle': 'Keranjangmu masih kosong',
    'emptyCartDesc': 'Ayo jelajahi produk dan wujudkan ruang impianmu!',
    'total': 'Total:',
    'checkout': 'Lanjut ke Pembayaran',
    'checkoutFeatureMessage': 'Fitur checkout sedang dalam pengembangan.',

    // Chat Screen
    'chatTitle': 'Asisten Virtual RUANG',
    'chatHint': 'Tanyakan tentang furnitur...',
    'chatPlaceholder':
        'Mohon maaf, Asisten Virtual RUANG sedang dalam tahap pengembangan dan akan segera hadir!',
  };

  static String get(Locale locale, String key) {
    if (locale.languageCode == 'id') {
      return _id[key] ?? key;
    }
    return _en[key] ?? key;
  }
}
