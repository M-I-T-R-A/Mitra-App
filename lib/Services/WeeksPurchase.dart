import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

confirmation(BuildContext context, File weeksPurchase){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Weeks Purchase image      " + (weeksPurchase == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return weeksPurchase == null  ? false : true;
}
