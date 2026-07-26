import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../screens/category_detail_screen.dart';

class PuulSearchDelegate extends SearchDelegate<void> {
  final List<Map<String, dynamic>> categories;

  PuulSearchDelegate({required this.categories})
      : super(
          searchFieldLabel: 'Search your PUULs',
        );

  List<Map<String, dynamic>> _matches(String rawQuery) {
    final q = rawQuery.trim().toLowerCase();
    if (q.isEmpty) return categories;
    return categories.where((c) {
      final name = (c['name'] as String).toLowerCase();
      final tag = (c['tag'] as String).toLowerCase();
      return name.contains(q) || tag.contains(q);
    }).toList();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = _matches(query);

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                query.isEmpty ? 'Start typing to search your PUULs' : 'No PUULs match "$query"',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final category = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: (category['color'] as Color).withOpacity(0.15),
            child: Icon(category['icon'] as IconData, color: category['color'] as Color),
          ),
          title: Text(
            category['name'] as String,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${category['photoCount']} photos · ${category['members']} members',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailScreen(category: category),
              ),
            );
          },
        );
      },
    );
  }
}
