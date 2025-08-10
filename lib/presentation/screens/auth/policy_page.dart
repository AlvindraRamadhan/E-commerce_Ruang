import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang/l10n/app_strings.dart';
import 'package:ruang/presentation/providers/locale_provider.dart';
import 'package:share_plus/share_plus.dart';

class PolicyPage extends StatelessWidget {
  final String title;
  final String content;

  const PolicyPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PolicySearchDelegate(
                  content: content,
                  // Mengirim string yang sudah diterjemahkan
                  searchFieldLabelText: AppStrings.get(locale, 'policySearchHint'),
                  noResultsText: AppStrings.get(locale, 'policyNoResults'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('$title:\n\n$content', subject: title);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ),
      ),
    );
  }
}

class PolicySearchDelegate extends SearchDelegate {
  final String content;
  final String searchFieldLabelText;
  final String noResultsText;
  late final List<String> paragraphs;

  PolicySearchDelegate({
    required this.content,
    required this.searchFieldLabelText,
    required this.noResultsText,
  }) {
    paragraphs = content.split('\n').where((p) => p.trim().isNotEmpty).toList();
  }

  @override
  String get searchFieldLabel => searchFieldLabelText;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = paragraphs
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(child: Text(noResultsText));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = paragraphs
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (query.isEmpty) {
      return Container();
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}