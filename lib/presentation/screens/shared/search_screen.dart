import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _recentSearches = ['طبيب قلب', 'صيدلية شفاء', 'فيتامين سي', 'تحليل CBC'];
  final List<String> _popularSearches = ['دكتور جلدية', 'أمراض النساء', 'تحليل سكر', 'صيدلية 24 ساعة'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchController.clear()))
                : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عمليات البحث الأخيرة', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return Chip(
                  avatar: const Icon(Icons.history, size: 18, color: AppColors.grey),
                  label: Text(search),
                  onDeleted: () => setState(() => _recentSearches.remove(search)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('البحث الشائع', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popularSearches.map((search) {
                return ActionChip(
                  avatar: const Icon(Icons.trending_up, size: 18, color: AppColors.primary),
                  label: Text(search),
                  onPressed: () {},
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('الأقسام', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildCategoryChip('أطباء', Icons.local_hospital, AppColors.primary),
                _buildCategoryChip('صيدليات', Icons.local_pharmacy, AppColors.success),
                _buildCategoryChip('مختبرات', Icons.science, AppColors.info),
                _buildCategoryChip('أدوية', Icons.medication, AppColors.warning),
                _buildCategoryChip('تحاليل', Icons.biotech, AppColors.purple),
                _buildCategoryChip('تأمين', Icons.shield, AppColors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
