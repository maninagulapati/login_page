import 'dart:convert'; // For base64 decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_page/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 0;
  int? selectedQuantity = 1;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> addToCart() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/cart/addcart'),
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'userId': userId.toString(),
          'ProductId': widget.product['_id'],
          'quantity': selectedQuantity.toString(),
          'size': selectedSize.toString(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Item added to cart')));
      } else {
        _errorMessage = 'Failed to add item to cart: ${response.body}';
      }
    } on Exception catch (e) {
      _errorMessage = 'Failed to add item to cart: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Column(
        children: [
          // Display product title
          Text(
            widget.product['title'] as String,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          // Display base64 image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.memory(
              base64Decode(widget.product['image'] as String),
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(flex: 2),
          // Container for product details and sizes
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(245, 247, 249, 1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display price
                Text(
                  '\$${widget.product['price']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                // List of available sizes
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (widget.product['sizes'] as List<dynamic>).length,
                        itemBuilder: (context, index) {
                          final size =
                              (widget.product['sizes'] as List<dynamic>)[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize =
                                      int.parse(size); // Parse size to int
                                });
                              },
                              child: Chip(
                                label: Text(size.toString()),
                                backgroundColor: selectedSize == int.parse(size)
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 162,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          items: List.generate(10, (index) => index + 1)
                              .map<DropdownMenuItem<int>>((quantity) {
                            return DropdownMenuItem<int>(
                              value: quantity,
                              child: Text(quantity
                                  .toString()), // Display quantity as text
                            );
                          }).toList(),
                          onChanged: (value) => setState(() {
                            selectedQuantity = value; // Store selected quantity
                          }),
                          value:
                              selectedQuantity, // Set the currently selected quantity
                          hint: Text("Select quantity"), // Optional hint text
                        ),
                      ),
                    ),
                  ],
                ),
                // Add to Cart button
                SizedBox(height: 16.0),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (selectedSize != 0 && selectedQuantity != 0) {
                          // // Add product to cart
                          // Provider.of<CartProvider>(context, listen: false).addToCart({
                          //   'id': widget.product['_id'], // Use '_id' from product data
                          //   'title': widget.product['title'],
                          //   'price': widget.product['price'],
                          //   'imageUrl': widget.product['image'], // Keep image as base64
                          //   'company': widget.product['company'],
                          //   'size': selectedSize,
                          // });
                          //Add to cart using api
                          addToCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                duration: Duration(milliseconds: 1000),
                                content: Text('Product added to Cart')),
                          );
                        } else {
                          // Show error if size not selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 1000),
                              content: Text('Please select a size'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.shopping_cart),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        fixedSize: const Size(350, 50),
                      ),
                      label: const Text(
                        'Add To Cart',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Error message if adding to cart fails
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
