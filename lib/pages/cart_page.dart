import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_page/providers/cart_provider.dart';
import 'package:provider/provider.dart'; 

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    super.initState();

    // Fetch the cart after the widget is initialized
    Future.microtask(
        () => Provider.of<CartProvider>(context, listen: false).fetchCart());
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cartProvider.cart == null) {
      return Center(child: Text('No cart data available'));
    }

    return ListView.builder(
      itemCount: cartProvider.cart!.products.length,
      itemBuilder: (context, index) {
        final product = cartProvider.cart!.products[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: product.productDetails != null
                ? MemoryImage(
                    base64Decode(product.productDetails!.image),
                  )
                : const AssetImage('assets/images/shoes_1.png'),
            radius: 30,
          ),
          title: Text(product.productDetails!.title,
              style: Theme.of(context).textTheme.bodySmall),
          subtitle: Row(
            children: [
              Text('Size: ${product.size.toString()}'),
              const SizedBox(width: 10),
              Text('Quantity: ${product.quantity.toString()}')
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '\$${product.totalproductprice}', // Display product price
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete Item',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        content: const Text(
                            'Are you sure you want to remove this item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // context.read<CartProvider>().removeFromCart(index);
                              // deleteFromCart(cartProvider.cart!.id,product.id); // Call the deleteFromCart function to delete item from the cart
                              // delete from cartprovider method
                              Provider.of<CartProvider>(context, listen: false)
                                 .deleteFromCart(cartProvider.cart!.id, product.id);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }
}
