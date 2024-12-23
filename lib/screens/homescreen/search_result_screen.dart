import 'package:flutter/material.dart';
import 'package:myapp/models/recipe.dart';
import 'package:myapp/screens/personal%20recipes/recipe_detail_screen.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;
  final List<Recipe> recipes;

  const SearchResultScreen(
      {super.key, required this.query, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = recipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
      ),
      body: filteredRecipes.isEmpty
          ? const Center(child: Text("No results found."))
          : ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(recipe.category),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailsScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
