import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/model/order_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowStatusFoodOrder extends StatefulWidget {
  const ShowStatusFoodOrder({super.key});

  @override
  State<ShowStatusFoodOrder> createState() => _ShowStatusFoodOrderState();
}

class _ShowStatusFoodOrderState extends State<ShowStatusFoodOrder> {
  String? idUser;
  bool statusOrder = true;
  List<OrderModel> orderModel = [];
  List<List<String>>? listMenuFoods ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    print('idUser ==$idUser');
    readOrderFromIdUer();
  }

  Future readOrderFromIdUer() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/rabbitfood/getOrderWhereIdUser.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);
      // print('response ${response}');

      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        // print('result = $result');
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuFoods = changeArray(model.nameFood.toString());
          print('menuFood == $menuFoods');
          setState(() {
            statusOrder = false;
            orderModel.add(model);
            listMenuFoods?.add(menuFoods);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildNonOrder() : buildContent();
  }

  Widget buildContent() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: orderModel.length,
      itemBuilder: (context, index) => Column(
        children: [
          buildNameShop(index),
          buildDateTime(index),
          buildDistance(index),
          buildTransport(index),
          buildHead(),
          buildListViewMenuFood(index),
        ],
      ),
    );
  }

  Widget buildListViewMenuFood(int index) {
     return ListView.builder(
       shrinkWrap: true,
       physics: ScrollPhysics(),
       itemCount: listMenuFoods?.length,
        itemBuilder: (context, index2) => Text(listMenuFoods![index][index2]),
     );

    //  Text('${orderModel[index].nameFood}');
  }

  List<String> changeArray(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString == ${myString}');
    list = myString.split(', ');
    // int index = 0;
    // for (var string in list) {
    //   list[index] = string.trim();
    //   index++;
    // }
    return list;
  }

  Widget buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text('รายการอาหาร', style: TextStyle(fontSize: 15.0))),
          Expanded(
              flex: 1, child: Text('ราคา', style: TextStyle(fontSize: 15.0))),
          Expanded(
              flex: 1, child: Text('จำนวน', style: TextStyle(fontSize: 15.0))),
          Expanded(
              flex: 1, child: Text('ผลรวม', style: TextStyle(fontSize: 15.0))),
        ],
      ),
    );
  }

  Widget buildTransport(int index) {
    return Row(
      children: [
        Text(
          'ค่าจัดส่ง ${orderModel[index].transport}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ],
    );
  }

  Widget buildDistance(int index) {
    return Row(
      children: [
        Text(
          'ระยะทาง ${orderModel[index].distance}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ],
    );
  }

  Widget buildDateTime(int index) {
    return Row(
      children: [
        Text(
          'วันเวลาที่สั่ง ${orderModel[index].orderDateTime}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        Text(
          'ร้าน ${orderModel[index].nameShop}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
      ],
    );
  }

  Center buildNonOrder() {
    return Center(
        child: Text(
      'ยังไม่มีข้อมูลการสั่งอาหารของคุณ',
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ));
  }
}
