import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> favoriteRecipes; // Receive the favorite recipes list

  const FavoritesScreen({Key? key, required this.favoriteRecipes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: recipe.imagePath != null
                        ? Image.file(
                            File(recipe.imagePath!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 50),
                    title: Text(recipe.title),
                    subtitle: Text(recipe.category),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
