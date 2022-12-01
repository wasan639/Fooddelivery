import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.amber.shade800;
  Color primaryColor = Colors.amber;


  // Widget iconShowCart(BuildContext context) {
  //   return IconButton(
  //     icon: Icon(Icons.add_shopping_cart),
  //     onPressed: () {
  //       MaterialPageRoute route = MaterialPageRoute(
  //         builder: (context) => ShowCart(),
  //       );
  //       Navigator.push(context, route);
  //     },
  //   );
  // }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  
  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.amber.shade800,
          fontWeight: FontWeight.bold,
        ),
      );

  Text showTitleH2(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.amber.shade800,
          fontWeight: FontWeight.bold,
        ),
    );

  Container showLogo() {
    return Container(
      width: 180.0,
      child: Image.asset('images/bunny.png'),
    );
  }

  BoxDecoration myBoxDecoration(String nameImage) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$nameImage'),
        fit: BoxFit.cover,
      ),
    );
  }




  MyStyle();
}
