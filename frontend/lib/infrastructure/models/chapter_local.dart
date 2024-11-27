class ChapterLocal {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  ChapterLocal(
      {required this.id,
      required this.title,
      required this.latitude,
      required this.longitude});

  // You might need a fromJson method depending on the rest of your code
  factory ChapterLocal.fromJson(Map<String, dynamic> json) {
    return ChapterLocal(
      id: json['id'],
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // static List<ChapterLocal> fromJsonList(List<dynamic> jsonList) {
  //   return jsonList.map((json) => ChapterLocal.fromJson(json)).toList();
  // }
}
