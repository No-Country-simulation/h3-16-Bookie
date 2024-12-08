import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:dio/dio.dart';

// TODO: Solo toma el primer capítulo o todos(ELEGI POR AHORA EL PRIMER CAPITULO, REVISAR PORQUE PODRIA HABER UN CASO QUE UN CAPITULO DE LA HISTORIA ESTE CERCA BUENO PREGUNTAR O REVISAR)
// TBM ELEGI GEOLOCATOR
Future<List<Story>> getSortedStories(List<Story> stories) async {
  try {
    // Obtener la posición actual
    final currentPosition = await determinePosition();

    // final origin = "${currentPosition.latitude},${currentPosition.longitude}";

//     try {
//       // Crear las coordenadas de destino en grupos de 25
//       const maxDestinationsPerRequest = 25;

//       List<String> destinationsGroups = [];
//       for (int i = 0; i < stories.length; i += maxDestinationsPerRequest) {
//         final group = stories
//             .sublist(
//                 i,
//                 i + maxDestinationsPerRequest > stories.length
//                     ? stories.length
//                     : i + maxDestinationsPerRequest)
//             .map((story) =>
//                 "${story.chapters[0].latitude},${story.chapters[0].longitude}")
//             .join('|');
//         destinationsGroups.add(group);
//       }

//       List<int> allDistances = [];

//       // Llamar a la API de Google Maps Distance Matrix para cada grupo

//       for (final destinations in destinationsGroups) {
//         final url =
//             "https://maps.googleapis.csom/maps/api/distancematrix/json?origins=$origin&destinations=$destinations&mode=walking&key=${Environment.theGoogleMapsApiKey}";

//         final response = await Dio().get(url);

//         // Procesar la respuesta de la API
//         final rows = response.data['rows'][0]['elements'];

//         allDistances.addAll(
//           rows.map<int>((element) {
//             if (element['status'] == "OK") {
//               return element['distance']['value']
//                   as int; // Aseguramos que sea int
//             } else {
//               return 9999999; // Asignar un valor grande si hay un error
//             }
//           }).toList(), // Convierte el resultado a List<int>
//         );
//       }

// // TODO REVISAR SI SE TENDRÍA EL GEOLOCATOR O SI SE TENDRÍA QUE SE USAN LOS DATOS DE LA API GOOGLE MAPS
//       // Calcular las distancias desde Geolocator para comparar
//       // final distancesCalculateFromGeolocator = stories
//       //     .map(
//       //       (story) => distanceFromGeolocator(
//       //         currentPosition,
//       //         story.chapters[0].latitude,
//       //         story.chapters[0].longitude,
//       //       ),
//       //     )
//       //     .toList();

//       // Asignar las distancias calculadas a cada historia
//       // TODO REVISAR SI SE TENDRÍA EL GEOLOCATOR O SI SE TENDRÍA QUE SE USAN LOS DATOS DE LA API GOOGLE MAPS
//       for (int i = 0; i < stories.length; i++) {
//         final distanceGoogle = allDistances[i];
//         // final distanceGeolocator = distancesCalculateFromGeolocator[i].toInt();

//         // stories[i].distance = distanceGoogle - distanceGeolocator > 100
//         //     ? distanceGeolocator
//         //     : distanceGoogle;
//         stories[i].distance = distanceGoogle;
//       }

//       // Ordenar las historias por distancia
//       stories.sort((a, b) => a.distance.compareTo(b.distance));

//       return stories;
//     } catch (e) {
    // con geolocator
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
    return stories;
    // }
  } catch (e) {
    print("Error al obtener la posición: $e");
    return stories;
  }
}
