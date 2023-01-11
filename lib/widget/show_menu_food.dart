import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:rabbitfood/model/cart_model.dart';
import 'package:rabbitfood/model/food_model.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_api.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:rabbitfood/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  const ShowMenuFood({super.key, required this.userModel});

  @override
  State<ShowMenuFood> createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel? userModel;
  String? idShop;
  List<FoodModel> foodModels = [];
  int amout = 1;
  double? latUser, lngUser;
  double? latShop, lngShop;
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
  }

  Future findLocation() async {
    location.onLocationChanged.listen((event) {
      latUser = event.latitude;
      lngUser = event.longitude;
      // latShop = double.parse('${userModel?.lat}');
      // lngShop = double.parse('${userModel?.lng}');
      //print('lat == $latUser,lng == $lngUser');
    });
  }

  Future readFoodMenu() async {
  
    idShop = userModel!.id;
    // print('idShop== $idShop');
    String url =
        '${MyConstant().domain}/rabbitfood/getFoodWhereID.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    // print(response);
    var result = json.decode(response.toString());
    // print(result);
    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                // print('Your Click index = $index');
                amout = 1;
                confirmOrder(index);
              },
              child: Row(
                children: [
                  showFoodImage(context, index),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text('ชื่ออาหาร : ${foodModels[index].nameFood}'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('ราคา : ${foodModels[index].price} บาท'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5 - 0.8,
                              child: Text(
                                  'รายละเอียด : ${foodModels[index].detail}'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.5 - 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${foodModels[index].pathImage}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Future confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(foodModels[index].nameFood.toString()),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180.0,
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${foodModels[index].pathImage}'),
                      fit: BoxFit.cover),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          amout++;
                          // print(amout);
                        });
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 36.0,
                        color: Colors.green,
                      )),
                  Text(amout.toString(),
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () {
                      if (amout > 1) {
                        setState(() {
                          amout--;
                          // print(amout);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: 120.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        onPressed: () {
                          Navigator.pop(context);
                          // print( 'Order ${foodModels[index].nameFood} Amout == $amout');

                          addOrderToCart(index);
                        },
                        child: Text('Add To Cart'),
                      )),
                  SizedBox(width: 20.0),
                  Container(
                      width: 120.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addOrderToCart(int index) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUser = preferences.getString('id');

    String nameShop = userModel!.nameShop.toString();
    String idFood = foodModels[index].id.toString();
    String nameFood = foodModels[index].nameFood.toString();
    String price = foodModels[index].price.toString();

    int priceInt = int.parse(price);
    int sum = priceInt * amout;

    latShop = double.parse('${userModel?.lat}');
    lngShop = double.parse('${userModel?.lng}');
    double distance =
        MyAPI().calculateDistance(latUser!, lngUser!, latShop!, lngShop!);

    var myFormat = NumberFormat('##0.0#', 'en_US');
    String distanceString = myFormat.format(distance);

    int transport = MyAPI().calculateTransport(distance);

    print(
        'idShop == $idShop, nameShop== $nameShop,idFood == $idFood, nameFood== $nameFood,price == $priceInt,amount == $amout,sum == $sum,distance==$distanceString, Transport ==$transport');

    Map<String, dynamic> map = Map();
    map['idUser'] = idUser;
    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amout.toString();
    map['sum'] = sum.toString();
    map['distance'] = distanceString;
    map['transport'] = transport.toString();

    print('map == ${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite(int.parse(idUser.toString()));
    print('object===${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
        print('insert success');
        showToast('insert success', gravity: Toast.center);
      });
    } else {
      String idShopSQLite = object[0].idShop.toString();
      print('idShopSQL == $idShopSQLite');

      if (idShop == idShopSQLite) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print('insert success');
          showToast('insert success', gravity: Toast.center);
        });
      } else {
        normalDialog(context,
            'รถเข็นมีรายการอาหารของ ร้าน ${object[0].nameFood} อยู่กรุณาซื้อในร้านเดียวเท่านั้น');
      }
    }
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(
      msg,
      duration: Toast.lengthShort,
      gravity: gravity,
    );
  }

}
