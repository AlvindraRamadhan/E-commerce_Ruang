import 'package:flutter/widgets.dart';

class AppStrings {
  static const Map<String, String> _en = {
    'chooseLanguage': 'Choose language',
    'agreeTo': 'I agree to the',
    'termsAndConditions': 'Terms & Conditions',
    'and': 'and',
    'privacyPolicy': 'Privacy Policy',
    'getStarted': "Let's get started",
  };

  static const Map<String, String> _id = {
    'chooseLanguage': 'Pilih bahasa',
    'agreeTo': 'Saya setuju dengan',
    'termsAndConditions': 'Syarat & Ketentuan',
    'and': 'dan',
    'privacyPolicy': 'Kebijakan Privasi',
    'getStarted': 'Mari kita mulai',
  };

  static String get(Locale locale, String key) {
    if (locale.languageCode == 'id') {
      return _id[key] ?? key;
    }
    return _en[key] ?? key;
  }
}
