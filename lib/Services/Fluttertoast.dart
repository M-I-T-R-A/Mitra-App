import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, Color backgroundColor, Color textColor) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, 
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 12.0
    );
}