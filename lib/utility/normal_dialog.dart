import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {//โชว์แจ้งเตือนการทำงานต่างๆ
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  //style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}