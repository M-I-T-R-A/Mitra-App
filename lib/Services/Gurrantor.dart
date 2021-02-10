import 'dart:convert';
import 'dart:io';
import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

confirmation(BuildContext context, File electricityBill, File aadharFront, File aadharBack){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Electricity Bill image      " + (electricityBill == null ? "❌": "✔️") + "\n";
  message = message + "2. Aadhar Front image      " + (aadharFront == null ? "❌": "✔️") + "\n";
  message = message + "3. Aadhar Back image      " + (aadharBack == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return electricityBill == null || aadharFront == null || aadharBack == null ? false : true;
}

gurrantorRegistration(String name, String mobile, String gender, double annualIncome, String firstLine, String secondLine, double latitude, double longitude, int pincode, String city, String state, double electrictyBill, String electrictyBillPath, String aadhar, String aadharFront, String aadharBack) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  print(city);
  final gurrantor = {
    "id": id,
    "instantLoanSurrogates": {
      "id": id,
      "gurrantor":{
        "name": name,
        "mobile":mobile,
        "aadhar": aadhar,
        "aadharCardBackImageUrl": aadharBack,
        "aadharCardFrontImageUrl": aadharFront,
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
        }
      } 
    }
  };

  final surrogateURL = (server+"customer/surrogates/");
  print(gurrantor);
  
  Response surrogatesResponse = await put(Uri.encodeFull(surrogateURL), body: json.encode(gurrantor), headers: {"Content-Type": "application/json"});
  print(surrogatesResponse.body);

  final user = {
    "status": 4
  };

  final url = (server+"customer/update/" + id.toString());
  print(user);
  
  Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
  print(response.body);
  int status = jsonDecode(response.body)["status"];
  if (status == 4){
    await prefs.setInt('login', 4);
  }
  return status;
}
