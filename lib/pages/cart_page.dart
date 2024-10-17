import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_page/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<int, int?> selectedQuantities = {}; 
  int? selectedQuantity;
  @override
  void initState() {
    super.initState();

    // Fetch the cart after the widget is initialized
    Future.microtask(
        () => Provider.of<CartProvider>(context, listen: false).fetchCart());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cartProvider.cart == null) {
      return const Center(child: Text('No cart data available'));
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Shopping Cart',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cartProvider.cart!.products.length,
          itemBuilder: (context, index) {
            final product = cartProvider.cart!.products[index];
            return SingleChildScrollView(
              scrollDirection: screenWidth < 350 ? Axis.horizontal : Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth,
                  maxWidth: screenWidth < 350 ? screenWidth * 1.2 : screenWidth, // Flexibility for small screens
                ),
                child: IntrinsicWidth(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(254, 206, 1, 1),
                      backgroundImage: product.image != null
                          ? MemoryImage(
                              base64Decode(product.image),
                            )
                          : const AssetImage('assets/images/shoes_1.png'),
                      radius: 30,
                    ),
                    title: Text(product.title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: screenWidth<450? screenWidth * 0.035: null, // Responsive font size
                    ),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${product.size.toString()}'),
                        const SizedBox(height: 10),
                        
                        Row(
                          children: [
                            const Text('Qty: '),
                            Expanded(
                              child: Wrap(
                                children: [
                                Container(
                                  width: screenWidth < 300 ? 60 : screenWidth<400?70: 50, // Adjust the width as needed
                                  height: 30,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color for the dropdown
                                    borderRadius: BorderRadius.circular(8), // Rounded corners for a material look
                                    border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1), // Border style
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      initialValue: selectedQuantities[index]?.toString() ??
                                          product.quantity.toString(),
                                      keyboardType: TextInputType.number, // Number input type
                                      decoration: const InputDecoration(
                                        hintText: 'Enter quantity',
                                        border: InputBorder.none, // Removes the default border
                                        contentPadding: EdgeInsets
                                            .symmetric(horizontal: 6,vertical: 12), // Adjust padding inside the input field
                                        // suffixIcon: Icon(
                                        //   Icons.edit,
                                        //   color: Colors.grey, // Custom icon similar to dropdown arrow
                                        // ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16, // Adjust text size
                                      ),
                                      onChanged: (value) {
                                        final newQuantity = int.tryParse(value);
                                        setState(() {
                                          selectedQuantities[index] = newQuantity ;// Update selectedQuantity on change
                                        });
                                        if(newQuantity!=null){
                                          // Update quantity in the cart
                                          Provider.of<CartProvider>(context, listen: false)
                                             .updateCart(cartProvider.cart!.userId, product.id,
                                                              newQuantity);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${product.totalproductprice}', // Display product price
                          style: Theme.of(context).textTheme.bodyLarge,
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
                                        // delete from cartprovider method
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .deleteFromCart(
                                                cartProvider.cart!.id, product.id);
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Padding(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.1, // Adjust padding based on screen size
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns content to the right
    children: [
      Text(
        'Total Price',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: screenWidth<450? screenWidth * 0.035: null, // Responsive font size
            ),
      ),
      Text(
        '\$${cartProvider.cart!.totalPrice}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: screenWidth<450? screenWidth * 0.035: null, // Responsive font size
            ),
      ),
    ],
  ),
),
ElevatedButton.icon(onPressed:(){
  Navigator.pushNamed(context, 'checkout');
},icon:Icon(Icons.paypal),
label: Text('Checkout')
)

    ]);
  }
}
