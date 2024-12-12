import 'package:bookie/presentation/widgets/shared/button_home.dart';
import 'package:flutter/material.dart';

class MessageEmptyChapter extends StatelessWidget {
  const MessageEmptyChapter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("No hay capítulos disponibles"),
      const SizedBox(height: 16),
      ButtonHome()
    ]));
  }
}
