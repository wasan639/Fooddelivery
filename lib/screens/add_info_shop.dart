import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddInfomationShop extends StatefulWidget {
  const AddInfomationShop({super.key});

  @override
  State<AddInfomationShop> createState() => _AddInfomationShopState();
}

class _AddInfomationShopState extends State<AddInfomationShop> {
  //field
  double? lat;
  double? lng;

  String? nameShop;
  String? address;
  String? phone;
  String? urlImage;

  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat = locationData?.latitude;
      lng = locationData?.longitude;
    });
    print('lat = $lat ,lng = $lng');
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Infomation Shop'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            nameForm(),
            SizedBox(height: 15.0),
            addressForm(),
            SizedBox(height: 15.0),
            phoneForm(),
            SizedBox(height: 15.0),
            groupImage(),
            SizedBox(height: 15.0),
            lat == null ? MyStyle().showProgress() : showMap(),
            SizedBox(height: 15.0),
            saveButton(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(lat!, lng!);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);

    return Container(
      height: 300.0,
      width: 380.0,
      child: GoogleMap(
        markers: myMarKer(),
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
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

  Widget saveButton() {
    return Container(
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (nameShop == null ||
              nameShop!.isEmpty ||
              address == null ||
              address!.isEmpty ||
              phone == null ||
              phone!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else if (file == null) {
            normalDialog(context, 'กรุณาเพิ่มรูปภาพร้านของคุณ');
          } else {
            uploadImage();
          }
        },
        icon: Icon(
          Icons.save,
          size: 36.0,
        ),
        label: Text(
          'Save Infomation',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Future uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'shopimage$i.jpg';

    String url = '${MyConstant().domain}/rabbitfood/saveShop.php/';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('respose ==> $value');
        urlImage = '/rabbitfood/Shop/$nameImage';
        print('urlImage === $urlImage');
        editUserShop();
      });
    } catch (e) {}
  }

  Future editUserShop() async {
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/rabbitfood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlImage&Lat=$lat&Lng=$lng';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกข้อมูลของคุณได้ กรุณาลองใหม่อีกครั้ง');
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

  Row groupImage() {
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
            width: 200.0,
            child: file == null
                ? Image.asset('images/addimage.png')
                : Image.file(file!)),
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

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า :',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => address = value.trim(),
              decoration: InputDecoration(
                labelText: 'ที่อยู่ร้านค้า :',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์ร้านค้า :',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
