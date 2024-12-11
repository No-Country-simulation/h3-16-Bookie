import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:geolocator/geolocator.dart';

class GetSortedStories {
  final List<Story> stories;
  final Position currentPosition;

  GetSortedStories({required this.stories, required this.currentPosition});
}

Future<GetSortedStories> getSortedStories(List<Story> stories) async {
  try {
    // Obtener la posición actual
    final currentPosition = await determinePosition();
    
    for (int i = 0; i < stories.length; i++) {
      final story = stories[i];
      final distance = distanceFromGeolocator(
        currentPosition,
        story.chapters[0].latitude,
        story.chapters[0].longitude,
      );
      stories[i].distance = distance.toInt();
    }
    // Ordenar las historias por distancia
    stories.sort((a, b) => a.distance.compareTo(b.distance));
    return GetSortedStories(stories: stories, currentPosition: currentPosition);
    // }
  } catch (e) {
    final currentPosition = await determinePosition();

    return GetSortedStories(stories: stories, currentPosition: currentPosition);
  }
}
