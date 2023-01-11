import 'package:flutter/material.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/widget/about_shop.dart';
import 'package:rabbitfood/widget/show_menu_food.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel userModel;
  const ShowShopFoodMenu({super.key, required this.userModel});

  @override
  State<ShowShopFoodMenu> createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel? userModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(userModel: userModel!));
    listWidgets.add(ShowMenuFood(userModel: userModel!));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: ('รายละเอียดร้านอาหาร'),
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: ('เมนูอาหาร'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MyStyle().iconShowCart(context),
        ],
        title: Text('${userModel?.nameShop}'),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBer(),
    );
  }

  BottomNavigationBar showBottonNavigationBer() => BottomNavigationBar(
        backgroundColor: Colors.amber.shade500,
        selectedItemColor: Colors.white,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuFoodNav(),
        ],
      );
}
