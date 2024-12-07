class UserDb {
  final int id;
  final String name;
  final String email;
  final String auth0UserId;
  final List<dynamic> wishlist;

  UserDb({
    required this.id,
    required this.name,
    required this.email,
    required this.auth0UserId,
    required this.wishlist,
  });

  factory UserDb.fromJson(Map<String, dynamic> json) => UserDb(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        auth0UserId: json["auth0UserId"],
        wishlist: List<dynamic>.from(json["wishlist"].map((x) => x)),
      );

  static List<UserDb> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UserDb.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "auth0UserId": auth0UserId,
        "wishlist": List<dynamic>.from(wishlist.map((x) => x)),
      };
}
