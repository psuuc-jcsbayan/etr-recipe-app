import 'package:flutter/material.dart';

class CategoryModelsScreen extends StatelessWidget {
  const CategoryModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Models"),
        backgroundColor: Colors.grey[300],
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "Create models for categories like lunch, breakfast, dinner, etc.",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
