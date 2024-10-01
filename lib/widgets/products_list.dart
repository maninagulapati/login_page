import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_page/pages/product_details_page.dart';
import 'package:login_page/services/api_service.dart';
import 'package:login_page/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductList extends StatefulWidget {
  const ProductList({super.key});
  

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  final List<String> filters = const ['All', 'Adidas', 'Nike', 'Reebok'];
  late String selectedFilter = filters[0];
  List<Map<String, dynamic>> products = []; // Store fetched products
  bool isLoading = true;
  String searchQuery='';
  final apiService= ApiService();

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await apiService.getRequest('http://localhost:3000/api/products/listproducts');

      if (response.statusCode == 200) {
        // Decode and set products
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> data = responseData['data'];

        setState(() {
          products = data
              .map((product) => product as Map<String, dynamic>)
              .toList();
          isLoading = false; // Stop showing loading spinner
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching products: $e');
    }
  }

   List<Map<String, dynamic>> getFilteredProducts() {
    return products.where((product) {
      final matchesFilter =
          selectedFilter == 'All' || product['company'] == selectedFilter;
      final matchesSearch =
          product['title'].toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
     final isMobile=screenWidth<650;
     final filteredProducts=getFilteredProducts();

    const border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
    );

    final shoesCollectionText = Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Text(
      'Shoes\nCollection',
      style: Theme.of(context).textTheme.titleLarge,
    ),
  ),
);

var searchField = Expanded(
      flex: 1,
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value; // Update search query
          });
        },
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );


final addProductButton = Expanded(
  flex: 1,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50.0),
    child: TextButton(
      onPressed: () {
        Navigator.pushNamed(context, 'addproduct');
      },
      child: const Text('Add Product'),
    ),
  ),
);

final logoutButton = Expanded(
      child: TextButton(
          onPressed: () async {
            final storage = FlutterSecureStorage();

            await storage.delete(key: 'token');

            Navigator.pushNamed(context, 'logout');
          },
          child: const Text('Logout')),
    );

    return SafeArea(
      child: Column(
        children: [
          isMobile
      ? Column(
          children: [
            Row(
              children: [
                shoesCollectionText, // First widget on one row
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                searchField,
                addProductButton,
              ],
            ),
          ],
        )
      : Row(
          children: [
            shoesCollectionText,
            searchField,
            addProductButton,
            logoutButton,
          ],
        ),
          
          SizedBox(
            height: 120,
            child: ListView.builder(
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final filter = filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Chip(
                      backgroundColor: selectedFilter == filter
                          ? Theme.of(context).colorScheme.primary
                          : const Color.fromRGBO(245, 247, 249, 1),
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(filter),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1080) {
                        return GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.75,
                          ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailsPage(
                                          product: product);
                                    },
                                  ),
                                );
                              },
                              child: ProductCard(
                                id:product['_id'] as String,
                                title: product['title'] as String,
                                price: product['price'] != null
                                    ? product['price'].toDouble()
                                    : 0.0,
                                image: product['image'] as String,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProductDetailsPage(
                                          product: product);
                                    },
                                  ),
                                );
                              },
                              child: ProductCard(
                                id: product['_id'] as String,
                                title: product['title'] as String,
                                price: product['price'] != null
                                    ? product['price'].toDouble()
                                    : 0.0,
                                image: product['image'] as String,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
