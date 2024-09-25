class Product {
  final String id;
  final String title;
  final int price;
  final String image;
  final String company;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.company,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      price: json['price'],
      image: json['image'],
      company: json['company'],
    );
  }
}