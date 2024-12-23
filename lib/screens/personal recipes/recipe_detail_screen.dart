import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Import the share_plus package
import '../../models/recipe.dart'; // Ensure the path to the Recipe model is correct

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Helper function to convert a string into a list of items
    List<String> getList(String data) {
      return data.split('\n').where((line) => line.trim().isNotEmpty).toList();
    }

    final ingredientsList = getList(recipe.ingredients);
    final stepsList = getList(recipe.steps);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipe.title),
          actions: [
            IconButton(
              onPressed: () {
                // Edit button functionality (to be implemented)
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                // Delete button functionality (to be implemented)
              },
              icon: const Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () async {
                // Share button functionality
                final String shareContent = '''
Check out this recipe: ${recipe.title}

Category: ${recipe.category}
Duration: ${recipe.timeDuration} mins

Ingredients:
${recipe.ingredients}

Steps:
${recipe.steps}
                ''';

                try {
                  // If the recipe has an image, include it in the share
                  if (recipe.imagePath != null &&
                      File(recipe.imagePath!).existsSync()) {
                    await Share.shareFiles(
                      [recipe.imagePath!],
                      text: shareContent,
                    );
                  } else {
                    await Share.share(shareContent);
                  }
                } catch (e) {
                  // Show error message in case of failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error sharing the recipe: $e'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Recipe Image Section
              recipe.imagePath != null
                  ? Image.file(
                      File(recipe.imagePath!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),

              // Recipe Details Section
              Container(
                color: Colors.white, // Background color
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Recipe Title
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Favorite button functionality (to be implemented)
                          },
                          icon: const Icon(Icons.favorite),
                        ),
                      ],
                    ),
                    // Recipe Category and Time Duration
                    Row(
                      children: [
                        Chip(
                          label: Text(recipe.category),
                          backgroundColor: Colors.orange[100],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${recipe.timeDuration} mins',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TabBar Section
              const TabBar(
                tabs: [
                  Tab(text: "Ingredients"),
                  Tab(text: "Steps"),
                ],
              ),

              // TabBarView Section
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.6, // Set a fixed height
                child: TabBarView(
                  children: [
                    // Ingredients Tab
                    ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: ingredientsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              ingredientsList[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),

                    // Steps Tab
                    ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: stepsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              stepsList[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
