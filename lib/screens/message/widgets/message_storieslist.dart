import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagesStoriesList extends StatelessWidget {
  const MessagesStoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    return Padding(
      padding: const EdgeInsets.only(left: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stories',
            style: TextStyles.titleLarge,
          ),

          const SizedBox(height: 12,),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                storyRow('asset/story1.jpg', 'Nimesh'),

                SizedBox(width: size.width * 0.04), // Gap between stories

                storyRow('asset/story2.jpg', 'Akalanka'),
                SizedBox(width: size.width * 0.04), // Gap between stories

                storyRow('asset/story3.jpg', 'Bobby'),
                SizedBox(width: size.width * 0.04), // Gap between stories

                storyRow('asset/story4.jpg', 'Suresh'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget storyRow(String image, String text) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: TextStyles.primaryColor,
          radius: 45,
          child: CircleAvatar(
            radius: 42,
            backgroundImage: AssetImage(image),
          ),
        ),

        SizedBox(height: 5),

        Text(
          text,
          style: TextStyles.bodyMedium,
        ),
      ],
    );
  }
}