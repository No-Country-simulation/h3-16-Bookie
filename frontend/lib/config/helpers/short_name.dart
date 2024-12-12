String shortenName(String name) {
  // Dividir el nombre en palabras usando el espacio como delimitador
  List<String> words = name.split(' ');

  // Si el nombre tiene más de 2 palabras, solo tomamos las primeras 2
  if (words.length > 2) {
    words = words.sublist(0, 2);
  }

  // Unir las palabras de nuevo
  String shortenedName = words.join(' ');

  // Si el nombre tiene más de 20 caracteres, lo cortamos a 20
  if (shortenedName.length > 16) {
    shortenedName = shortenedName.substring(0, 16);
  }

  return shortenedName;
}

String shortenName2(String name) {
  // Verificar si la primera palabra está vacía o es nula, y eliminar la coma inicial si es necesario
  if (name.startsWith(',')) {
    name = name
        .substring(1)
        .trim(); // Eliminar la coma inicial y espacios adicionales
  }

  // Dividir el nombre en palabras usando el espacio como delimitador
  List<String> words = name.split(' ');

  // Si el nombre tiene más de 2 palabras, solo tomamos las primeras 2
  if (words.length > 2) {
    words = words.sublist(0, 2);
  }

  // Si el nombre tiene más de 1 palabra, quitar la coma de la última palabra si existe
  if (words.length > 1 && words.last.endsWith(',')) {
    words[1] = words[1].substring(0, words[1].length - 1);
  }

  // Unir las palabras de nuevo
  String shortenedName = words.join(' ');

  // Si el nombre tiene más de 16 caracteres, lo cortamos a 16
  if (shortenedName.length > 14) {
    shortenedName = shortenedName.substring(0, 14);
  }

  return shortenedName;
}

String shortName3(String name, {int maxLength = 40}) {
  // Si el nombre tiene más de 30 caracteres, lo cortamos a 30
  if (name.length > maxLength) {
    return '${name.substring(0, maxLength)}...';
  }
  return name;
}
