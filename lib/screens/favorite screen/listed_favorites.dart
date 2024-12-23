import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../personal recipes/recipe_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> favoriteRecipes; // Receive the favorite recipes list

  const FavoritesScreen({super.key, required this.favoriteRecipes});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // List of recipe categories
  final List<String> categories = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snacks",
    "Appetizer",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to remove a recipe from favorites
  void _removeFromFavorites(Recipe recipe) {
    setState(() {
      widget.favoriteRecipes.remove(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
          indicatorColor: Colors.amber,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(categories.length, (categoryIndex) {
          // Filter recipes by category
          final categoryRecipes = widget.favoriteRecipes
              .where((recipe) => recipe.category == categories[categoryIndex])
              .toList();

          return categoryRecipes.isEmpty
              ? const Center(child: Text("No favorites in this category"))
              : ListView.builder(
                  itemCount: categoryRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = categoryRecipes[index];
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
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _removeFromFavorites(recipe);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(
                                recipe: recipe,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        }),
      ),
    );
  }
}
