import 'package:bookie/domain/entities/genre.dart';

class History {
  final String id;
  final String title;
  final String synopsis;
  final GenreLiterary genre;
  final bool publish;
  final String img;

  History({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.publish,
    required this.img,
    required this.genre,
  });
}
