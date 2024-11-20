import 'package:bookie/presentation/widgets/section/home_first/hero_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/read_section.dart';
import 'package:bookie/presentation/widgets/section/home_first/unread_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';

class HomeFirstScreen extends StatelessWidget {
  static const String name = 'first-screen';

  const HomeFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navbar
      appBar: AppBar(
        // title: const Text('Historias cerca...'),
        leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Image.asset(
              'assets/images/logo_remove_background.png',
            )),
        // title: const Text("Bookie"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hola, Luis"),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://i.pinimg.com/736x/61/c9/a3/61c9a321f61a2650790911e828ada56d.jpg"),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
        ],
      ),

      // body
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroSection(unreadStories: unreadStories),
            UnreadSection(unreadStories: unreadStories),
            ReadSection(readStories: readStories),
          ],
        ),
      ),
    );
  }
}
