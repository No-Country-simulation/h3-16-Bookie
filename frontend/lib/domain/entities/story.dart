// import 'package:bookie/domain/entities/genre.dart';

class Story {
  final int id;
  final String title;
  final String synopsis;
  // final GenreLiterary genre;
  final bool publish;
  final String img;

  Story({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.publish,
    required this.img,
    // required this.genre,
  });
}
