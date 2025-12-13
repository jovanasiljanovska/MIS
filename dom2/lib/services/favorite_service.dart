import '../models/MealSummary.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();

  factory FavoriteService() {
    return _instance;
  }

  FavoriteService._internal();


  final Set<MealSummary> _favorites = {};

  List<MealSummary> get favorites => _favorites.toList();

  bool isFavorite(String mealId) {
    return _favorites.any((meal) => meal.idMeal == mealId);
  }

  void toggleFavorite(MealSummary meal) {
    if (isFavorite(meal.idMeal)) {
      _favorites.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      _favorites.add(meal);
    }

    print('Омилени: ${_favorites.length} рецепти');
  }
}