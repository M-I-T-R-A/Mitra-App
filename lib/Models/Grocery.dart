import 'dart:core';

class Category{
  String name;
  String dname;
  String image;
  Category({this.name, this.dname, this.image});
}

class Product {
  String category;
  String name;
  double pricePerUnit;
  int quantity;
  String unit;

  Product(
      {this.category, this.name, this.pricePerUnit, this.quantity, this.unit});

  Product.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    name = json['name'];
    pricePerUnit = json['pricePerUnit'];
    quantity = json['quantity'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['name'] = this.name;
    data['pricePerUnit'] = this.pricePerUnit;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    return data;
  }
}

class Cartprod{
  int id;
  String name;
  int qty;
  String desc;
  Map toJson() => {
    'id': id,
    'quantity': qty
  };
  Cartprod({this.id, this.name, this.qty, this.desc});
}