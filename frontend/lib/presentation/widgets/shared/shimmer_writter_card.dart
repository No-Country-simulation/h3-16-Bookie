import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidgetWritterCard extends StatelessWidget {
  const ShimmerWidgetWritterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final shimmerBaseColor = isDarkmode ? Colors.grey[900]! : Colors.grey[300]!;
    final shimmerHighlightColor =
        isDarkmode ? Colors.grey[800]! : Colors.grey[100]!;
    final containerShimmer = isDarkmode ? Colors.black : Colors.white;
    final colors = Theme.of(context).colorScheme;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Título "Escritores"
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Escritores",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colors.primary,
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            // Tamaño del slider
            height: 130, // Altura del slider
            child: Swiper(
                itemCount: 8,
                loop: true,
                autoplay: true,
                autoplayDelay: 3000,
                viewportFraction: 0.25,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Imagen del card con Shimmer (loader)
                        Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              color: containerShimmer,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ]));
  }
}
