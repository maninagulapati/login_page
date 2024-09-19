import 'dart:convert'; // For base64 decoding
import 'package:flutter/material.dart';
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
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.product['sizes'] as List<dynamic>).length,
                    itemBuilder: (context, index) {
                      final size = (widget.product['sizes'] as List<dynamic>)[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
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
                        ),
                      );
                    },
                  ),
                ),
                // Add to Cart button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (selectedSize != 0) {
                        // Add product to cart
                        Provider.of<CartProvider>(context, listen: false).addToCart({
                          'id': widget.product['_id'], // Use '_id' from product data
                          'title': widget.product['title'],
                          'price': widget.product['price'],
                          'imageUrl': widget.product['image'], // Keep image as base64
                          'company': widget.product['company'],
                          'size': selectedSize,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added to Cart')),
                        );
                      } else {
                        // Show error if size not selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
