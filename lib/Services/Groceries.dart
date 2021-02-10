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

    List data = jsonDecode(response.body);
    
    for (int i = 0; i < data.length; i++) {
      Product _prod = new Product.fromJson(jsonDecode(data[i]));
      prod.add(_prod);
    }
  } catch (e) {
    print(e);
  }
  return prod;
}


Future<Product> getProductByName(String productName) async{
  Product prod ;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  try {
    final url = (server+"shop/product/info/name?name="+productName+"&customerId="+id.toString());
    print(url);
    Response response = await get(Uri.encodeFull(url));

    var data = jsonDecode(response.body);
    prod = new Product.fromJson(jsonDecode(data));
  } catch (e) {
    print(e);
  }
  return prod;
}

Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }