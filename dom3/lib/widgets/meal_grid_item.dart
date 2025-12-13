import 'package:dom2/services/favorite_service.dart';
import 'package:flutter/material.dart';
import '../models/MealSummary.dart';
import '../services/favorite_service.dart';

class MealGridItem extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggled;
  const MealGridItem({super.key, required this.meal, required this.onTap, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    final favoriteService = FavoriteService();
    final isFav=favoriteService.isFavorite(meal.idMeal);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child:Stack(
          children: [
            Image.network(meal.strMealThumb, fit: BoxFit.cover,width: double.infinity,height: double.infinity,),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(
                          meal.strMeal,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                    ),
                    IconButton(
                        onPressed: (){
                          favoriteService.toggleFavorite(meal);
                          onFavoriteToggled();
                        },
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white,
                        ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  ],
                ),
              ),
            )
          ],
        )

      ),
    );
  }
}
