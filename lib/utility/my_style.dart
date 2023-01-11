import 'package:flutter/material.dart';
import 'package:rabbitfood/model/food_model.dart';
import 'package:rabbitfood/screens/show_cart.dart';

class MyStyle {
  Color darkColor = Colors.amber.shade800;
  Color primaryColor = Colors.amber;

  Widget showProgress() {//ให้หน้าแอปหมุนรอการทำงาน
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

  BoxDecoration myBoxDecoration(String nameImage) {//กำหนดขนาดรูปให้เต็ม
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$nameImage'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget showFoodData(String string, double size) {//แสดงข้อมูลรายการอาหาร
    return Row(
      children: [
        Expanded(
          child: Text('${string}',
              style: TextStyle(fontSize: size)),
        ),
      ],
    );
  }

  Widget iconShowCart(BuildContext context){//แสดงไอคอนรถเข็น
    return IconButton(onPressed: () {
      //Navigator.pop(context);
      MaterialPageRoute route = MaterialPageRoute(builder: (context) => ShowCart(),);
      Navigator.push(context, route);
    }, icon: Icon(Icons.add_shopping_cart));
  }

  MyStyle();
}
