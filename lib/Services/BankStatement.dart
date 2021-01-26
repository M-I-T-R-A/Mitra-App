import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

confirmation(BuildContext context, File passbookFront, File passbookLatest){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Passbook card front image      " + (passbookFront == null ? "❌": "✔️") + "\n";
  message = message + "2. Passbook card Latest image      " + (passbookLatest == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return passbookFront == null || passbookLatest == null  ? false : true;
}
