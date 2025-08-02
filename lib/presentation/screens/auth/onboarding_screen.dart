import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ruang/presentation/screens/auth/auth_page.dart'; // Nanti akan kita revisi
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  // Data untuk setiap halaman intro
  final List<Map<String, String>> introData = [
    {
      "animation": "assets/images/intro1.json",
      "title": "Temukan Estetika Anda",
      "description":
          "Jelajahi koleksi furnitur dan dekorasi yang dikurasi khusus untuk gaya unik Anda.",
    },
    {
      "animation": "assets/images/intro2.json",
      "title": "Kualitas Terjamin",
      "description":
          "Setiap produk dipilih berdasarkan kualitas bahan dan pengerjaan terbaik.",
    },
    {
      "animation": "assets/images/intro3.json",
      "title": "Wujudkan Ruang Impian",
      "description":
          "Mulai bangun dan hias ruang yang benar-benar terasa seperti rumah.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView untuk halaman-halaman intro
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
                title: introData[index]['title']!,
                description: introData[index]['description']!,
              );
            },
          ),

          // Indikator titik dan tombol navigasi
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Skip
                TextButton(
                  onPressed: () {
                    _controller.jumpToPage(introData.length - 1);
                  },
                  child: Text(
                    'SKIP',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),

                // Indikator Titik
                SmoothPageIndicator(
                  controller: _controller,
                  count: introData.length,
                  effect: WormEffect(
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),

                // Tombol Next / Done
                onLastPage
                    ? TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AuthPage(),
                            ),
                          );
                        },
                        child: Text(
                          'DONE',
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
                          'NEXT',
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

// Widget terpisah untuk konten setiap halaman onboarding
class OnboardingPageContent extends StatelessWidget {
  final String animationPath;
  final String title;
  final String description;

  const OnboardingPageContent({
    super.key,
    required this.animationPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 300),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
