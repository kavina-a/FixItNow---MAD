import 'package:flutter/cupertino.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class SP_HomeAppBar extends StatelessWidget {

  const SP_HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.menu,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    'FIXITNOW',
                    style: TextStyles.titleLarge
                ),
              ),
              Row(
                children: [
                  // Bell icon
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: const Icon(
                      CupertinoIcons.bell,
                    ),
                  ),
                  SizedBox(width: 16,),
                  ClipOval(
                    child: Image.asset(
                      'asset/profilepic.jpeg',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}