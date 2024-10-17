import 'package:flutter/material.dart';
import 'package:login_page/providers/cart_provider.dart';
import 'package:login_page/widgets/products_list.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  bool isBannerVisible = true;

  List<Widget> pages = [const ProductList(), CartPage()];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: Stack(
      children: [
        IndexedStack(
          index: currentPage,
          children: pages,
        ),
        if (isBannerVisible)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.blueAccent, // Background color
            padding: EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Limited Time Offer: 20% Off!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action when button is pressed
                  },
                  child: const Text("Shop Now"),
                ),
                IconButton(onPressed: () {setState(() {
                  isBannerVisible=false;
                });}, icon: const Icon(Icons.close))
              ],
            ),
          ),
        ),
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
            if (value == 1) {
              // Fetch cart data when switching to the cart page
              Provider.of<CartProvider>(context, listen: false).fetchCart();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping Cart',

          ),
        ],
      ),
    );
  }
}
