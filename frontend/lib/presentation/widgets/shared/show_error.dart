import 'package:bookie/presentation/widgets/shared/button_home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowError extends StatelessWidget {
  final String message;

  const ShowError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    // final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 200,
            child: Lottie.asset('assets/lottie/no_search.json'),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ButtonHome(),
        ],
      ),
    );
  }
}
