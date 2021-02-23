import 'dart:async';
import 'dart:io';

import 'package:Mitra/Screens/LocationPicker.dart';
import 'package:Mitra/Screens/Verification/BankStatementsScreen.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/StoreDetails.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreDetails extends StatefulWidget {
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  var location = [];
  var type = "Grocery";
  String firstLine;
  String secondLine;
  double latitude;
  double longitude;
  int pincode;
  String city;
  String state;
  var value;
  SharedPreferences prefs;
  String gstin;
  int contactNumber;
  String storeName;
  String rent = "Purchased";
  double areaPerSqft;
final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void register() async {
    if (this.gstin == null || this.areaPerSqft == null || this.storeName == null ||  this.contactNumber == null || this.location.length == 1 || this.electricityBillAmount == null){
      _btnController.error();
      showToast("Check store details field", Colors.grey[200], error);  
      _btnController.reset();
      return;
    }

    Timer(Duration(seconds: 3), () async{
        bool confirm = confirmation(context, electricityBill);
        if (confirm == true){
          int status = await storeRegistration(type, gstin, areaPerSqft, rent, contactNumber, storeName,  firstLine, secondLine, latitude, longitude, pincode, city, state, electricityBillAmount, electricityBillURL);
          if (status == 5){
             _btnController.success();
            Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: BankStatementScreen()));
          }
          else{
            _btnController.error();
              showToast( "Huh, some glitch, please wait...", grey, primaryColor);        
            _btnController.reset();  
          }
        }
        else{
            _btnController.error();
              showToast( "Some documents are yet to upload...", grey, primaryColor);        
            _btnController.reset();  
        }
      });
    }

  @override
  void initState() {
    super.initState();
    location.insert(0, "Store Address");
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cnt', 0);
  }

  setStart(var value) async {
    if(value.length > 0) {
      setState(() {
        location = value;
        firstLine = location[0];
        secondLine = location[1];
        latitude = location[2];
        longitude = location[3];
        city = location[4];
        state = location[5];
        pincode = location[6];
      });
    }
  }
  
  File electricityBill;
  String electricityBillURL;
  double electricityBillAmount;
  final picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    Future<String> getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      return pickedFile.path;
    }
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: ListTile(
                        title: Text(
                          "Verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: ListTile(
                      title: Text(
                        "4. Store Details",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            color: black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.3),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/details.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter),
                  ),
                  child: null
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "GSTIN",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.gstin = value;
                            },
                        
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contact Number",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.contactNumber = int.parse(value);
                            },
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Store Name",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.storeName = value;
                            },
                        
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Area Per Sqft",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.areaPerSqft = double.parse(value);
                            },
                        ),
                  ),
                ),
              ),
            
              Card(
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPicker(header: "Enter Location"))).then((value) => setStart(value))
                  },
                  child: Container(
                    width: 0.8 *  MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Center(
                      child: Text(location[0].toString(),
                        style: TextStyle(
                          fontSize: 0.02 *  MediaQuery.of(context).size.height,
                          color: grey
                        )
                      ),
                    )
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
                            value: this.type,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                this.type = newValue;
                              });
                            },
                            items: <String>['Grocery', 'Clothing', 'Medical', 'VegetableAndFruit']
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
                            value: this.rent,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                this.rent = newValue;
                              });
                            },
                            items: <String>['Purchased', 'Rented']
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
              Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      shadowColor: primaryColor,
                      elevation: 2.0,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                          child: Text(
                            "Electricity Bill",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide:
                                    const BorderSide(color: Colors.transparent, width: 0.0),
                              ),
                              // disabledBorder: new InputBorder(borderSide: BorderSide.none),
                              hintStyle: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                              filled: true,
                              fillColor: darkGrey,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                              hintText: "Enter electricity bill amount of home",
                            ),
                            onChanged: (value) {
                                    this.electricityBillAmount = double.parse(value);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                var path = await getImage();
                                showToast("Uploading your documents, just a moment please...", grey, primaryColor);
                                  
                                // bool status = await panCardMatch(path, this.electrictiyBillAmount);
                                bool status = true;
                                if (status == true){
                                  setState(() {
                                    electricityBill  = File(path);
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String id = prefs.getString("firebase_id");
                                  electricityBillURL = await uploadFile(electricityBill, "$id/ElectricityBill/Store");
                                  showToast("Electricity Bill Image Uploaded", grey, primaryColor);
                                }
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Electricity Bill",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: electricityBillURL == null
                                  ? Center()
                                  : Image.file(electricityBill,
                                      height: 45.0,
                                      width: 45.0)
                                    ),
                          ],
                        ),
                        SizedBox(height: 15,)
                      ],
                    ),
                    
                    ),
                    
              SizedBox(height: 25,),
              Center(
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
                      onPressed: register,
                      width: 200,
                    ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}