import 'package:flutter/material.dart';

import '../layouts/categorylist_landscape.dart';
import '../layouts/categorylist_potrait.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Categories',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: CategoriesPage(),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Detect orientation using MediaQuery
    var orientation = MediaQuery.of(context).orientation;

    // Switch between portrait and landscape pages
    return orientation == Orientation.portrait
        ? CategoriesPagePortrait()
        : CategoriesPageLandscape();
  }
}
