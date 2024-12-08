String extractName(String input) {
  // Verifica si la palabra contiene '@'
  if (input.contains('@')) {
    // Divide la palabra por '@' y devuelve la primera parte
    return input.split('@').first;
  }
  // Si no contiene '@', devuelve el input tal cual
  return input;
}