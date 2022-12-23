import 'package:flutter/material.dart';
import 'package:rabbitfood/model/user_model.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel usermodel;
  const ShowShopFoodMenu({super.key, required this.usermodel});

  @override
  State<ShowShopFoodMenu> createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.usermodel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${userModel?.nameShop}'),
      ),
    );
  }
}
