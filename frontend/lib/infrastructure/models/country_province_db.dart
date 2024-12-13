class CountryProvinceDb {
  final int id;
  final String name;
  final List<ProvinceDb> provinces;

  CountryProvinceDb({
    required this.id,
    required this.name,
    required this.provinces,
  });

  factory CountryProvinceDb.fromJson(Map<String, dynamic> json) =>
      CountryProvinceDb(
        id: json["id"],
        name: json["name"],
        provinces: List<ProvinceDb>.from(
            json["provinces"].map((x) => ProvinceDb.fromJson(x))),
      );

  static List<CountryProvinceDb> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CountryProvinceDb.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "provinces": List<dynamic>.from(provinces.map((x) => x.toJson())),
      };
}

class ProvinceDb {
  final int id;
  final String name;

  ProvinceDb({
    required this.id,
    required this.name,
  });

  factory ProvinceDb.fromJson(Map<String, dynamic> json) => ProvinceDb(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
