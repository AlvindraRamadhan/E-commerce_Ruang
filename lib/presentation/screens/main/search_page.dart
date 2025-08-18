// Lokasi: presentation/screens/main/search_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ruang/data/models/product_model.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:ruang/presentation/widgets/product_card.dart';
import 'package:ruang/services/product_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  String _textQuery = '';
  RangeValues _priceRange = const RangeValues(0, 5000000);
  final List<String> _selectedCategories = [];

  final List<Map<String, String>> _categories = [
    {'key': 'categoryChair', 'value': 'Chair'},
    {'key': 'categoryTable', 'value': 'Table'},
    {'key': 'categoryLamp', 'value': 'Lamp'},
    {'key': 'categorySofa', 'value': 'Sofa'},
    {'key': 'categoryCabinet', 'value': 'Cabinet'},
    {'key': 'categoryDecoration', 'value': 'Decoration'}
  ];

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _textQuery = '';
      _selectedCategories.clear();
      _priceRange = const RangeValues(0, 5000000);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _textQuery = _searchController.text.trim();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(locale, 'searchTitle')),
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
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
                  const SizedBox(height: 24),
                  Text(AppStrings.get(locale, 'searchCategories'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _categories.map((category) {
                      final bool isSelected =
                          _selectedCategories.contains(category['value']);
                      return FilterChip(
                        label: Text(AppStrings.get(locale, category['key']!)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category['value']!);
                            } else {
                              _selectedCategories.remove(category['value']!);
                            }
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface),
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withAlpha(128),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(AppStrings.get(locale, 'searchPriceRange'),
                      style: Theme.of(context).textTheme.titleMedium),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    labels: RangeLabels(
                      currencyFormatter.format(_priceRange.start),
                      currencyFormatter.format(_priceRange.end),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      child: Text(AppStrings.get(locale, 'searchResetFilter')),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            // PERBAIKAN: Parameter 'locale' yang salah telah dihapus
            stream: ProductService.searchProductsStream(
              categories:
                  _selectedCategories.isNotEmpty ? _selectedCategories : null,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // Kode print() untuk diagnosis sudah dihapus
                return const SliverFillRemaining(
                    child: Center(child: Text("Terjadi kesalahan")));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverToBoxAdapter(
                    child: _buildEmptyState(context, locale));
              }

              final allProducts = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Product.fromFirestore(data, doc.id, locale);
              }).toList();

              final filteredProducts = allProducts.where((product) {
                final nameMatch = _textQuery.isEmpty ||
                    product.name
                        .toLowerCase()
                        .contains(_textQuery.toLowerCase());

                final priceMatch = product.price >= _priceRange.start &&
                    product.price <= _priceRange.end;

                return nameMatch && priceMatch;
              }).toList();

              if (filteredProducts.isEmpty) {
                return SliverToBoxAdapter(
                    child: _buildEmptyState(context, locale));
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16.0, 24, 16.0, 80.0),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Locale locale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Column(
        children: [
          Lottie.asset('assets/images/error_animation.json', width: 200),
          const SizedBox(height: 16),
          Text(
            AppStrings.get(locale, 'searchNoResults'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
