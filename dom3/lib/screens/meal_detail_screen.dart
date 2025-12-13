import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/meal_api_service.dart';
import '../models/MealDetail.dart';
import '../widgets/ingredient_list.dart';

class MealDetailScreen extends StatefulWidget {
  final String? mealId;
  final bool random;
  const MealDetailScreen({super.key, this.mealId, this.random = false});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _api = MealApiService();
  MealDetail? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      MealDetail? m;
      if (widget.random) {
        m = await _api.fetchRandomMeal();
      } else if (widget.mealId != null) {
        m = await _api.fetchMealDetail(widget.mealId!);
      }
      setState(() {
        _meal = m;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _openYoutube() async {
    if (_meal?.strYoutube == null || _meal!.strYoutube!.isEmpty) return;
    final url = Uri.parse(_meal!.strYoutube!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot open YouTube')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_meal?.strMeal ?? 'Recipe')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
          ? const Center(child: Text('Recipe not found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(_meal!.strMealThumb, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(_meal!.strMeal, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            IngredientList(meal: _meal!),
            const SizedBox(height: 16),
            Text('Instructions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_meal!.strInstructions),
            const SizedBox(height: 16),
            if ((_meal!.strYoutube ?? '').isNotEmpty)
              ElevatedButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
