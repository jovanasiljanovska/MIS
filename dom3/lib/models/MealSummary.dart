class MealSummary{
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  MealSummary({
  required this.idMeal,
  required this.strMeal,
  required this.strMealThumb,
  });

  Map<String, dynamic> toJson() => {
    'idMeal': idMeal,
    'strMeal': strMeal,
    'strMealThumb': strMealThumb,
  };

  factory MealSummary.fromJson(Map<String, dynamic> json) => MealSummary(
      idMeal: json['idMeal'],
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
  );

}