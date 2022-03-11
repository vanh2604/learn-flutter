class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  Product(this.id, this.name, this.description, this.price, this.image);
  static final columns = ["id", "name", "description", "price", "image"];

  factory Product.fromMap(Map<dynamic, dynamic> json) {
    return Product(
      json['id'],
      json['name'],
      json['description'],
      json['price'],
      json['image'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
