import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   return _HomeCard();
  }
}

class _HomeCard extends State<HomeCard>{
  bool liked =false;
  int count=0;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          liked = !liked;
          count++;
        });
      },
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 220),
            Text("Home Page",style:TextStyle(color: Colors.black) ,),
            Icon(Icons.favorite,color: liked ? Colors.red : Colors.grey,size: 40,),
            Text("$count likes",style: TextStyle(fontSize: 22),)
          ],
        ),
      ),
    );
  }
}