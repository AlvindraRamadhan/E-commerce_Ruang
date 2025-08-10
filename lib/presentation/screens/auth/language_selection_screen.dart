import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/auth/onboarding_screen.dart';
import 'package:ruang/l10n/policy_content.dart';
import 'package:ruang/presentation/screens/auth/policy_page.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? _selectedLanguage;
  bool _termsAccepted = false;

  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    // Kita tidak langsung set locale di provider di sini
    // Locale akan di-set saat tombol "Get Started" ditekan
  }

  void _setTermsAccepted(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
    });
  }

  bool get _isButtonEnabled => _selectedLanguage != null && _termsAccepted;

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLocale = _selectedLanguage == null
        ? localeProvider.locale
        : Locale(_selectedLanguage!);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo RUANG.png', height: 100),
              const SizedBox(height: 48),
              Text(
                AppStrings.get(currentLocale, 'chooseLanguage'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              LanguageButton(
                label: 'English',
                isSelected: _selectedLanguage == 'en',
                onTap: () => _selectLanguage('en'),
              ),
              const SizedBox(height: 16),
              LanguageButton(
                label: 'Indonesia',
                isSelected: _selectedLanguage == 'id',
                onTap: () => _selectLanguage('id'),
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: Checkbox(
                      value: _termsAccepted,
                      onChanged: _setTermsAccepted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                              text: '${AppStrings.get(currentLocale, 'agreeTo')} '),
                          TextSpan(
                            text: AppStrings.get(
                                currentLocale, 'termsAndConditions'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PolicyPage(
                                      title: PolicyContent.get(
                                          currentLocale, 'termsTitle'),
                                      content: PolicyContent.get(
                                          currentLocale, 'termsContent'),
                                    ),
                                  ),
                                );
                              },
                          ),
                          TextSpan(
                              text: ' ${AppStrings.get(currentLocale, 'and')} '),
                          TextSpan(
                            text:
                                AppStrings.get(currentLocale, 'privacyPolicy'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PolicyPage(
                                      title: PolicyContent.get(
                                          currentLocale, 'privacyTitle'),
                                      content: PolicyContent.get(
                                          currentLocale, 'privacyContent'),
                                    ),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        // Di sini kita finalisasi pilihan bahasa
                        localeProvider.setLocale(Locale(_selectedLanguage!));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OnboardingScreen()),
                        );
                      }
                    : null,
                child: Text(AppStrings.get(currentLocale, 'getStarted')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor:
            isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}