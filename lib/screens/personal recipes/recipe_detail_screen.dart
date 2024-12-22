import 'dart:io';
import 'package:flutter/material.dart';
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
        ),
        body: Column(
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
                  Center(
                    child: Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Recipe Category and Time Duration
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
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
    );
  }
}
