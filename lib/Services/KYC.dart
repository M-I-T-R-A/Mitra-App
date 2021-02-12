import 'dart:convert';
import 'dart:io';

import 'package:Mitra/Services/FlushBar.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

confirmation(BuildContext context, File aadharFront, File aadharBack, File panFront){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Aadhar card front image      " + (aadharFront == null ? "❌": "✔️") + "\n";
  message = message + "2. Aadhar card back image      " + (aadharBack == null ? "❌": "✔️") + "\n";
  message = message + "3. PAN card front image           " + (panFront == null ? "❌": "✔️") + "\n";
  
  showFlushBar(context, title, message);
  return aadharFront == null || aadharBack == null || panFront == null ? false : true;
}

aadharCardVerification(String aadharNo){
  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  if(aadharNo.length != 12)
    showToast("Aadhar Number needs to be 12 digit!", grey, error);
  else if(_numeric.hasMatch(aadharNo) == false)
    showToast("Aadhar Number needs to have only digit!", grey, error);
  else{
    const _d = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
        [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
        [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
        [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
        [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
        [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
        [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
        [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
        [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
      ];

      const _p = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
        [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
        [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
        [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
        [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
        [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
        [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
      ];

      final initialIndex = 0;
      var c = 0;

      for (var k = aadharNo.length - 1, i = initialIndex; k >= 0; k--, i++) {
        final digit = aadharNo.codeUnitAt(k) - 48;
        c = _d[c][_p[i % 8][digit]];
      }

      showToast("Aadhar Number format correct!", grey, primaryColor);
      return c == 0;
  }
  return false;
}

kycRegistration(String aadhar, String pan, String aadharFrontURL, String aadharBackURL, String panFrontURL) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  final user = {
      "aadharCardFrontImageUrl": aadharFrontURL,
      "aadharCardBackImageUrl": aadharBackURL,
      "aadhar": aadhar,
      "pan": pan,
      "panCardImageUrl": panFrontURL,
      "status": 2
    };

    final url = (server+"customer/update/"+id.toString());
    print(user);
    
    Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
    print(response.body);
    int status = jsonDecode(response.body)["status"];
    if (status == 2){
      await prefs.setInt('login', 2);
    }
  return status;
}


panCardVerification(String pan){
  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  if(pan.length != 12)
    showToast("PAN needs to be 12 digit!", grey, error);
  else if(_numeric.hasMatch(pan) == false)
    showToast("PAN needs to have only digit!", grey, error);
  else{
    return true;
  }
  return false;
}

aadharCardMatch(String path, String aadharNo) async{
  print(aadharNo);
  var _extractText = await TesseractOcr.extractText(path);
  print(_extractText);
  String one = aadharNo.substring(0,4);
  String two = aadharNo.substring(4,8);
  String three = aadharNo.substring(8,12);
  print(one+" "+two+" "+three);
  print(_extractText.contains(one).toString() + " "+ _extractText.contains(two).toString() +" "+ _extractText.contains(three).toString());
  if (_extractText.contains(one) && _extractText.contains(two) && _extractText.contains(three)){
    return true;
  }
  else{
    showToast("Please capture clear photo of Aadhar card!", grey, error);
    return false;
  }
}

panCardMatch(String path, String pan) async{
  var _extractText = await TesseractOcr.extractText(path);
  print(_extractText);
  print(_extractText.contains(pan).toString());
  if (_extractText.contains(pan)){
    return true;
  }
  else{
    showToast("Please capture clear photo of PAN card!", grey, error);
    return false;
  }
}