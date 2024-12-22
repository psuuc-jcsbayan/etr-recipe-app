import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/recipe.dart';
import '../components/db_helper.dart';

class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key, required Future<void> Function(Recipe recipe) onSave});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _timeDuration;
  String? _category;
  String? _ingredients;
  String? _steps;
  String? _selectedImage;

  final _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
      });
    }
  }

  // Function to validate and save the form
  void _validateAndSaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRecipe = Recipe(
        title: _title!,
        timeDuration: _timeDuration!,
        category: _category!,
        ingredients: _ingredients!,
        steps: _steps!,
        imagePath: _selectedImage,
      );

      // Save to the database
      DBHelper().insertRecipe(newRecipe).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe saved successfully!')),
        );
        Navigator.pop(context); // Close the form page
      });
    } else {
      // Alert user about incomplete fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all the fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: _selectedImage != null
                      ? Image.file(
                          File(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(Icons.add_a_photo_sharp, size: 50),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
                onSaved: (value) {
                  _title = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Time Duration',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter time duration'
                    : null,
                onSaved: (value) {
                  _timeDuration = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categories',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'Breakfast', child: Text('Breakfast')),
                  DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
                  DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
                  DropdownMenuItem(
                      value: 'Appetizer', child: Text('Appetizer')),
                  DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Select a category' : null,
                value: _category,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter the ingredients'
                    : null,
                onSaved: (value) {
                  _ingredients = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Step by Step',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter the steps' : null,
                onSaved: (value) {
                  _steps = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _validateAndSaveForm,
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
