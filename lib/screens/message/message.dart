import 'package:fixitnow/screens/message/widgets/message_appbar.dart';
import 'package:fixitnow/screens/message/widgets/message_messagelist.dart';
import 'package:fixitnow/screens/message/widgets/message_storieslist.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [
              MessageAppBar(),
              MessagesStoriesList(),
              MessageList(),
            ],
          )
      ),
      // bottomNavigationBar: MainNavigationBar(),
    );
  }
}