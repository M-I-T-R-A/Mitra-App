import 'dart:convert';
import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

confirmation(BuildContext context, File weeksPurchase){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Weeks Purchase image      " + (weeksPurchase == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return weeksPurchase == null  ? false : true;
}


uploadFiles(String weekPurchaseURL) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  
  List<dynamic> bills = new List();
  bills.add({
    "imageUrl": weekPurchaseURL
  }); 
  
  final surrogates = {
    "id": id,
    "instantLoanSurrogates": {
      "id": id,
      "bills": bills
    }
  };
  
  final taxurl = (server+"customer/surrogates");
  print(surrogates);
  
  Response taxresponse = await put(Uri.encodeFull(taxurl), body: json.encode(surrogates), headers: {"Content-Type": "application/json"});
  print(taxresponse.body);
  
  final user = {
    "status": 7
  };

  final url = (server+"customer/update/"+id.toString());
  print(user);
  
  Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
  print(response.body);
  int status = jsonDecode(response.body)["status"];
  if (status == 7){
    await prefs.setInt('login', 7);
  }
  return status;
}