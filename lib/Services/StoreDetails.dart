import 'dart:convert';
import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

confirmation(BuildContext context, File electricityBill){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Electricity Bill image      " + (electricityBill == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return electricityBill == null  ? false : true;
}

storeOwnerRegistration(String gender, double annualIncome, String firstLine, String secondLine, double latitude, double longitude, int pincode, String city, String state, double electrictyBill, String electrictyBillPath) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  final user = {
      "gender": gender.toUpperCase(),
      "annualIncome": annualIncome,
      "electricityBill": electrictyBill,
      "electricityBillImageUrl": electrictyBillPath,
      "residenceAddress": {
        "city": city,
        "firstLine": firstLine,
        "latitude": latitude,
        "longitude": longitude,
        "pincode": pincode,
        "secondLine": secondLine,
        "state": state
      },    
      "status": 3
    };

    final url = (server+"customer/update/"+id.toString());
    print(user);
    
    Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
    print(response.body);
    int status = jsonDecode(response.body)["status"];
    if (status == 3){
      await prefs.setInt('login', 3);
    }
  return status;
}

storeRegistration(String type, String gstin, double areaPerSqft, String rent, int contactNumber, String storeName, String firstLine, String secondLine, double latitude, double longitude, int pincode, String city, String state, double electrictyBill, String electrictyBillPath) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  final shop = {
    "shopName": storeName,
    "phoneNumber":contactNumber,
    "gstin": gstin,
    "area": areaPerSqft,
    "type": type.toUpperCase(),
    "ownership": rent.toUpperCase(),
    "electricityAmount": electrictyBill,
    "electricityBillImageUrl": electrictyBillPath,
    "shopAddress": {
      "city": city,
      "firstLine": firstLine,
      "latitude": latitude,
      "longitude": longitude,
      "pincode": pincode,
      "secondLine": secondLine,
      "state": state
    },
    "wareHouse": {
      "areaOfWareHouses": [
        areaPerSqft
      ],
      "numberOfWareHouses": 1
    }
  };

  final shopURL = (server+"shop/"+id.toString());
  print(shop);
  
  Response shopsResponse = await post(Uri.encodeFull(shopURL), body: json.encode(shop), headers: {"Content-Type": "application/json"});
  print(shopsResponse.body);

  final user = {
    "status": 5
  };

  final url = (server+"customer/update/"+id.toString());
  print(user);
  
  Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
  print(response.body);
  int status = jsonDecode(response.body)["status"];
  if (status == 5){
    await prefs.setInt('login', 5);
  }
  return status;
}
