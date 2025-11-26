import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../models/MealSummary.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({super.key, required this.category});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final _api = MealApiService();
  List<MealSummary> _base = [];
  List<MealSummary> _shown = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final meals = await _api.fetchMealsByCategory(widget.category);
      setState(() {
        _base = meals;
        _shown = meals;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _search(String q) async {
    setState(() => _query = q);
    if (q.trim().isEmpty) {
      setState(() => _shown = _base);
      return;
    }
    try {
      final results = await _api.searchMeals(q);
      final baseIds = _base.map((m) => m.idMeal).toSet();
      final filtered = results.where((m) => baseIds.contains(m.idMeal)).toList();
      setState(() => _shown = filtered);
    } catch (e) {

    }
  }

  void _openRandom() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MealDetailScreen(random: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [IconButton(icon: const Icon(Icons.shuffle), onPressed: _openRandom)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search in category'),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _shown.length,
              itemBuilder: (_, i) {
                final meal = _shown[i];
                return MealGridItem(
                  meal: meal,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.idMeal)),
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
