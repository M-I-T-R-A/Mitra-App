import 'dart:convert';
import 'dart:io';
import 'package:Mitra/Services/FlushBar.dart';
import 'package:intl/intl.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

confirmation(BuildContext context, File bankStatement, File incomeTax){
  String title = "Documents status";
  String message = "Following documents are uploaded...\n";
  
  message = message + "1. Bank Statements            " + (bankStatement == null ? "❌": "✔️") + "\n";
  message = message + "2. Income Tax Statements      " + (incomeTax == null ? "❌": "✔️") + "\n";

  showFlushBar(context, title, message);
  return bankStatement == null || incomeTax == null  ? false : true;
}


uploadFiles(String bankStatementURL, String incomeTaxURL) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  List<String> bankstatement = new List();
  bankstatement.add(bankStatementURL); 
  final bank = {
    "bankStatementImageUrls": bankstatement
  };
  final bankurl = (server+"customer/bankaccount/"+id.toString());
  print(bank);
  
  Response bankresponse = await post(Uri.encodeFull(bankurl), body: json.encode(bank), headers: {"Content-Type": "application/json"});
  print(bankresponse.body);
  
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  
  List<dynamic> taxReturns = new List();
  taxReturns.add({
    "date": formatted,
    "itrDocumentUrl": incomeTaxURL,
    "tax": 0
  }); 
  
  final surrogates = {
    "id": id,
    "instantLoanSurrogates": {
      "id": id,
      "taxReturns": taxReturns
    }
  };
  
  final taxurl = (server+"customer/surrogates");
  print(surrogates);
  
  Response taxresponse = await put(Uri.encodeFull(taxurl), body: json.encode(surrogates), headers: {"Content-Type": "application/json"});
  print(taxresponse.body);
  
  final user = {
    "status": 6
  };

  final url = (server+"customer/update/"+id.toString());
  print(user);
  
  Response response = await put(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
  print(response.body);
  int status = jsonDecode(response.body)["status"];
  if (status == 6){
    await prefs.setInt('login', 6);
  }
  return status;
}