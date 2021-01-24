import 'dart:ui';
import 'package:Mitra/constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushBar(BuildContext context, String title, String message) {
    Flushbar(
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: primaryColor),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 14.0, color: white),
      ),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: primaryColor,
        ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: primaryColor,
      duration: Duration(seconds: 5),
      leftBarIndicatorColor: primaryColor,
      boxShadows: [BoxShadow(color: primaryColor, offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
    )..show(context);
}