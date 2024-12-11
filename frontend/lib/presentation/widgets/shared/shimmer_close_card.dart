import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCardContent extends StatelessWidget {
  const ShimmerCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título "Historias cercanas"
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Historias cercanas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colors.primary,
              ),
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(
                3,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: SizedBox(
                      width: 150, // Ajusta el tamaño del card
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: shimmerBaseColor,
                                highlightColor: shimmerHighlightColor,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: containerShimmer,
                                  ),
                                ),
                              ),

                              // Shimmer para el título
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4.0, right: 8.0, left: 8.0),
                                child: Shimmer.fromColors(
                                  baseColor: shimmerBaseColor,
                                  highlightColor: shimmerHighlightColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 150,
                                      height: 20,
                                      color: containerShimmer,
                                    ),
                                  ),
                                ),
                              ),

                              // Shimmer para la distancia
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 2.0,
                                    right: 8.0,
                                    left: 8.0,
                                    bottom: 8.0),
                                child: Shimmer.fromColors(
                                  baseColor: shimmerBaseColor,
                                  highlightColor: shimmerHighlightColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 200,
                                      height: 14,
                                      color: containerShimmer,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
