import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddInfomationShop extends StatefulWidget {
  const AddInfomationShop({super.key});

  @override
  State<AddInfomationShop> createState() => _AddInfomationShopState();
}

class _AddInfomationShopState extends State<AddInfomationShop> {
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
            showMap(),
            SizedBox(height: 15.0),
            saveButton(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(13.819579, 100.045381);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);

    return Container(
      height: 300.0,
      width: 380.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
        
        },
      ),
    );
  }

  Widget saveButton() {
    return Container(
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: (() {
          
        }),
        icon: Icon(Icons.save,size: 36.0,),
        label: Text('Save Infomation',style: TextStyle(fontSize: 20.0),),
      ),



      // child: ElevatedButton(
      //   onPressed: () {},
      //   // icon: Icon(Icons.save,color: Colors.white,),
      //   // label: Text('Save Infomation',style: TextStyle(color: Colors.white),),
      // ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo, size: 36.0),
          onPressed: () {},
        ),
        Container(
          width: 200.0,
          child: Image.asset('images/addimage.png'),
        ),
        IconButton(
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
          onPressed: () {},
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
              //onChanged: (value) => nameShop = value.trim(),
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
              //onChanged: (value) => address = value.trim(),
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
              //onChanged: (value) => phone = value.trim(),
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
