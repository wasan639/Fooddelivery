import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListFoodMenuShop extends StatefulWidget {
  const ListFoodMenuShop({super.key});

  @override
  State<ListFoodMenuShop> createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  @override
  Widget build(BuildContext context) {
    return Text('รายการอาหารของร้าน');
  }
}