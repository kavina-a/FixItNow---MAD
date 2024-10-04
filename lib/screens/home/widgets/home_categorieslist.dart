import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import '../../categories/categories.dart';
import '../../categories/service_provider_list.dart';  // Assuming you have this page

class CategoryItem {
  final String name;  // Add a name field for the category
  final String image;

  CategoryItem(this.name, this.image);  // Include name in the constructor
}

List<CategoryItem> items = [
  CategoryItem("Carpenter", "asset/carpenter-category.jpeg"),
  CategoryItem("Plumber", "asset/plumber-category.jpeg"),
  CategoryItem("Electrician", "asset/electrician-category.jpg"),
  CategoryItem("Welder", "asset/welder-category.jpg"),
];

class HomeCategoriesList extends StatelessWidget {
  const HomeCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyles.titleLarge,
            ),
            GestureDetector(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoriesPage()), // Navigate to full category list
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(color: TextStyles.primaryColor),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        Container(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, _) => SizedBox(width: 10),
            itemBuilder: (context, index) => buildCard(context, items[index]),
          ),
        )
      ],
    );
  }

  Widget buildCard(BuildContext context, CategoryItem item) {
    return GestureDetector(
      onTap: () {
        // Navigate to ServiceProviderList page when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceProviderList(
              category: item.name,  // Pass the selected category name
            ),
          ),
        );
      },
      child: Material(
        child: Container(
          margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(item.image),  // Display category image
              fit: BoxFit.cover,
            ),
          ),
          width: 140,
          height: 130,
        ),
      ),
    );
  }
}
