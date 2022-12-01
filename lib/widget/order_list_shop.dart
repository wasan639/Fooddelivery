import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class OrderListShop extends StatefulWidget {
  const OrderListShop({super.key});

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  @override
  Widget build(BuildContext context) {
    return Text('แสดงรายการอาหารที่สั่ง');
  }
}