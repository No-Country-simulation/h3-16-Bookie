import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 200,
            margin: const EdgeInsets.only(right: 8.0),
            color: Colors.grey[200],
          ),
        ),
        const SizedBox(width: 8.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 200,
            margin: const EdgeInsets.only(right: 8.0),
            color: Colors.grey[200],
          ),
        ),
        const SizedBox(width: 8.0),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 200,
            margin: const EdgeInsets.only(right: 8.0),
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
