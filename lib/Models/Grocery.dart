import 'dart:core';

class Category{
  String name;
  String dname;
  String image;
  Category({this.name, this.dname, this.image});
}

class Product{
  String name;
  String desc;
  int id;
  Product({this.name, this.desc, this.id});
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