class ChapterLocalModel {
  final String id;
  final String title;
  final double latitude;
  final double longitude;

  ChapterLocalModel(
      {required this.id,
      required this.title,
      required this.latitude,
      required this.longitude});

  // You might need a fromJson method depending on the rest of your code
  factory ChapterLocalModel.fromJson(Map<String, dynamic> json) {
    return ChapterLocalModel(
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
