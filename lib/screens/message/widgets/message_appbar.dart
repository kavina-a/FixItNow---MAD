import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/material.dart';

class MessageAppBar extends StatelessWidget  {
  const MessageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Chats', style: TextStyles.headlineLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              //
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              //
            },
          ),
        ],
      ),
    );
  }

}
