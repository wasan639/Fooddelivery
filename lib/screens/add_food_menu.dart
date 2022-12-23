import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  const AddFoodMenu({super.key});

  @override
  State<AddFoodMenu> createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  File? file;

  String? nameFood;
  String? price;
  String? detail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการมานูอาหาร'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showTitleFood('รูปอาหาร'),
            SizedBox(height: 15.0),
            showGroupImage(),
            SizedBox(height: 15.0),
            showTitleFood('รายละเอียดอาหาร'),
            nameForm(),
            SizedBox(height: 15.0),
            priceForm(),
            SizedBox(height: 15.0),
            detailForm(),
            SizedBox(height: 15.0),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (file == null) {
            normalDialog(context, 'กรุณาเพิ่มรูปภาพอาหาร');
          } else if (nameFood == null ||
              nameFood!.isEmpty ||
              price == null ||
              price!.isEmpty ||
              detail == null ||
              detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else {
            uploadAndInsertFoodData();
          }
        },
        icon: Icon(Icons.save, size: 36.0),
        label: Text('Save Food Menu', style: TextStyle(fontSize: 20.0)),
      ),
    );
  }

  Future uploadAndInsertFoodData() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'foodimage$i.jpg';

    String url = '${MyConstant().domain}/rabbitfood/saveFood.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String urlImage = '/rabbitfood/Food/$nameImage';
        print('urlImage === $urlImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? idShop = preferences.getString('id');

        String urlInsertData = '${MyConstant().domain}/rabbitfood/addFood.php?isAdd=true&idShop=$idShop&NameFood=$nameFood&PathImage=$urlImage&Price=$price&Detail=$detail';

        await Dio().get(urlInsertData).then((value) {
          if (value.toString() == 'true') {
            Navigator.pop(context);
          } else {
            normalDialog(
                context, 'ไม่สามารถบันทึกข้อมูลของคุณได้ กรุณาลองใหม่อีกครั้ง');
          }
        });
      });
    } catch (e) {}
  }

  Widget nameForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) => nameFood = value.trim(),
            decoration: InputDecoration(
              labelText: 'ชื่ออาหาร :',
              prefixIcon: Icon(Icons.fastfood),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget priceForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => price = value.trim(),
            decoration: InputDecoration(
              labelText: 'ราคาอาหาร :',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget detailForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            onChanged: (value) => detail = value.trim(),
            decoration: InputDecoration(
              labelText: 'รายระเอียดอาหาร :',
              prefixIcon: Icon(Icons.details),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget showTitleFood(String str) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Row(
        children: [
          MyStyle().showTitleH2(str),
        ],
      ),
    );
  }

  Future chooseImage(ImageSource imageSource) async {
    try {
      var pickedImage = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Row showGroupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo, size: 36.0),
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
        ),
        Container(
          height: 200.0,
          width: 200.0,
          child: file == null
              ? Image.asset('images/addimage.png')
              : Image.file(file!),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
        )
      ],
    );
  }
}
