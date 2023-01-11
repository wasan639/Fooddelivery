import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_api.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';

class AboutShop extends StatefulWidget {
  final UserModel userModel;
  const AboutShop({super.key, required this.userModel});

  @override
  State<AboutShop> createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel? userModel;
  double? latUser, lngUser;
  double? latShop, lngShop;
  double? distance;
  String? distanceString;
  int? transport;
  CameraPosition? cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    findLat1Lng1();
  }

  Future findLat1Lng1() async {
    LocationData locationData = await Location().getLocation();
    setState(() {
      latUser = locationData.latitude;
      lngUser = locationData.longitude;
      latShop = double.parse('${userModel?.lat}');
      lngShop = double.parse('${userModel?.lng}');
      print(
          'lat1 ==  $latUser, lng1 == $lngUser, lat2 ==  $latShop, lng2 == $lngShop');
      distance = MyAPI().calculateDistance(latUser!, lngUser!, latShop!, lngShop!);

      var myFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = myFormat.format(distance);
      transport = MyAPI().calculateTransport(distance!);

      print('distance = $distance');
      print('transport == $transport');
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: 250.0,
                height: 250.0,
                child: Image.network(
                  '${MyConstant().domain}${userModel!.urlPicture}',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('${userModel!.address}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('${userModel!.phone}'),
          ),
          ListTile(
            leading: Icon(Icons.social_distance_sharp),
            title: Text(distance == null ? '' : '$distanceString กิโลเมตร'),
          ),
          ListTile(
            leading: Icon(Icons.transfer_within_a_station),
            title: Text(transport == null ? '' : '$transport บาท'),
          ),
          showMap(),
        ],
      ),
    );
  }

  Marker userMarKer() {
    return Marker(
      markerId: MarkerId('myShop'),
      position: LatLng(latUser!, lngUser!),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(title: 'ร้านของคุณ', snippet: '$latUser,$lngUser'),
    );
  }

  Marker shopMarKer() {
    return Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(latShop!, lngShop!),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(
            title: '${userModel!.nameShop}', snippet: '$latShop,$lngShop'));
  }

  Set<Marker> mySet() {
    return <Marker>[
      userMarKer(),
      shopMarKer(),
    ].toSet();
  }

  Container showMap() {
    if (latUser != null) {
      LatLng latLngUser = LatLng(latUser!, lngUser!);
      cameraPosition = CameraPosition(target: latLngUser, zoom: 14);
    }

    return Container(
      margin: EdgeInsets.all(16.0),
      // color: Colors.grey,
      height: 250.0,
      child: latUser == null
          ? MyStyle().showProgress()
          : GoogleMap(
              markers: mySet(),
              initialCameraPosition: cameraPosition!,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
            ),
    );
  }
}
