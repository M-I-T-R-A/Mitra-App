import 'dart:async';

import 'package:Mitra/Models/Grocery.dart';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/Groceries.dart';
import 'package:Mitra/constants.dart';
import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddProductScreen extends StatefulWidget {
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productQuantity = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  List<String> allCategoryList;
  String  _productCategory = "";

  void initState() {
    super.initState();
    initstate();
  }


  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void purchase() async {
    
    if (this._productName.text == '' || this._productPrice.text == ''  || this._productDescription.text == ''  || this._productQuantity.text == ''  || this._productCategory.length == 0 ){
      _btnController.error();
      showToast("Check product details field", Colors.grey[200], error);  
      _btnController.reset();
      return;
    }

    Timer(Duration(seconds: 3), () async{
      Product product = new Product(name: _productName.text, pricePerUnit: double.parse(_productPrice.text), unit: _productDescription.text, quantity: int.parse(_productQuantity.text), category: _productCategory);
      bool status = await addProduct(product);
      if (status == true){
        _btnController.success();
          showToast("Product Added Successfully!", grey, primaryColor);
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: Home(index:0)));
      }
      if (status == false){
          _btnController.error();
        showToast("Please check your Product!", grey, primaryColor);
          _btnController.reset();  
       }
      });
    }

  initstate() async {
    List<dynamic> tmp = await getCategory();
    List<String> category = new List();
    for (int i = 0 ;  i < tmp.length; i++){
      category.add(tmp[i].name);
    }
    setState(() {
      allCategoryList = category;
       _productCategory = allCategoryList[0];
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Product!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,  
        ),

      body: allCategoryList != null ? Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/addProduct.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter),
                ),
                child: null
              ),
              Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        controller: _productName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Product Name",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
            Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        controller: _productDescription,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Product Decription",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
            Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child:Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _productQuantity,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Product Quantity",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
            Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child:Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _productPrice,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Product Price",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
            Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: DropdownButton<String>(
                            value: this._productCategory,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                this._productCategory = newValue;
                              });
                            },
                            items: allCategoryList
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                          ),
                  ),
                ),
              ),
                Flexible(
                fit: FlexFit.loose,
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 45,
                    child: RoundedLoadingButton(
                        color: primaryColor,
                        borderRadius: 35,
                        child: Text(
                          'Confirm!', 
                          style: TextStyle(
                            letterSpacing: 1,
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                            )
                          ),
                        controller: _btnController,
                        onPressed: purchase,
                        width: 200,
                      ),
                  ),
                ),
              ),
            ],
          )
        )
      ): Container(
            child: SpinKitDoubleBounce(
              color: primaryColor,
              size: 50.0,
            )
          ),
    );
  }
}