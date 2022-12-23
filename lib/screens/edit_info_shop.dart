import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoShop extends StatefulWidget {
  const EditInfoShop({super.key});

  @override
  State<EditInfoShop> createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel? userModel;

  String? nameShop;
  String? address;
  String? phone;
  String? urlImage;
  double? lat;
  double? lng;

  File? file = null;
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
    location.onLocationChanged.listen((event) {
      if (mounted)
        setState(() {
          lat = event.latitude;
          lng = event.longitude;
          // print('lat === $lat, lng === $lng');
        });
    });
  }

  Future readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    print('id ====== $id');

    String url =
        '${MyConstant().domain}/rabbitfood/getUserWhereId.php?isAdd=true&id=$id';

    Response response = await Dio().get(url);
    print('response ==== $response');

    var result = jsonDecode(response.data);
    print('result ==== $result');

    for (var map in result) {
      print(map);
      if (mounted)
        setState(() {
          userModel = UserModel.fromJson(map);
          nameShop = userModel!.nameShop;
          address = userModel!.address;
          phone = userModel!.phone;
          urlImage = userModel!.urlPicture;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขรายละเอียดของร้าน'),
      ),
      body: userModel == null ? MyStyle().showProgress() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            nameShopForm(),
            showImage(),
            addressShopForm(),
            phoneShopForm(),
            lat == null ? MyStyle().showProgress() : showMap(),
            editButton(),
          ],
        ),
      );

  Widget editButton() {
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (nameShop!.isEmpty || address!.isEmpty || phone!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else {
            confirmDialog();
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

  Future confirmDialog() async {
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
                    editThread();
                  }),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(width: 40.0),
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ยกเลิก', style: TextStyle(color: Colors.black))),
            ],
          ),
        ],
      ),
    );
  }

  Future editThread() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(1000000);
      String nameImage = 'shopimage$i.jpg';

      try {
        Map<String, dynamic> map = Map();
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameImage);
        FormData formData = FormData.fromMap(map);

        String urlUpload = '${MyConstant().domain}/rabbitfood/saveShop.php';

        await Dio().post(urlUpload, data: formData).then((value) {
          //print('respose ==> $value');
          urlImage = '${MyConstant().domain}/rabbitfood/Shop/$nameImage';
          //print('urlImage === $urlImage');
        });
      } catch (e) {
        // TODO
      }
    }

    String? id = userModel!.id;

    String url =
        '${MyConstant().domain}/rabbitfood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlImage&Lat=$lat&Lng=$lng';

    Response response = await Dio().get(url);
    if (response.toString() == 'true') {
      Navigator.pop(context);
    } else {
      normalDialog(context, 'ไม่สามารถแก้ไขข้อมูลร้านได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  Set<Marker> myMarKer() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(title: 'ร้านของคุณ', snippet: '$lat,$lng'),
      )
    ].toSet();
  }

  Widget showMap() {
    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(lat!, lng!), zoom: 14);

    return Container(
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        markers: myMarKer(),
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
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

  Widget showImage() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
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
              child:
                  file == null ? Image.network('${MyConstant().domain}${urlImage!}') : Image.file(file!),
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
        ),
      );

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: nameShop,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget addressShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              maxLines: 3,
              initialValue: address,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่ของร้าน',
              ),
            ),
          ),
        ],
      );

  Widget phoneShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทรศัพท์ของร้าน',
              ),
            ),
          ),
        ],
      );
}
