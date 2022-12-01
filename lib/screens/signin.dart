import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/screens/main_rider.dart';
import 'package:rabbitfood/screens/main_shop.dart';
import 'package:rabbitfood/screens/main_user.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
   // Field
  String user ='';
  String password ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[Colors.white, MyStyle().primaryColor],
            center: Alignment(0, -0.3),
            radius: 2.0,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                MyStyle().showLogo(),
                SizedBox(height: 15.0),
                MyStyle().showTitle('RABBIT FOOD',),
                SizedBox(height: 15.0),
                userForm(),
                SizedBox(height: 15.0),
                passwordForm(),
                SizedBox(height: 15.0),
                loginButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton() => Container(
        width: 250.0,
        height: 50.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.amber,),
          onPressed: () {
            if (user == null || user.isEmpty ||
                password == null || password.isEmpty) {
              normalDialog(context, 'มีช่องว่างเกิดขึ้นกรุณากรอกข้อมูลของคุณให้ครบ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white,fontSize: 22.0),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url ='http://192.168.1.107/rabbitfood/getUser.php?isAdd=true&User=$user';
    print('url ===>> $url');
    
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');

      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeTuService(MainUser(), userModel);
          } else if (chooseType == 'Shop') {
            routeTuService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            routeTuService(MainRider(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'รหัสผ่านไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง ');
        }
      }
    } catch (e) {
      print('Have e Error ===>> ${e.toString()}');
    }
  }


  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
     preferences.setString('id', userModel.id.toString());
     preferences.setString('ChooseType', userModel.chooseType.toString());
     preferences.setString('Name', userModel.name.toString());

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'User :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade400)),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().darkColor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkColor),
            labelText: 'Password :',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:  Colors.blue.shade400)),
          ),
        ),
      );
}