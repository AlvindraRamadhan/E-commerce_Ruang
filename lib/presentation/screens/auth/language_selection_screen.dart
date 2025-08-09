import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/auth/onboarding_screen.dart';

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
    context.read<LocaleProvider>().setLocale(Locale(languageCode));
  }

  void _setTermsAccepted(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
    });
  }

  bool get _isButtonEnabled => _selectedLanguage != null && _termsAccepted;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

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
                AppStrings.get(locale, 'chooseLanguage'),
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
                              text: '${AppStrings.get(locale, 'agreeTo')} '),
                          TextSpan(
                            text: AppStrings.get(locale, 'termsAndConditions'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(text: ' ${AppStrings.get(locale, 'and')} '),
                          TextSpan(
                            text: AppStrings.get(locale, 'privacyPolicy'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () {},
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
                        final provider =
                            Provider.of<LocaleProvider>(context, listen: false);
                        provider.setLocale(Locale(_selectedLanguage!));

                        // --- TUJUAN BARU ---
                        // Arahkan ke OnboardingScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OnboardingScreen()),
                        );
                      }
                    : null,
                child: Text(AppStrings.get(locale, 'getStarted')),
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
