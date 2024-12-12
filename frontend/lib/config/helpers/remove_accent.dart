String removeAccents(String input) {
  const Map<String, String> accentsMap = {
    'á': 'a',
    'é': 'e',
    'í': 'i',
    'ó': 'o',
    'ú': 'u',
    'Á': 'A',
    'É': 'E',
    'Í': 'I',
    'Ó': 'O',
    'Ú': 'U',
  };

  String output = input;

  for (final entry in accentsMap.entries) {
    output = output.replaceAll(entry.key, entry.value);
  }

  return output;
}