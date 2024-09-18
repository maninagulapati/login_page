import 'package:flutter/material.dart';
import 'package:login_page/pages/product_details_page.dart';
import 'package:login_page/widgets/product_card.dart';
import 'package:login_page/global_variables.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  final List<String> filters=const ['All','Addidas','Nike','Reebok'];
  late String selectedFilter=filters[0];

  @override
  void initState() {
    super.initState();
    selectedFilter=filters[0];
  }

  List<Map<String,Object>> getFilteredProducts() {
    if(selectedFilter=='All'){
      return products;
    }
    return products.where((product) =>
     product['company'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
    );

    final filteredProducts=getFilteredProducts();
    
    return  SafeArea(
      child: Column(
        children: [
           Row(
            children: [
               Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Shoes\nCollection',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
               const Expanded(
                child: TextField(
                    decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                )),
              ),
              
            ],
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                    final filter=filters[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                            onTap: (){
                                setState(() {
                                  selectedFilter=filter;
                                });
  
                            },
                          child: Chip(
                              backgroundColor: selectedFilter==filter? Theme.of(context).colorScheme.primary : Color.fromRGBO(245, 247, 249, 1),
                              side: const BorderSide(
                                  color: Color.fromRGBO(245, 247, 249, 1),
                              ),
                              label: Text(filter),
                              labelStyle:const TextStyle(
                                  fontSize: 16,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15
                                  ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                              ),
                              ),
                        ),
                    );
                },),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context,constraints){
                if(constraints.maxWidth>1080){
                  return GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.75,
                ),
              itemBuilder: (context,index){
                final product = filteredProducts[index];
                return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context){
                              return ProductDetailsPage(product: product);
                            }
                            )
                        );
                      },
                      child: ProductCard(
                        title: product['title'] as String,
                        price: product['price'] as double,
                        image: product['imageUrl'] as String,
                        backgroundColor: index.isEven?const Color.fromRGBO(216, 240, 253, 1):const Color.fromRGBO(245, 247, 249, 1),
                        ),
                    );
              }
              );
                }
                else{
                  return ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context,index){
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context){
                              return ProductDetailsPage(product: product);
                            }
                            )
                        );
                      },
                      child: ProductCard(
                        title: product['title'] as String,
                        price: product['price'] as double,
                        image: product['imageUrl'] as String,
                        backgroundColor: index.isEven?const Color.fromRGBO(216, 240, 253, 1):const Color.fromRGBO(245, 247, 249, 1),
                        ),
                    );
                }) ;
                }
              }),
          )
        
        ],
        
      ),
      
    );
  }
}