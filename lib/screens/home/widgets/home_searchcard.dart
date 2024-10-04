import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixitnow/screens/widgets/styles.dart';

class HomeSearchCard extends StatelessWidget {
  const HomeSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25),

      child: TweenAnimationBuilder(
        //range of values that gets animated ( from 0 - 25 )
        tween: BorderRadiusTween(
          begin: BorderRadius.circular(0),
          end: BorderRadius.circular(25),
        ),
        duration: Duration(seconds: 5),
        builder: (context, borderRadius, child) {
          return TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 12.0), // Animating spreadRadius from 0 to 12
            duration: Duration(seconds: 5),
            builder: (context, value, child) {
              return Container(
                height: 200, // Check
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF7F66).withOpacity(0.5),
                      spreadRadius: value,
                      blurRadius: 10 + (value / 2),
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Search button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder(
                          tween: BorderRadiusTween(
                            begin: BorderRadius.circular(8),
                            end: BorderRadius.circular(18),
                          ),
                          duration: Duration(seconds: 5),
                          builder: (context, buttonBorderRadius, child) {
                            return TweenAnimationBuilder(
                              tween: Tween(begin: 10.0, end: 20.0), // Animating spreadRadius from 10 to 20
                              duration: Duration(seconds: 5),
                              builder: (context, buttonValue, child) {
                                return Container(
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  decoration: BoxDecoration(
                                    color: TextStyles.primaryColor,
                                    borderRadius: buttonBorderRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        color: TextStyles.primaryColor.withOpacity(0.5),
                                        spreadRadius: buttonValue,
                                        blurRadius: 8 + (buttonValue / 2),
                                      ),
                                    ],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: CupertinoColors.white,
                                      size: 30,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 18,),
                        Text('Search Now',
                          style: TextStyles.customTextStyle,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 40),
                      child: Image.asset(
                        'asset/labors.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
