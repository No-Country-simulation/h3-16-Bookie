import 'dart:math';

import 'package:dio/dio.dart';

class ImageGenderPerson {
  static final dio = Dio();

  static String getGenderFromNameWritter(String name) {
    return detectGenderByRules(name);
  }

  static Future<String> getImageFromNameWritter(String name) async {
    try {
      final gender = getGenderFromNameWritter(name);
      final randomNumber = _randomNumber();
      final imageUrl =
          "https://randomuser.me/api/portraits/$gender/$randomNumber.jpg";

      // Verificar si la imagen existe
      final exists = await _imageExists(imageUrl);

      if (exists) {
        return imageUrl;
      } else {
        // Si la imagen no existe, usar la URL fallback
        return gender == "men"
            ? 'https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/etq9mpgi2uf7wuhe3w6y.webp'
            : "https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/oirnznnu2cnppqjmgn6o.webp"; // Aquí pones tu URL de fallback
      }
    } catch (e) {
      // URL de fallback si ocurre algún error
      final randomNumber = _randomNumber();

      return randomNumber % 2 == 0
          ? 'https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/eiwptc2xepcddfjaavqo.webp'
          : "https://res.cloudinary.com/dlixnwuhi/image/upload/v1733600879/hftmkuofspsvwiqtzbe1.webp";
    }
  }

  // Método para verificar si la imagen existe usando HEAD request
  static Future<bool> _imageExists(String url) async {
    try {
      final response = await dio.head(
          url); // Realizamos una petición HEAD para verificar la existencia
      return response.statusCode ==
          200; // Si el código de estado es 200, la imagen existe
    } catch (e) {
      return false; // Si ocurre un error, asumimos que la imagen no existe
    }
  }

  static int _randomNumber() {
    final random = Random();
    int numeroAleatorio =
        random.nextInt(100); // Genera un número entre 0 y 99 (inclusive)
    return numeroAleatorio;
  }

  static String detectGenderByRules(String name) {
    if (name.endsWith('a')) {
      return 'women';
    } else {
      return 'men';
    }
  }
}
