import 'dart:convert';
import 'package:Mitra/Models/Customer.dart';
import 'package:Mitra/constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Customer> getCustomerProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt("id");
  final url = (server+"customer/"+id.toString());
  Response response = await get(Uri.encodeFull(url), headers: {"Content-Type": "application/json"});
  print(response.body);
  return new Customer.fromJson(jsonDecode(response.body));
}  