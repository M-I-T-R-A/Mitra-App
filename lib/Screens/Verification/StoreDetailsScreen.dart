import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';

class StoreDetails extends StatefulWidget {
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  double w, h;
  String address;
  String city;
  String zipcode;
  String gstin_id;
  String name;
  String contact_name;
  String state;
    
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 0.05 * h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: primaryColor),
                  Text(
                    "Let's get started",
                    style: TextStyle(fontSize: 0.05 * w),
                  ),
                ],
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Store name",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.name = value;
                            },
                        
                        ),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Store address",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.address = value;
                            },),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "City",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.city = value;
                            },),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "State",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.state = value;
                            },),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Pincode",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.zipcode = value;
                            },),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Owner",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.contact_name = value;
                            },),
                  ),
                ),
              ),
              Container(
                width: 0.8 * w,
                margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "GSTIN",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 18)),
                        style: TextStyle(
                              fontSize: 18,
                            ),
                            onChanged: (value) {
                                  this.gstin_id = value;
                            },),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () => {
                  //
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: primaryColor,
              elevation: 5,
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.01 * h),
            )
          ],
        ),
      ),
    );
  }
}