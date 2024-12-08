import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class RecipeApp extends StatefulWidget {
  const RecipeApp({super.key});

  @override
  State<RecipeApp> createState() => _RecipeAppState();
}

class _RecipeAppState extends State<RecipeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dailycious"),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: SingleChildScrollView(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 150.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 500),
                      pauseAutoPlayOnTouch: true,
                      enlargeCenterPage: true,
                    ),
                    items: [
                      'assets/images/pang2.jpg',
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
                              color: Color(0xFFFFDE59),
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
            ),
          ),
          //CATEGORIES
          Divider(),
          Row(
            children: [
              
            ],
          )
        ],
      ),
    );
  }
}
