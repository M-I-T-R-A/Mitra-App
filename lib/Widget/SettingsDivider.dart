import 'package:flutter/material.dart';

class SettingsDivider extends StatelessWidget {
  final dividerTitle;

  SettingsDivider({this.dividerTitle});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
          alignment: Alignment.topLeft,
          child: Text(this.dividerTitle, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          padding: EdgeInsets.all(10),
        ),
      )
    ]);
  }
}