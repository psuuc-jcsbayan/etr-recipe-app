class Recipe {
  final int? id;
  final String title;
  final String timeDuration;
  final String category;
  final String ingredients;
  final String steps;
  final String? imagePath;
  bool isFavorite; // New property

  Recipe({
    this.id,
    required this.title,
    required this.timeDuration,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.imagePath,
    this.isFavorite = false, // Default value
  });

  // Convert Recipe to a map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'timeDuration': timeDuration,
      'category': category,
      'ingredients': ingredients,
      'steps': steps,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0, // Convert bool to int for DB
    };
  }

  // Create a Recipe object from a map (useful for reading from the database)
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      title: map['title'],
      timeDuration: map['timeDuration'],
      category: map['category'],
      ingredients: map['ingredients'],
      steps: map['steps'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1, // Convert int to bool
    );
  }
}
