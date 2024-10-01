
class CartItem {
  final String id;
  final String productId;
  final int quantity;
  final int size;
  final int totalproductprice;
  final String image;
  final String title;

  CartItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.size,
    required this.totalproductprice,
    required this.image,
    required this.title,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      productId: json['product'],
      quantity: json['quantity'],
      size: json['size'],
      totalproductprice:json['totalproductprice'],
      image: json['image'],
      title: json['title'],
    );
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> products;
  final double totalPrice;

  Cart({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List;
    List<CartItem> productList = productsFromJson.map((item) => CartItem.fromJson(item)).toList();

    return Cart(
      id: json['_id'],
      userId: json['user'],
      products: productList,
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}
