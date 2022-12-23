import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/signout_process.dart';
import 'package:rabbitfood/widget/show_list_shop_all.dart';
import 'package:rabbitfood/widget/show_status_food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  const MainUser({super.key});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String? nameUser;
  Widget? currentWidget;

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? 'Main User' : '$nameUser login'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              showHead(),
              menuListShop(),
              //menuCart(),
              menuStatusFoodOrder(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              menuSignOut(),
            ],
          ),
        ],
      ),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(Icons.exit_to_app),
        title: Text('Sing Out'),
        subtitle: Text('Sign Out และ กลับไป หน้าแรก'),
      ),
    );
  }

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          currentWidget = ShowListShopAll();
        });
      },
      leading: Icon(Icons.home),
      title: Text('แสดงร้านค้า'),
      subtitle: Text('แสดงร้านค้าที่สามารถสั่งอาหารได้'),
    );
  }

  ListTile menuStatusFoodOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          currentWidget = ShowStatusFoodOrder();
        });
      },
      leading: Icon(Icons.restaurant_menu),
      title: Text('แสดงรายการอาหารที่สั่ง'),
      subtitle: Text('แสดงรายการอาหารที่สั่งและยังไม่ได้รับ'),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser ?? 'Name Login',
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // Widget menuSignOut() {
  //   return Container(
  //     decoration: BoxDecoration(color: Colors.red.shade700),
  //     child: ListTile(
  //       onTap: () => signOutProcess(context),
  //       leading: Icon(
  //         Icons.exit_to_app,
  //         color: Colors.white,
  //       ),
  //       title: Text(
  //         'Sign Out',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       subtitle: Text(
  //         'การออกจากแอพ',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

}
