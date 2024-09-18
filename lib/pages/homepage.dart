import 'package:flutter/material.dart';
import 'package:login_page/pages/cart_page.dart';
import 'package:login_page/widgets/products_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int currentPage=0;

 List<Widget> pages=const [ProductList(),CartPage()];

  @override
  Widget build(BuildContext context) {
    
    // print(Provider.of<CartProvider>(context).cart);
    return Scaffold(
        body: IndexedStack(
          index: currentPage,
          children: pages,
        ),
    bottomNavigationBar: BottomNavigationBar(
      iconSize: 35,
      // selectedFontSize: 0,
      // unselectedFontSize: 0,
      currentIndex: currentPage,
      onTap: (value) {
        setState(() {
          currentPage = value;
        });
      } ,
      items: const [
      BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: "Shopping Cart",
    ),
    ]
    ),
    );
        
  }
}
