import 'package:flutter/material.dart';
import 'package:login_page/LoginCard.dart';
import 'package:login_page/Signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                preferredSize:  Size.fromHeight(50),
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
        ));
  }
}