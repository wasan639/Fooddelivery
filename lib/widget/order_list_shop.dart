import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  const OrderListShop({super.key});

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Text('แสดงรายการอาหารที่สั่ง');
  }
}