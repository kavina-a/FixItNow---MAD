// categories_page_portrait.dart
import 'package:fixitnow/screens/categories/service_provider_list.dart';
import 'package:flutter/material.dart';

class CategoriesPagePortrait extends StatelessWidget {
  // List of categories (could be fetched from an API later)
  final List<Map<String, String>> categories = [
    {"name": "Plumber", "image": "asset/plumber-category.jpeg"},
    {"name": "Electrician", "image": "asset/electrician-category.jpg"},
    {"name": "Painter", "image": "asset/painter-category.jpg"},
    {"name": "Carpenter", "image": "asset/carpenter-category.jpeg"},
    {"name": "Mechanic", "image": "asset/mechanic-category.jpeg"},
    {"name": "Mason", "image": "asset/mason-category.jpeg"},
    {"name": "Landscaper", "image": "asset/gardner-category.jpeg"},
    {"name": "Cleaner", "image": "asset/cleaner-category.jpeg"},
    {"name": "Roofer", "image": "asset/roofer-category.jpeg"},
    {"name": "Welder", "image": "asset/welder-category.jpg"}
  ];

  // List of gradients for the cards
  final List<List<Color>> gradients = [
    [Colors.pinkAccent, Colors.deepOrangeAccent],
    [Colors.lightBlueAccent, Colors.blue],
    [Colors.purpleAccent, Colors.deepPurple],
    [Colors.orangeAccent, Colors.redAccent],
    [Colors.tealAccent, Colors.green],
    [Colors.amberAccent, Colors.brown],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Categories"),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              name: category['name']!,
              imagePath: category['image']!,
              gradientColors: gradients[index % gradients.length],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProviderList(category: category['name']!),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  CategoryCard({
    required this.name,
    required this.imagePath,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
