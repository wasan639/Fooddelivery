import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/screens/show_shop_food_menu.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  const ShowListShopAll({super.key});

  @override
  State<ShowListShopAll> createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  
  List<UserModel> userModels = [];
  List<Widget> shopCard = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readShop();
  }

  Future readShop() async {
    String url =
        '${MyConstant().domain}/rabbitfood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';

    await Dio().get(url).then((value) {
      //print('value == $value');
      var result = json.decode(value.data);
      int index = 0;

      for (var map in result) {
        UserModel model = UserModel.fromJson(map);

        String nameShop = model.nameShop.toString();
        if (nameShop.isNotEmpty) {
          print('${model.nameShop}');
          setState(() {
            userModels.add(model);
            shopCard.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return shopCard.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              children: shopCard,
            );
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context) =>
                ShowShopFoodMenu(usermodel: userModels[index]));
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 80.0,
                height: 80.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    ('${MyConstant().domain}${userModel.urlPicture}'),
                  ),
                )),
            SizedBox(height: 15.0),
            Text(
              '${userModel.nameShop}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

}