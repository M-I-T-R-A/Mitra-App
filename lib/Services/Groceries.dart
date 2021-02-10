import 'dart:convert';
import 'package:Mitra/Models/Grocery.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:Mitra/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<List<Product>> getProductsByCategory(String category) async{
  List<Product> prod = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  try {
    final url = (server+"shop/product/info/category?category="+category+"&customerId="+id.toString());
    print(url);
    Response response = await get(Uri.encodeFull(url));
    prod = (json.decode(response.body) as List).map((i) => Product.fromJson(i)).toList();
  } catch (e) {
    print(e);
  }
  return prod;
}


Future<List<Product>> getProductByName(String productName) async{
  List<Product> prod ;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  try {
    final url = (server+"shop/product/info/name?name="+productName+"&customerId="+id.toString());
    print(url);
    Response response = await get(Uri.encodeFull(url));
    prod = (json.decode(response.body) as List).map((i) => Product.fromJson(i)).toList();
  } catch (e) {
    print(e);
  }
  return prod;
}

Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }