import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class CardChapterMap extends StatefulWidget {
  final String title;
  final int index;
  final double latitude;
  final double longitude;
  final int storyId;

  const CardChapterMap({
    super.key,
    required this.title,
    required this.index,
    required this.latitude,
    required this.longitude,
    required this.storyId,
  });

  @override
  State<CardChapterMap> createState() => CardChapterMapState();
}

class CardChapterMapState extends State<CardChapterMap> {
  late Future<bool> isBlocked;
  bool enableGoToMapOrChapter = false;

  @override
  void initState() {
    super.initState();
    calculateBlockedStatus();
  }

  void calculateBlockedStatus() {
    setState(() {
      enableGoToMapOrChapter = false;
    });
    if (mounted) {
      setState(() {
        isBlocked = isBlockedFuture(widget.latitude, widget.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkmode ? Colors.black54 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          if (enableGoToMapOrChapter) {
            // Acción para navegar a la historia
            // context
            isBlocked.then((value) {
              if (!value) {
                // es decir si esta desbloqueado
                context
                    .push('/chapters/view/${widget.storyId}/${widget.index}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text("Tienes que estar cerca para ver el capítulo"),
                    duration: Duration(seconds: 1),
                    backgroundColor: colors.primary,
                  ),
                );
              }
            });
          } else {
            // Mostrar Tooltip si no está habilitado aún
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Espera un momento, estamos calculando la ubicación..."),
                duration: Duration(seconds: 1),
                backgroundColor: colors.primary,
              ),
            );
          }
        },
        splashColor: colors.primary.withAlpha(30),
        highlightColor: colors.primary.withAlpha(50),
        child: SizedBox(
          width: double.infinity,
          height: 160,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://picsum.photos/seed/chapter${widget.index + 1}/100',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                            Text(
                              'Capítulo ${widget.index + 1}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: FutureBuilder<bool>(
                    future: isBlocked,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SpinKitFadingCircle(
                          color: Colors.grey,
                          size: 25.0,
                        );
                      } else if (snapshot.hasError) {
                        return const SizedBox();
                      } else {
                        final isBlockedValue = snapshot.data ?? false;

                        isBlocked.then((value) {
                          if (mounted) {
                            // Verifica si el widget sigue montado
                            setState(() {
                              enableGoToMapOrChapter = true;
                            });
                          }
                        });

                        return Icon(
                          isBlockedValue ? Icons.lock : Icons.lock_open,
                          color: isBlockedValue ? Colors.red : Colors.green,
                          size: 24,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: -10,
                  right: -12,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      backgroundColor:
                          isDarkmode ? Colors.black38 : Colors.white,
                    ),
                    icon: Icon(
                      Icons.sync,
                      color: colors.primary,
                      size: 18,
                    ),
                    onPressed: () {
                      calculateBlockedStatus(); // Llamada para refrescar el estado
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
