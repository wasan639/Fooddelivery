import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rabbitfood/model/cart_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:rabbitfood/utility/sqlite_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({super.key});

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = [];
  int total = 0;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
  }

   Future readSQLite() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     String? id = preferences.getString('id');
     int? idUser = int.parse(id.toString());

     var object = await SQLiteHelper().readAllDataFromSQLite(idUser);

     print('object ==> ${object.length}');
     //print('idUser ==> ${idUser}');

    if (object.length != 0) {
      for (var model in object) {
        int sum = int.parse(model.sum.toString());
        setState(() {
          status = false;
          cartModels = object;
          total += sum;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }

   }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของฉัน'),
      ),
      body: status
          ? Center(
              child: Text(
                'ไม่มีรายการอาหารในตะกร้าของคุณ',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameShop(),
            buildTitle(),
            buildListFood(),
            Divider(),
            buildTotal(),
            buildClearCart(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget buildClearCart() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 125.0,
            child: ElevatedButton.icon(
                onPressed: () {
                  confirmDeleteData();
                },
                icon: Icon(Icons.delete_outline),
                label: Text('ลบทั้งหมด')),
          ),
        ],
      );

  Widget buildOrderButton() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 125.0,
            child: ElevatedButton.icon(
                onPressed: () {
                  orderThread();
                },
                icon: Icon(Icons.fastfood),
                label: Text('สั่งอาหาร')),
          ),
        ],
      );

  Widget buildTotal() {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Total : ',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ],
            )),
        Expanded(
            flex: 1,
            child: Text(total.toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget buildNameShop() {
    return Container(
      //margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('ร้าน ${cartModels[0].nameShop}',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text('ระยะทาง : ${cartModels[0].distance} กิโลเมตร',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              Text('ค่าจัดส่ง : ${cartModels[0].transport} บาท',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                'รายการอาหาร',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 1,
              child: Text('ราคา',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('จำนวน',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('ผลรวม',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
          Expanded(
              child: SizedBox(
            width: 5.0,
          )),
        ],
      ),
    );
  }

  Widget buildListFood() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: cartModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(flex: 3, child: Text(cartModels[index].nameFood.toString())),
          // Expanded(flex: 1, child: Text(cartModels[index].idUser.toString())),
          Expanded(flex: 1, child: Text(cartModels[index].price.toString())),
          Expanded(flex: 1, child: Text(cartModels[index].amount.toString())),
          Expanded(flex: 1, child: Text(cartModels[index].sum.toString())),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                int? id = cartModels[index].id;
                print('You Click Delete id = $id');
                await SQLiteHelper().delteDataWhereId(id!).then((value) {
                  print('Success delete id ==> $id');
                  readSQLite();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future confirmDeleteData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ต้องการลบรายการอาหารทั้งหมดใช่หรือไม่'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                  onPressed: (() async {
                    Navigator.pop(context);
                    await SQLiteHelper().delteAllData().then((value) {
                      readSQLite();
                    });
                  }),
                  child: Text('ยืนยัน', style: TextStyle(color: Colors.black))),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก', style: TextStyle(color: Colors.black))),
            ],
          )
        ],
      ),
    );
  }

  Future orderThread() async {
    DateTime dateTime = DateTime.now();

    String orderDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    // print('orderDateTime==> $orderDateTime');
    String idShop = cartModels[0].idShop.toString();
    String nameShop = cartModels[0].nameShop.toString();
    String distance = cartModels[0].distance.toString();
    String transport = cartModels[0].transport.toString();

    List<String> idFoods = [];
    List<String> nameFoods = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      idFoods.add(model.idFood.toString());
      nameFoods.add(model.nameFood.toString());
      prices.add(model.price.toString());
      amounts.add(model.amount.toString());
      sums.add(model.sum.toString());
    }

    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id').toString();
    String nameUser = preferences.getString('Name').toString();


    print('idUser == $idUser, nameUser == $nameUser');
    print('$idShop $nameShop $distance $transport ');
    print('$idFood $nameFoods $price $amount $sum');

    String url = '${MyConstant().domain}/rabbitfood/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOrder';
    
    Response response = await Dio().get(url);
    print('response ====> $response');
      if (response.toString() == 'true') {
        clearAllSQLite();
      } else {
        normalDialog(context, 'ไม่สามารถสั่งอาหารได้ กรุณาลองใหม่อีกครั้ง');
      }
    
  }

  Future clearAllSQLite() async {
    showToast('สั่งอาหารเรียบร้อย', gravity: Toast.center);
    await SQLiteHelper().delteAllData().then((value) {
      readSQLite();
    });
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(
      msg,
      duration: Toast.lengthShort,
      gravity: gravity,
    );
  }
}
