import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../components/db_helper.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  List<Recipe> _categoryRecipes = []; // Default empty list
  bool _isGridView = false;

  // Default recipe data in case of empty database
  List<Recipe> get defaultRecipes {
    return [
      Recipe(
        id: 1,
        title: 'Sample Recipe 1',
        timeDuration: '30',
        category: widget.categoryName,
        ingredients: 'Ingredients for Sample Recipe 1',
        steps: 'Steps for Sample Recipe 1',
        imagePath: null,
        isFavorite: false,
      ),
      Recipe(
        id: 2,
        title: 'Sample Recipe 2',
        timeDuration: '45',
        category: widget.categoryName,
        ingredients: 'Ingredients for Sample Recipe 2',
        steps: 'Steps for Sample Recipe 2',
        imagePath: null,
        isFavorite: false,
      ),
    ];
  }

  // Load recipes from the database and filter them by category
  Future<void> _loadCategoryRecipes() async {
    try {
      // Fetch recipes by category using DBHelper method
      final recipes =
          await DBHelper().fetchRecipesByCategory(widget.categoryName);
      print("Recipes fetched: $recipes");

      // If no recipes are found, fallback to default recipes
      if (recipes.isEmpty) {
        setState(() {
          _categoryRecipes = defaultRecipes;
        });
      } else {
        setState(() {
          _categoryRecipes = recipes;
        });
      }
    } catch (error) {
      print("Error fetching recipes: $error");
      // Fallback to default recipes in case of error
      setState(() {
        _categoryRecipes = defaultRecipes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategoryRecipes(); // Load recipes when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    final recipesToDisplay = _categoryRecipes.isEmpty ? [] : _categoryRecipes;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid/List view toggle button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Recipes in ${widget.categoryName}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isGridView ? Icons.list : Icons.grid_3x3,
                  ),
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),
              ],
            ),
          ),
          // Displaying recipes in either grid or list view
          Expanded(
            child: recipesToDisplay.isEmpty
                ? const Center(
                    child: Text(
                      "No recipes in this category yet.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: recipesToDisplay.length,
                        itemBuilder: (context, index) {
                          final recipe = recipesToDisplay[index];
                          return GestureDetector(
                            onTap: () {
                              // You can add functionality for navigation here
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: recipe.imagePath != null &&
                                            File(recipe.imagePath!).existsSync()
                                        ? Image.file(
                                            File(recipe.imagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(Icons.image, size: 50),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recipe.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            recipe.isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: recipe.isFavorite
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              recipe.isFavorite =
                                                  !recipe.isFavorite;
                                            });
                                            await DBHelper()
                                                .updateFavoriteStatus(
                                                    recipe.id!,
                                                    recipe.isFavorite);
                                            _loadCategoryRecipes();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${recipe.category} | ${recipe.timeDuration} mins',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipesToDisplay.length,
                        itemBuilder: (context, index) {
                          final recipe = recipesToDisplay[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              leading: recipe.imagePath != null &&
                                      File(recipe.imagePath!).existsSync()
                                  ? Image.file(
                                      File(recipe.imagePath!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image, size: 50),
                              title: Text(recipe.title),
                              subtitle: Text(
                                '${recipe.category} | ${recipe.timeDuration} mins',
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  recipe.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: recipe.isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    recipe.isFavorite = !recipe.isFavorite;
                                  });
                                  await DBHelper().updateFavoriteStatus(
                                      recipe.id!, recipe.isFavorite);
                                  _loadCategoryRecipes();
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
