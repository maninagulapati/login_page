import 'package:flutter/material.dart';
import 'package:login_page/models/cart_model.dart';
import 'package:login_page/models/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CartProvider with ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;

  // Fetch the cart data
  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(
        Uri.parse('http://localhost:3000/api/cart/listcart?userId=$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] != null) {
        Cart cart = Cart.fromJson(jsonResponse['data']);

        for (var cartItem in cart.products) {
          // Fetch product details for each cart item
          cartItem.productDetails =
              await fetchProductDetails(cartItem.productId);
        }

        _cart = cart;
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load cart data');
      }
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/api/products/getproduct?productId=$productId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return Product.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to fetch product details');
    }
  }

  Future<void> deleteFromCart(cartid,productid) async{
    
    
      final response= await http.delete(
        Uri.parse('http://localhost:3000/api/cart/deletecartitem?cartId=$cartid&cartproductId=$productid'),
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        cart?.products.removeWhere((item) => item.productId == productid);
        notifyListeners();
      } else {
        throw Exception('Failed to delete product from cart');
      }
    
   
  }
}
