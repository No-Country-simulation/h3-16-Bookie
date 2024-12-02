import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DemoPage extends StatelessWidget {
  final String pageContent;
  final TextStyle textStyle;
  final int? isCurrentChapter;
  final bool? isEndOfChapter;

  const DemoPage({
    super.key,
    required this.pageContent,
    required this.textStyle,
    this.isCurrentChapter,
    this.isEndOfChapter,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(
              pageContent,
              style: textStyle,
            ),
            if (isCurrentChapter != null &&
                isEndOfChapter == false &&
                isCurrentChapter! > 0)
              ElevatedButton(
                onPressed: () {
                  // Acción para ir al capítulo anterior
                  context.push('/chapters/view/128/${isCurrentChapter! - 1}');
                },
                child: Text('Ir al capítulo ${isCurrentChapter!}'),
              ),
            if (isCurrentChapter != null && isEndOfChapter == false)
              ElevatedButton(
                onPressed: () {
                  // Acción para ir al siguiente capítulo
                  context.push('/chapters/view/128/${isCurrentChapter! + 1}');
                },
                child: Text('Ir al capítulo ${isCurrentChapter! + 2}'),
              ),
            if (isEndOfChapter == true)
              ElevatedButton(
                onPressed: () {
                  // TODO CAMBIAR ESTO POR EL HOME XD
                  context.push('/chapter/success/128');
                },
                child: Text('Ir a home'),
              ),
          ]),
        ));
  }
}
