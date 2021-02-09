import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';

confirmation(BuildContext context, File bankStatement, File incomeTax){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Bank Statements            " + (bankStatement == null ? "❌": "✔️") + "\n";
  message = message + "2. Income Tax Statements      " + (incomeTax == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return bankStatement == null || incomeTax == null  ? false : true;
}
