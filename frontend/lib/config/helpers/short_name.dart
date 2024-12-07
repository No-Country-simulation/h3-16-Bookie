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
  if (shortenedName.length > 20) {
    shortenedName = shortenedName.substring(0, 20);
  }

  return shortenedName;
}
