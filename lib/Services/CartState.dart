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

  Future addData(Product product, int qty) async {
    await store.add(database, {'name': product.name,'category': product.category, 'qty': qty, 'desc': product.unit, 'price': product.pricePerUnit});
  }

  Future<List<Cartprod>> getAll() async{
    List<Cartprod> prod = [];
    try {
      final data = await store.find(database);
      for(int i=0;i<data.length;i++) {
        Cartprod _prod = new Cartprod(
          name: data[i]["name"],
          category: data[i]["category"],
          qty: data[i]["qty"], 
          desc: data[i]['desc'],
          price : data[i]['price']);
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

updateProduct(List<Cartprod> products, String supplierName, String supplierMobile, String supplierImageURL, String date) async{
  List<dynamic> prod = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  
  for(int i=0;i<products.length;i++) {
    var _prod = {
      "name": products[i].name,
      "quantity": products[i].qty,
      "category": products[i].category,
      "pricePerUnit": products[i].price,
      "unit": products[i].desc
    };
    prod.add(_prod);
  } 

  final purchase = {
    "customerId": id,
    "purchasedItemBillDTO": {
      "imageUrl": supplierImageURL,
      "supplierMobile": supplierMobile,
      "supplierName": supplierName
    },
    "purchasedItemStockDTO": {
      "dateOfPurchase": date,
      "stockOfItems": prod
    }
  };
  print(purchase);
  final url = (server+"shop/purchase");
  
  Response response = await post(Uri.encodeFull(url), body: json.encode(purchase), headers: {"Content-Type": "application/json"});
  print(response.body);
  return response.statusCode == 200; 
}