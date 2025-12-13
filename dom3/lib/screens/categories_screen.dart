import 'package:dom2/screens/favorites_screen.dart';
import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../models/Category.dart';
import '../widgets/category_card.dart';
import 'meal_detail_screen.dart';
import 'meals_by_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _api = MealApiService();
  List<Category> _all = [];
  List<Category> _filtered = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final cats = await _api.fetchCategories();
      setState(() {
        _all = cats;
        _filtered = cats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _applyFilter(String q) {
    setState(() {
      _query = q;
      _filtered = _all.where((c) => c.strCategory.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  void _openRandom() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen(random: true)));
  }

  void _openFavorites(){
    Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(icon: const Icon(Icons.receipt_long_rounded), onPressed: _openRandom),
          IconButton(onPressed: _openFavorites, icon: const Icon(Icons.favorite)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search categories'),
              onChanged: _applyFilter,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                return CategoryCard(
                  category: c,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MealsByCategoryScreen(category: c.strCategory)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
