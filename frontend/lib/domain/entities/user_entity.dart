class User {
  final int id;
  final String name;
  final String? imageUrl;
  final bool? isWriter;
  // final List<dynamic> wishlist;

  User({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isWriter,
    // required this.wishlist,
  });

  User copyWith({
    int? id,
    String? name,
    String? imageUrl,
    bool? isWriter,
    // List<dynamic>? wishlist,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isWriter: isWriter ?? this.isWriter,
      // wishlist: wishlist ?? this.wishlist,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, imageUrl: $imageUrl}';
  }
}
