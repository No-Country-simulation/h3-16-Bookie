import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowNotFavorites extends StatelessWidget {
  const ShowNotFavorites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    // final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 200,
            child:
                Lottie.asset('assets/lottie/success_complete_chapter_4.json'),
          ),
          const SizedBox(height: 12),
          Text(
            "Agrega tus historias favoritas",
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          // ButtonHome(),
        ],
      ),
    );
  }
}
