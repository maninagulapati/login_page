import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_page/providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart=context.watch<CartProvider>().cart;
    return  Scaffold(
      appBar: AppBar(
        title:const Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context,index){
          final item = cart[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(item['imageUrl'] as String),
              radius: 30,
            ),
            title: Text(item['title'].toString(),
            style: Theme.of(context).textTheme.bodySmall),
            subtitle: Text('Size: ${item["size"].toString()}'),
            trailing: IconButton(
              onPressed: (){
                showDialog(
                  context: context,
                   builder: (context){
                    return AlertDialog(
                      title: Text('Delete Item',
                      style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: const Text('Are you sure you want to remove this item?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<CartProvider>().removeFromCart(index);
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
              icon: const Icon(
                Icons.delete,
                color: Colors.red
                ), 
              ),
           
          );
        },)
    );
  }
}