import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ruang/data/models/product_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/providers/main_screen_provider.dart';
import 'package:ruang/presentation/screens/main/chat_screen.dart';
import 'package:ruang/presentation/widgets/product_card.dart';
import 'package:ruang/services/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  String _selectedCategory = 'All';

  final List<String> promoBanners = [
    'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/276528/pexels-photo-276528.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6492397/pexels-photo-6492397.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  final List<Map<String, String>> categories = [
    {'key': 'categoryAll', 'value': 'All'},
    {'key': 'categoryChair', 'value': 'Chair'},
    {'key': 'categoryTable', 'value': 'Table'},
    {'key': 'categoryLamp', 'value': 'Lamp'},
    {'key': 'categorySofa', 'value': 'Sofa'},
    {'key': 'categoryCabinet', 'value': 'Cabinet'},
    {'key': 'categoryDecoration', 'value': 'Decoration'}
  ];

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients && _bannerController.page != null) {
        int nextPage = _bannerController.page!.toInt() + 1;
        if (nextPage >= promoBanners.length) nextPage = 0;
        _bannerController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChatScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.support_agent, color: Colors.white),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildSearchBar(context),
            _buildBanner(),
            _buildSectionHeader(context, locale, 'exploreCategories'),
            _buildCategoryChips(context, locale),
            _buildSectionHeader(context, locale, 'allProducts'),
            _buildProductGrid(locale),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      pinned: true,
      title: Row(
        children: [
          Image.asset('assets/images/logo RUANG.png', height: 38),
          const SizedBox(width: 8),
          Text('RUANG', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: GestureDetector(
          onTap: () {
            context.read<MainScreenProvider>().setPage(1);
          },
          child: AbsorbPointer(
            child: TextField(
              decoration: InputDecoration(
                hintText: AppStrings.get(locale, 'searchHint'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(128),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBanner() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _bannerController,
          itemCount: promoBanners.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Image.network(promoBanners[index], fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSectionHeader(
      BuildContext context, Locale locale, String key) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Text(AppStrings.get(locale, key),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryChips(BuildContext context, Locale locale) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            final bool isSelected = _selectedCategory == category['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(AppStrings.get(locale, category['key']!)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category['value']!;
                  });
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha(128),
                side: BorderSide.none,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(Locale locale) {
    return StreamBuilder<QuerySnapshot>(
      stream: ProductService.getProductsStream(category: _selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/error_animation.json',
                      width: 200),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Produk di kategori ini masih kosong.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        final products = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product.fromFirestore(data, doc.id, locale);
        }).toList();

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 80.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: ProductCard(product: products[index]),
                );
              },
              childCount: products.length,
            ),
          ),
        );
      },
    );
  }
}
