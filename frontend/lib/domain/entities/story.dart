// import 'package:bookie/domain/entities/genre.dart';

import 'package:bookie/domain/entities/chapter.dart';

class Story {
  final int id;
  final String title;
  final String synopsis;
  // final GenreLiterary genre;
  final bool publish;
  final String imageUrl;
  int distance; // TODO distancia dinamica no viene de la API BACKEND DEPLOY, REVISAR SI ESTO SE TENDRIA QUE COLOCAR AQUI O CAMBIAR

  final bool
      isFavorite; // TODO: ESTO SE VA POSIBLEMENTE SE QUITE PORQUE SE TRAERA O SE REALIZARA DE OTRA MANERA PARA TRAERSE LOS FAVORITOS, POR AHORA ES SOLO PARA SIMULAR

  final List<Chapter>?
      chapters; // TODO: ESTO TBM PUEDE CAMBIAR POSIBLEMENTE SE QUITE

  Story({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.publish,
    required this.isFavorite, // TODO POSIBLEMENTE SE QUITE
    required this.imageUrl,
    required this.distance,
    this.chapters, // TODO POSIBLEMENTE SE QUITE
    // required this.genre,
  });
}
