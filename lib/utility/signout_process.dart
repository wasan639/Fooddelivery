import 'package:flutter/material.dart';
import 'package:rabbitfood/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async {//ออกจากระบบ
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  // exit(0);

  MaterialPageRoute route = MaterialPageRoute(builder: (context) => Home());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
  
}
