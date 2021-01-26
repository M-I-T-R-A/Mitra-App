import 'dart:convert';
import 'package:Mitra/Models/Grocery.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Category>> getCategory() async{
  List<Category> categories = [];
  try {
    List<dynamic> dmap = await parseJsonFromAssets('assets/json/categories.json');
    for (int i = 0; i < dmap.length; i++) {
      Category _cat = new Category(name: dmap[i]["name"], dname: dmap[i]["dname"], image: dmap[i]["image"]);
      categories.add(_cat);
    }
  } catch (e) {
    print(e);
  }
  return categories;
} 

Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }