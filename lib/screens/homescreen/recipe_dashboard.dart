import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../models/category_items.dart';
import '../../models/recipe.dart';
import '../add_recipe.dart';
import '../favorite screen/listed_favorites.dart'; // Updated to work with favorite list
import '../personal recipes/recipe_detail_screen.dart';
import '../profile screen/profile_screen.dart';
import '../../components/db_helper.dart'; // Import DBHelper for database operations

class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});

  @override
  State<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProfileScreen(),
  ];

  List<Recipe> _personalRecipes = [];
  List<Recipe> _favoriteRecipes = []; // Maintain a list of favorite recipes

  // Load recipes from the database
  Future<void> _loadRecipes() async {
    final recipes = await DBHelper().fetchRecipes();
    setState(() {
      _personalRecipes = recipes;
      _favoriteRecipes =
          recipes.where((recipe) => recipe.isFavorite).toList(); // Filter favorites
    });
  }

  // Add a new recipe to the database
  Future<void> _addRecipeToDB(Recipe recipe) async {
    await DBHelper().insertRecipe(recipe);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe added successfully!')),
    );
    _loadRecipes(); // Refresh the list after adding
  }

  // Delete a recipe from the database
  Future<void> _deleteRecipeFromDB(int id) async {
    await DBHelper().deleteRecipe(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recipe deleted successfully!')),
    );
    _loadRecipes(); // Refresh the list after deletion
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Load recipes when the screen is initialized
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
                  builder: (context) => RecipeFormPage(
                    onSave: _addRecipeToDB, // Save to the database
                  ),
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
                // Carousel Slider Section
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 150.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 500),
                        pauseAutoPlayOnTouch: true,
                        enlargeCenterPage: true,
                      ),
                      items: [
                        'assets/images/carousels/carousel1.png',
                        'assets/images/manaog.jpg',
                        'assets/images/patar.jpg',
                        'assets/images/panga1.jpg',
                        'assets/images/pang3.jpg',
                        'assets/images/masamirey.jpg',
                      ].map((imagePath) {
                        return Builder(
                          builder: (BuildContext context) {
                            return AspectRatio(
                              aspectRatio: 30 / 9,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child:
                                      Image.asset(imagePath, fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
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
                    children: List.generate(
                      6,
                      (index) => CategoryItem(),
                    ),
                  ),
                ),

                // Personal Recipes Section
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "PERSONAL RECIPES",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _personalRecipes.isEmpty
                      ? const Center(
                          child: Text(
                            "No personal recipe yet",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _personalRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _personalRecipes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
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
                                      recipe.isFavorite = !recipe
                                          .isFavorite; // Toggle favorite status
                                    });
                                    // Update the database
                                    await DBHelper().updateFavoriteStatus(
                                        recipe.id!, recipe.isFavorite);
                                    _loadRecipes(); // Refresh the list
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
                ),
              ],
            ),
          ),

          // Favorites Screen
          FavoritesScreen(favoriteRecipes: _favoriteRecipes), // Pass favorite list

          // Profile Screen
          _screens[0],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
