import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/services/url_service.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'contactTitle')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Icon(
                  Icons.support_agent_outlined,
                  size: 120,
                  color: primaryColor,
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      end: const Offset(1.1, 1.1),
                      duration: 1500.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.get(locale, 'contactIntro'),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.call_outlined),
                title: Text(AppStrings.get(locale, 'contactCall')),
                subtitle: const Text('(+62) 812-3456-7890'),
              ),
              ListTile(
                leading: const Icon(Icons.alternate_email_outlined),
                title: Text(AppStrings.get(locale, 'contactEmail')),
                subtitle: const Text('support@ruangapp.com'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _buildFooter(context), // Footer dengan logo dan medsos
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
      // PERUBAHAN: Ukuran logo diperbesar
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
