class Chapter {
  final int id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool publish;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.publish,
  });
}
