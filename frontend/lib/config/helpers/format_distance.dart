String formatDistance(int distance) {
  if (distance > 100000) {
    return "Más de 100 km"; // Si la distancia es mayor a 500km
  }

  return "Distancia: ${distance <= 500 ? "${distance.toStringAsFixed(1)}m" // Redondear a un decimal si es en metros
      : "${(distance / 1000).toStringAsFixed(1)}km"}"; // Redondear a un decimal si es en kilómetros
}

String formatDistanceOnly(int distance) {
  if (distance > 100000) {
    return "Más de 100 km"; // Si la distancia es mayor a 500km
  }

  return distance <= 500
      ? "${distance.toStringAsFixed(1)}m"
      : "${(distance / 1000).toStringAsFixed(1)}km";
}
