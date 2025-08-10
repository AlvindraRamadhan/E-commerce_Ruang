import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/services/url_service.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    // Daftar FAQ diperbanyak menjadi 8 pertanyaan
    final List<Map<String, String>> faqs = [
      {'q': 'faqQ1', 'a': 'faqA1'},
      {'q': 'faqQ2', 'a': 'faqA2'},
      {'q': 'faqQ3', 'a': 'faqA3'},
      {'q': 'faqQ4', 'a': 'faqA4'},
      {'q': 'faqQ5', 'a': 'faqA5'},
      {'q': 'faqQ6', 'a': 'faqA6'},
      {'q': 'faqQ7', 'a': 'faqA7'},
      {'q': 'faqQ8', 'a': 'faqA8'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'faqTitle')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.get(locale, 'faqTopic'),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...faqs.map((faq) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    title: Text(AppStrings.get(locale, faq['q']!),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(AppStrings.get(locale, faq['a']!)),
                      )
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget Footer yang bisa digunakan kembali
Widget _buildFooter(BuildContext context) {
  final locale = context.watch<LocaleProvider>().locale;
  return Column(
    children: [
      Image.asset('assets/images/logo RUANG.png', height: 80),
      const SizedBox(height: 16),
      Text(
        AppStrings.get(locale, 'connectWithDev'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.github),
            onPressed: () =>
                UrlService.launchURL('https://github.com/AlvindraRamadhan'),
            tooltip: 'GitHub',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.linkedin),
            onPressed: () => UrlService.launchURL(
                'https://www.linkedin.com/in/alvindra-ramadhan'),
            tooltip: 'LinkedIn',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.instagram),
            onPressed: () => UrlService.launchURL(
                'https://www.instagram.com/alvindramadhann/'),
            tooltip: 'Instagram',
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.discord),
            onPressed: () =>
                UrlService.launchURL('https://discord.com/invite/q28QhDWv'),
            tooltip: 'Discord',
          ),
        ],
      )
    ],
  );
}
