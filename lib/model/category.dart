class Category {
  String? id;
  String name;
  String description;
  String imageUrl;
  int createdAt;

  Category(
      {required this.id,
        required this.name,
        required this.description,
        required this.imageUrl,
        required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
    };
  }

  factory Category.fromMap(Map<dynamic, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
