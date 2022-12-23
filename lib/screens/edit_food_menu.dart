import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabbitfood/model/food_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';

class EditFoodMenu extends StatefulWidget {
  final FoodModel foodmodel;
  const EditFoodMenu({super.key, required this.foodmodel});

  @override
  State<EditFoodMenu> createState() => _EditFoodMenuState();
}

class _EditFoodMenuState extends State<EditFoodMenu> {
  FoodModel? foodModel;

  File? file;

  String? name;
  String? price;
  String? detail;
  String? pathImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodModel = widget.foodmodel;
    name = foodModel?.nameFood;
    price = foodModel?.price;
    detail = foodModel?.detail;
    pathImage = foodModel?.pathImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเมนู ${foodModel?.nameFood}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              nameFood(),
              groupImage(),
              priceFood(),
              detailFood(),
              SizedBox(height: 60.0),
              editFoodButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget editFoodButton() {
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (name!.isEmpty || price!.isEmpty || detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครับทุกช่อง');
          } else {
            confirmEdit();
          }
        },
        icon: Icon(
          Icons.edit,
          size: 30.0,
        ),
        label: Text(
          'ยืนยันการแก้ไข',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Future confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันการแก้ไขหรือไม่'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    editValueOnMySQL();
                  }),
                  child: Text('ยืนยัน', style: TextStyle(color: Colors.black))),
              SizedBox(width: 40.0),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก', style: TextStyle(color: Colors.black))),
            ],
          ),
        ],
      ),
    );
  }

  Future editValueOnMySQL() async {

    if (file != null) {
  Random random = Random();
  int i = random.nextInt(1000000);
  String nameImage = 'foodimage$i.jpg';
  
  try {
    String urlUpload = '${MyConstant().domain}/rabbitfood/saveFood.php';
  
    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(file!.path, filename: nameImage);
  
    FormData formData = FormData.fromMap(map);
    await Dio().post(urlUpload, data: formData).then((value) async {
      String urlImage = '/rabbitfood/Food/$nameImage';
      print('urlImage === $urlImage');
      pathImage = urlImage;
    });
  } catch (e) {}
}


    String id = '${foodModel!.id}';
    String url =
        '${MyConstant().domain}/rabbitfood/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&PathImage=$pathImage&Price=$price&Detail=$detail';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง');
      }
    });
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

  Row groupImage() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo, size: 36.0),
            onPressed: () {
              chooseImage(ImageSource.camera);
            },
          ),
          Container(
            height: 250.0,
            width: 250.0,
            child: file == null
                ? Image.network('${MyConstant().domain}${foodModel?.pathImage}')
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

  Widget nameFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              initialValue: name,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่ออาหาร',
              ),
            ),
          ),
        ],
      );

  Widget priceFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              initialValue: price,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ราคาอาหาร',
              ),
            ),
          ),
        ],
      );

  Widget detailFood() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => detail = value.trim(),
              initialValue: detail,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'รายละเอียดอาหาร',
              ),
            ),
          ),
        ],
      );
}
