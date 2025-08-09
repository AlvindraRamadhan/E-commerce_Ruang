import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/screens/auth/auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  final List<Map<String, String>> introData = [
    {
      "animation": "assets/images/intro1.json",
      "titleKey": "onboarding1Title",
      "descriptionKey": "onboarding1Desc",
    },
    {
      "animation": "assets/images/intro2.json",
      "titleKey": "onboarding2Title",
      "descriptionKey": "onboarding2Desc",
    },
    {
      "animation": "assets/images/intro3.json",
      "titleKey": "onboarding3Title",
      "descriptionKey": "onboarding3Desc",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == introData.length - 1);
              });
            },
            itemCount: introData.length,
            itemBuilder: (context, index) {
              return OnboardingPageContent(
                animationPath: introData[index]['animation']!,
                titleKey: introData[index]['titleKey']!,
                descriptionKey: introData[index]['descriptionKey']!,
              );
            },
          ),
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => _controller.jumpToPage(introData.length - 1),
                  child: Text(
                    AppStrings.get(locale, 'skip'),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: introData.length,
                  effect: WormEffect(
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
                onLastPage
                    ? TextButton(
                        onPressed: () {
                          // --- TUJUAN BARU ---
                          // Arahkan ke AuthPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.get(locale, 'done'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          AppStrings.get(locale, 'next'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final String animationPath;
  final String titleKey;
  final String descriptionKey;

  const OnboardingPageContent({
    super.key,
    required this.animationPath,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 300),
          const SizedBox(height: 48),
          Text(
            AppStrings.get(locale, titleKey),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.get(locale, descriptionKey),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
