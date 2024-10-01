import 'package:flutter/material.dart';
import 'package:login_page/models/cart_model.dart';
import 'package:login_page/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CartProvider with ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  final apiService= ApiService();

  // Fetch the cart data
  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await apiService.getRequest('/api/cart/listcart?userId=$userId');


    if (response.statusCode == 200) {
      final jsonResponse = response.data;
      

      if (jsonResponse['data'] != null) {
        Cart cart = Cart.fromJson(jsonResponse['data']);

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

  

  Future<void> deleteFromCart(cartid,productid) async{
    
    
      final response= await apiService.deleteRequest('/api/cart/deletecartitem?cartId=$cartid&cartproductId=$productid',);
      if (response.statusCode == 200) {
        _cart?.products.removeWhere((item) => item.productId == productid);
        await fetchCart();
        notifyListeners();
      } else {
        throw Exception('Failed to delete product from cart');
      }
    
   
  }

  Future <void> updateCart(userid,cartproductid,quantity) async{
    final response = await apiService.patchRequest('/api/cart/addcart',
    {
      "userId":userid,
      "cartProductId":cartproductid,
      "quantity":quantity,
    }
    );
        
        if(response.statusCode==200){
          await fetchCart();
          notifyListeners();
        }
        else{
          throw Exception('Failed to update cart item');
        }

  }
}



