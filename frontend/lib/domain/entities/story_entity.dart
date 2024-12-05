// import 'package:bookie/domain/entities/genre.dart';

import 'package:bookie/domain/entities/chapter_entity.dart';
// import 'package:bookie/domain/entities/chapter_local.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/user_entity.dart';

class Story {
  final int id;
  final String title;
  final String synopsis;
  final Genre genre;
  final bool publish;
  final String imageUrl;
  late final int
      distance; // TODO distancia dinamica no viene de la API BACKEND DEPLOY, REVISAR SI ESTO SE TENDRIA QUE COLOCAR AQUI O CAMBIAR

  // final bool
  //     isFavorite; // TODO: ESTO SE VA POSIBLEMENTE SE QUITE PORQUE SE TRAERA O SE REALIZARA DE OTRA MANERA PARA TRAERSE LOS FAVORITOS, POR AHORA ES SOLO PARA SIMULAR

  final List<ChapterPartial> chapters;
  String? country;
  String? province;
  User? writer;

  Story({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.publish,
    // required this.isFavorite, // TODO POSIBLEMENTE SE QUITE
    required this.imageUrl,
    required this.distance,
    required this.genre,
    required this.chapters,
    this.country,
    this.province,
    this.writer,
  });
}

// se hizo una nueva clase para no traerse informacion innecesaria de la homepage
// class Stories {
//   final int id;
//   final String title;
//   final String synopsis;
//   final Genre genre;
//   final bool publish;
//   final String imageUrl;
//   // final bool isFavorite;
//   final List<ChapterForStoryAll> chapters;
//   late final int distance;

//   // TODO FALTA PARA EL FILTADO POR PAIS O PROVINCIA , SERA DE REVISAR SI ES AQUI O EN OTRO ENTITY, IGUAL ESTE SE NECESITARA PARA MOSTRAR TODOS, REVISARRR

//   Stories({
//     required this.id,
//     required this.title,
//     required this.synopsis,
//     required this.genre,
//     required this.publish,
//     // required this.isFavorite,
//     required this.imageUrl,
//     required this.chapters,
//     required this.distance,
//   });
// }

class StoryForm {
  final String title;
  final String synopsis;
  final String genre;
  final int creatorId;
  final String? image;
  final String country;
  final String province;

  StoryForm({
    required this.title,
    required this.synopsis,
    required this.genre,
    required this.creatorId,
    required this.country,
    required this.province,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "synopsis": synopsis,
      "creator_id": creatorId,
      "genre": genre,
      "img": image,
      "country": country,
      "province": province,
    };
  }
}
