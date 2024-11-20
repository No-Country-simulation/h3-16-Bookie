import 'package:bookie/presentation/widgets/section/read_section.dart';
import 'package:bookie/presentation/widgets/section/unread_section.dart';
import 'package:bookie/shared/data/histories.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  static const String name = 'feed';

  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UnreadSection(unreadStories: unreadStories),
            ReadSection(readStories: readStories),
          ],
        ),
      ),
    );
  }
}
