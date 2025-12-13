import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../widgets/meal_grid_item.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoriteService = FavoriteService();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favoriteService.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени Рецепти'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Немате додадено омилени рецепти.'))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: favorites.length,
        itemBuilder: (_, i) {
          final meal = favorites[i];
          return MealGridItem(
            meal: meal,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.idMeal)),
              );
              setState(() {});
            },
            onFavoriteToggled: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}