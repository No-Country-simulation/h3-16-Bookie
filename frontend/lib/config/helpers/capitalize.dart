String capitalizeFirstWord(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String capitalizeAllWords(String input) {
  return input
      .toLowerCase()
      .split(' ')
      .map((word) =>
          word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
      .join(' ');
}
