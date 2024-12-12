class User {
  final int id;
  final String name;
  final String? imageUrl;
  // final List<dynamic> wishlist;

  User({
    required this.id,
    required this.name,
    this.imageUrl,
    // required this.wishlist,
  });

  User copyWith({
    int? id,
    String? name,
    String? imageUrl,
    // List<dynamic>? wishlist,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      // wishlist: wishlist ?? this.wishlist,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, imageUrl: $imageUrl}';
  }
}
