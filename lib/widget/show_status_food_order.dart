import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/model/order_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ShowStatusFoodOrder extends StatefulWidget {
  const ShowStatusFoodOrder({super.key});

  @override
  State<ShowStatusFoodOrder> createState() => _ShowStatusFoodOrderState();
}

class _ShowStatusFoodOrderState extends State<ShowStatusFoodOrder> {
  String? idUser;
  bool statusOrder = true;
  List<OrderModel> orderModel = [];
  List<List<String>> listMenuFoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> listTotals = [];
  List<int> liststatus = [];

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
          List<String> prices = changeArray(model.price.toString());
          List<String> amounts = changeArray(model.amount.toString());
          List<String> sums = changeArray(model.sum.toString());
          // print('menuFood == $menuFoods');

          int status = 0;
          switch (model.status) {
            case 'UserOrder':
              status = 0;
              break;
            case 'ShopCooking':
              status = 1;
              break;
            case 'RiderHandle':
              status = 2;
              break;
            case 'Finish':
              status = 3;
              break;
            default:
          }

          int total = 0;
          for (var string in sums) {
            total += int.parse(string.toString());
          }
          print('tatal== ${total}');

          setState(() {
            statusOrder = false;
            orderModel.add(model);
            listMenuFoods.add(menuFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            listTotals.add(total);
            liststatus.add(status);
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
          buildTotal(index),
          SizedBox(height: 10.0),
          buildStepIndicator(liststatus[index]),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget buildStepIndicator(int index) {
    return Column(
      children: [
        StepsIndicator(
          lineLength: 80,
          selectedStep: index,
          nbSteps: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Order'),
            Text('Cooking'),
            Text('Delivery'),
            Text('Finish'),
          ],
        ),
      ],
    );
  }

  Widget buildTotal(int index) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'รวมราคาอาหาร',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${listTotals[index].toString()}',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ],
    );
  }

  Widget buildListViewMenuFood(int index) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: listMenuFoods[index].length,
      itemBuilder: (context, index2) => Row(
        children: [
          Expanded(flex: 3, child: Text('${listMenuFoods[index][index2]}')),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${listPrices[index][index2]}'),
                ],
              )),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${listAmounts[index][index2]}'),
                ],
              )),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${listSums[index][index2]}'),
                ],
              )),
        ],
      ),
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
