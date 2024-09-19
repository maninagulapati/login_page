import 'package:flutter/material.dart';
import 'package:login_page/Signup.dart';
import 'package:login_page/pages/add_product.dart';
import 'package:login_page/widgets/LoginCard.dart';
import 'package:login_page/pages/homepage.dart';
import 'package:login_page/providers/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>CartProvider())
      ],
      child: MaterialApp(
        routes: {
          'home': (context) => HomePage(),
          'addproduct':(context)=> AddProductPage(),
        },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(254, 206, 1, 1),
            primary: const Color.fromRGBO(254, 206, 1, 1),
            ),
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
               fontSize: 35
               ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            bodySmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
          ),
          useMaterial3: true,
        ),
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
               title: Center(
              child: Container(
                width: 150, 
                child: Text('Login & Signup'),
              ),
            ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                   child: Center(
                    child: Container(
                      width: 450,
                      child: TabBar(tabs: const[
                        Tab(text: 'Login'),
                        Tab(text: "Signp",)
                      ]),
                    ),
                   )
                   )
              ),
              body: TabBarView(
                children: [
                LoginCard(),
                SignupCard(),
              ]),
            ),
          )),
    );
  }
}