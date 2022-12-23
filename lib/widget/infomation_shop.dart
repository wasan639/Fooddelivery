import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/screens/add_info_shop.dart';
import 'package:rabbitfood/screens/edit_info_shop.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfomationShop extends StatefulWidget {
  const InfomationShop({super.key});

  @override
  State<InfomationShop> createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUser();
  }

  Future readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url = '${MyConstant().domain}/rabbitfood/getUserWhereID.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      // print('value == $value');
      var result = jsonDecode(value.data);
      // print('result == $result');
      for (var map in result) {
          setState(() {
            userModel = UserModel.fromJson(map);
          });
      }
    });
  }

  Future routeToAddInfo() async {
    Widget widget =
        userModel!.nameShop!.isEmpty ? AddInfomationShop() : EditInfoShop();
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (context) => widget);
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameShop!.isEmpty
                ? showNoData(context)
                : showListInfoShop(),
        addAnEditButton(),
      ],
    );
  }

  Widget showListInfoShop() => Column(
        children: [
          MyStyle().showTitleH2('รายละเอียดร้าน ${userModel!.nameShop}'),
          showImage(),
          Row(
            children: [
              MyStyle().showTitleH2('ที่อยู่ของร้าน'),
            ],
          ),
          Row(
            children: [
              Text('${userModel!.address}'),
            ],
          ),
          SizedBox(height: 20),
          userModel!.lat == null ? MyStyle().showProgress() : showMap(),
        ],
      );

  Widget showImage() {
    return Container(
      width: 300.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}${userModel!.urlPicture.toString()}'),
    );
  }

  Set<Marker> myMarKer() {
    double lat = double.parse(userModel!.lat.toString());
    double lng = double.parse(userModel!.lng.toString());

    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: 'ร้านของคุณ', snippet: '$lat,$lng'),
      )
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel!.lat.toString());
    double lng = double.parse(userModel!.lng.toString());

    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);

    return Expanded(
      child: GoogleMap(
        markers: myMarKer(),
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

  Row addAnEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    routeToAddInfo();
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget showNoData(BuildContext context) {
    return MyStyle()
        .titleCenter(context, 'ยังไม่มี ข้อมูล กรุณาเพิ่มข้อมูลด้วย คะ');
  }
}
