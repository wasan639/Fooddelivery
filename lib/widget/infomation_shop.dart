import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/screens/add_info_shop.dart';
import 'package:rabbitfood/utility/my_style.dart';

class InfomationShop extends StatefulWidget {
  const InfomationShop({super.key});

  @override
  State<InfomationShop> createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {

  UserModel? userModel;

  void routeToAddInfo() {
    //Widget widget = userModel.nameShop.isEmpty ? AddInfoShop()  :EditInfoShop()  ;
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (context) => AddInfomationShop());
    Navigator.push(context, materialPageRoute);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyStyle().titleCenter(context,'ยังไม่มีข้อมูล กรุณาเพิ่มข้อมูลของร้าน'),
        addAnEditButton(),
      ],
    );
  }

  Row addAnEditButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 16.0,bottom: 16.0  ),
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