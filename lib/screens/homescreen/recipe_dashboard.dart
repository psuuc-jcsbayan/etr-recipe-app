import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/screens/homescreen/search_result_screen.dart';
import '../../models/category_items.dart';
import '../../models/recipe.dart';
import '../add_recipe.dart';
import '../favorite screen/listed_favorites.dart';
import '../personal recipes/recipe_detail_screen.dart';
import '../profile screen/profile_screen.dart';
import '../../components/db_helper.dart';

class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});

  @override
  State<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  int _currentIndex = 0;
  final List<Widget> _screens = [const ProfileScreen()];
  List<Recipe> _personalRecipes = [];
  List<Recipe> _favoriteRecipes = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = false;

  // Load recipes from the database
  Future<void> _loadRecipes() async {
    final recipes = await DBHelper().fetchRecipes();
    setState(() {
      _personalRecipes = recipes;
      _favoriteRecipes = recipes.where((recipe) => recipe.isFavorite).toList();
    });
  }

  // Navigate to Search Result Screen
  void _searchRecipes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(
          query: _searchController.text,
          recipes: _personalRecipes,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dailycious'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeFormPage(onSave: (recipe) async {
                    await DBHelper().insertRecipe(recipe);
                    _loadRecipes();
                  }),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search recipes...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _searchRecipes,
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                // Categories Section
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "CATEGORIES",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryItem(
                        categoryName: 'Breakfast',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: 'Breakfast',
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        categoryName: 'Lunch',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: 'Lunch',
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        categoryName: 'Dinner',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: 'Dinner',
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        categoryName: 'Snacks',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: 'Snacks',
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        categoryName: 'Appetizer',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryName: 'Appetizer',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Personal Recipes Section
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const Text(
                          "PERSONAL RECIPES",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isGridView = !_isGridView;
                          });
                        },
                        icon: Icon(
                          _isGridView ? Icons.list : Icons.grid_3x3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _personalRecipes.isEmpty
                    ? const Center(
                        child: Text(
                          "No personal recipe yet",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
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
                            itemCount: _personalRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = _personalRecipes[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailsScreen(recipe: recipe),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: recipe.imagePath != null &&
                                                File(recipe.imagePath!)
                                                    .existsSync()
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
                                                _loadRecipes();
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
                            itemCount: _personalRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = _personalRecipes[index];
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
                                      _loadRecipes();
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecipeDetailsScreen(recipe: recipe),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
          FavoritesScreen(favoriteRecipes: _favoriteRecipes),
          _screens[0],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.categoryName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tapping this item triggers navigation
      child: Card(
        child: Center(
          child: Text(
            categoryName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can display the recipes in this category, etc.
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Recipes for $categoryName'),
      ),
    );
  }
}
