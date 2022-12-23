import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/model/food_model.dart';
import 'package:rabbitfood/screens/add_food_menu.dart';
import 'package:rabbitfood/screens/edit_food_menu.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenuShop extends StatefulWidget {
  const ListFoodMenuShop({super.key});

  @override
  State<ListFoodMenuShop> createState() => _ListFoodMenuShopState();
}

class _ListFoodMenuShopState extends State<ListFoodMenuShop> {
  bool loadStatus = true; //โหลดยังไม่เสร็จ
  bool status = true; //มีข้อมูล

  List<FoodModel> foodModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  Future readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idShop = preferences.getString('id');
    print('idShop== $idShop');

    String url =
        '${MyConstant().domain}/rabbitfood/getFoodWhereID.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        var result = jsonDecode(value.data); //แปลงเป็นภาษาไทย

        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        loadStatus ? MyStyle().showProgress() 
        : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: Text(
              'ยังไม่มีรายการอาหาร',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          );
  }

  Widget showListFood() {
    return ListView.builder(
      itemCount: foodModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Container(
            height: 160.0,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.amber),
              color: Colors.amber.shade100,
            ),
            padding: EdgeInsets.all(8.0),
            child: Image.network(
              '${MyConstant().domain}${foodModels[index].pathImage.toString()}',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 160.0,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.amber),
              color: Colors.amber.shade100,
            ),
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyStyle().showFoodData(
                      'ชื่ออาหาร : ${foodModels[index].nameFood}', 18.0),
                  MyStyle()
                      .showFoodData('ราคา : ${foodModels[index].price}', 18.0),
                  MyStyle().showFoodData(
                      'รายละเอียด : ${foodModels[index].detail}', 16.0),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        //edit
                        icon: Icon(
                          Icons.edit,
                          color: Colors.amber.shade900,
                        ),
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => EditFoodMenu(
                                    foodmodel: foodModels[index],
                                  ));
                          Navigator.push(context, route)
                              .then((value) => readFoodMenu());
                        },
                      ),
                      IconButton(
                        //delete
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteFood(foodModels[index]);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันที่จะลบ ${foodModel.nameFood} ใช่หรือไม่?',
            style: TextStyle(color: Colors.red)),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() async {
                    Navigator.pop(context);

                    String url =
                        '${MyConstant().domain}/rabbitfood/deleteFoodWhereId.php?isAdd=true&id=${foodModel.id}';
                    await Dio().get(url).then((value) => readFoodMenu());
                  }),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(width: 40.0),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget addMenuButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => AddFoodMenu());
                  Navigator.push(context, route)
                      .then((value) => readFoodMenu());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
