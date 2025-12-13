import 'package:flutter/material.dart';
import '../models/MealDetail.dart';

class IngredientList extends StatelessWidget {
  final MealDetail meal;
  const IngredientList({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: meal.ingredients.map((e) {
        final ing = e['ingredient'] ?? '';
        final meas = e['measure'] ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Text('• '),
              Expanded(child: Text('$ing — $meas')),
            ],
          ),
        );
      }).toList(),
    );
  }
}
