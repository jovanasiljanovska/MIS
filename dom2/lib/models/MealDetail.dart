class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strInstructions;
  final String strMealThumb;
  final String? strYoutube;
  final String? strTags;
  final String? strCategory;
  final String? strArea;
  final String? strMealAlternate;
  final String? strSource;
  final String? strImageSource;
  final String? strCreativeCommonsConfirmed;
  final String? dateModified;
  final List<Map<String, String>> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strInstructions,
    required this.strMealThumb,
    this.strYoutube,
    this.strTags,
    this.strCategory,
    this.strArea,
    this.strMealAlternate,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <Map<String, String>>[];
    for (int i = 1; i <= 20; i++) {
      final String? ing = json['strIngredient$i'] as String?;
      final String? meas = json['strMeasure$i'] as String?;
      if (ing != null && ing.trim().isNotEmpty) {
        ingredients.add({'ingredient': ing, 'measure': meas ?? ''});
      }
    }

    return MealDetail(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strInstructions: json['strInstructions'] as String? ?? '',
      strMealThumb: json['strMealThumb'] as String,
      strYoutube: json['strYoutube'] as String?,
      strTags: json['strTags'] as String?,
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strMealAlternate: json['strMealAlternate'] as String?,
      strSource: json['strSource'] as String?,
      strImageSource: json['strImageSource'] as String?,
      strCreativeCommonsConfirmed: json['strCreativeCommonsConfirmed'] as String?,
      dateModified: json['dateModified'] as String?,
      ingredients: ingredients,
    );
  }
}
