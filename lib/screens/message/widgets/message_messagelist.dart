import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    Brightness brightness = Theme.of(context).brightness;

    Color backgroundColor = brightness == Brightness.light ? TextStyles.primaryColor.withOpacity(0.2) : Theme.of(context).colorScheme.secondary;

    Color textColor = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.5) // Dark theme text color
        : Colors.black.withOpacity(0.5); // Light theme text color

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: size.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              messageRow(size, 'Ashen', '09.20', 'mama ena gaman sir', 'asset/workerpic1.jpg', textColor),
              SizedBox(height: size.height * 0.01),
              Divider(
                thickness: 0.1,
              ),
              messageRow(size, 'Sam', '12.53', 'Hope everything went well', 'asset/workerpic2.jpg',textColor),
              SizedBox(height: size.height * 0.01),
              Divider(
                thickness: 0.1,
              ),
              messageRow(size, 'Bhanuka', '17.17', 'Hey, I\'m here', 'asset/workerpic3.jpg',textColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageRow(Size size, String name, String time, String message, String image, Color textColor) {

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(image),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(name, style: TextStyles.bodyLarge),
                    ),
                    Text(time, style: TextStyles.bodyMedium),
                  ],
                ),
                Text(message,style: TextStyle(color: textColor),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
