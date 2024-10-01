import 'dart:convert'; // For base64 decoding
import 'package:flutter/material.dart';
import 'package:login_page/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

    final apiService= ApiService();

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      final response = await apiService.postRequest('/api/cart/addcart',
        {
          'userId': userId.toString(),
          'ProductId': widget.product['_id'],
          'quantity': selectedQuantity.toString(),
          'size': selectedSize.toString(),
        }
        
      );

      if (response!=null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Item added to cart')
          ));
      } else {
        _errorMessage = 'Failed to add item to cart';
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
                Wrap(
  alignment: WrapAlignment.start,
  crossAxisAlignment: WrapCrossAlignment.center,
  spacing: 8.0, // Spacing between the Chip and Dropdown
  runSpacing: 8.0, // Spacing between rows when content wraps
  children: [
    // Wrap for Sizes (Chips)
    Wrap(
      spacing: 8.0, // Spacing between chips
      children: (widget.product['sizes'] as List<dynamic>)
          .map<Widget>((size) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedSize = int.parse(size); // Parse size to int
                  });
                },
                child: Chip(
                  label: Text(size.toString()),
                  backgroundColor: selectedSize == int.parse(size)
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
              ))
          .toList(),
    ),
    // Dropdown for Quantity
    Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the dropdown
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ), // Border styling
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: false, // Expand only to fit the selected item
          items: List.generate(10, (index) => index + 1)
              .map<DropdownMenuItem<int>>((quantity) {
            return DropdownMenuItem<int>(
              value: quantity,
              child: Text(
                quantity.toString(),
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            selectedQuantity = value; // Update the selected value
          }),
          value: selectedQuantity,
          hint: const Text(
            "Select quantity",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ), // Custom dropdown icon
          dropdownColor: Colors.white,
          style: TextStyle(color: Colors.black),
        ),
      ),
    ),
  ],
)
,
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
