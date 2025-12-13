import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Category.dart';
import '../models/MealSummary.dart';
import '../models/MealDetail.dart';

class MealApiService {
  static const base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode != 200) throw Exception('Failed categories');
    final data = json.decode(res.body);
    final list = (data['categories'] as List?) ?? [];
    return list.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$base/filter.php?c=$category'));
    if (res.statusCode != 200) throw Exception('Failed meals by category');
    final data = json.decode(res.body);
    final list = (data['meals'] as List?) ?? [];
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$base/search.php?s=$query'));
    if (res.statusCode != 200) throw Exception('Failed search');
    final data = json.decode(res.body);
    final list = (data['meals'] as List?) ?? [];
    return list.map((e) => MealSummary(
      idMeal: e['idMeal'],
      strMeal: e['strMeal'],
      strMealThumb: e['strMealThumb'],
    )).toList();
  }

  Future<MealDetail?> fetchMealDetail(String id) async {
    final res = await http.get(Uri.parse('$base/lookup.php?i=$id'));
    if (res.statusCode != 200) throw Exception('Failed detail');
    final data = json.decode(res.body);
    final list = (data['meals'] as List?) ?? [];
    if (list.isEmpty) return null;
    return MealDetail.fromJson(list.first);
  }

  Future<MealDetail?> fetchRandomMeal() async {
    final res = await http.get(Uri.parse('$base/random.php'));
    if (res.statusCode != 200) throw Exception('Failed random');
    final data = json.decode(res.body);
    final list = (data['meals'] as List?) ?? [];
    if (list.isEmpty) return null;
    return MealDetail.fromJson(list.first);
  }
}
