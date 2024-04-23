class Product {
  String? id;
  String name;
  String description;
  double price;
  int stockQuantity;
  String selectedCategory;
  String selectedUnit;
  double discount;
  String imageUrl;
  int createdAt;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.stockQuantity,
      required this.selectedCategory,
      required this.selectedUnit,
      required this.discount,
      required this.imageUrl,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'description': this.description,
      'price': this.price,
      'stockQuantity': this.stockQuantity,
      'selectedCategory': this.selectedCategory,
      'selectedUnit': this.selectedUnit,
      'discount': this.discount,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
    };
  }

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'] as int,
      selectedCategory: map['selectedCategory'] as String,
      selectedUnit: map['selectedUnit'] as String,
      discount: (map['discount'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
