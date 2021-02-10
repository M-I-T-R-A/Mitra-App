import 'dart:convert';

import 'package:Mitra/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:sembast/sembast.dart';
import 'package:Mitra/Models/Grocery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartState {
  final Database database = GetIt.I.get();
  final StoreRef store = intMapStoreFactory.store("orders");

  Future addData(String name, int qty, String desc) async {
    await store.add(database, {'name': name, 'qty': qty, 'desc': desc});
  }

  Future<List<Cartprod>> getAll() async{
    List<Cartprod> prod = [];
    try {
      final data = await store.find(database);
      for(int i=0;i<data.length;i++) {
        Cartprod _prod = new Cartprod(
          name: data[i]["name"], qty: data[i]["qty"], desc: data[i]['desc']);
          prod.add(_prod);
      }
    } catch (e) {
      print(e);
    }
    return prod;
  }

  Future updateData(String name, int qty) async{
    if(qty == 0) {
      var filter = Filter.equals('name', name);
      var finder = Finder(filter: filter);
      await store.delete(database, finder: finder);
    }
    await store.update(database, {'name': name, 'qty': qty});
  }

  Future clear() async {
    await store.delete(database);
  }
}

updateProduct(List<Cartprod> products) async{
  List<dynamic> prod = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  
  for(int i=0;i<products.length;i++) {
    var _prod = {
      "name": products[i].name,
      "quantity": products[i].qty
    };
    prod.add(_prod);
  } 
  final url = (server+"customer/update/"+id.toString());
  
  Response response = await put(Uri.encodeFull(url), body: json.encode(prod), headers: {"Content-Type": "application/json"});
  print(response.body);
  return response.statusCode == 200; 
}