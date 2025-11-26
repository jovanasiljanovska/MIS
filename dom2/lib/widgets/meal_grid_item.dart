import 'package:flutter/material.dart';
import '../models/MealSummary.dart';

class MealGridItem extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;
  const MealGridItem({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GridTile(
        footer: Container(
          color: Colors.black54,
          padding: const EdgeInsets.all(6),
          child: Text(meal.strMeal, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white)),
        ),
        child: Image.network(meal.strMealThumb, fit: BoxFit.cover),
      ),
    );
  }
}
