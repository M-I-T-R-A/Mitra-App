import 'dart:io';

import 'package:Mitra/Screens/LocationPicker.dart';
import 'package:Mitra/Screens/Verification/StoreDetailsScreen.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/Gurrantor.dart' as gurrantor;
import 'package:Mitra/Services/KYC.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GurrantorDetails extends StatefulWidget {
  @override
  _GurrantorDetailsState createState() => _GurrantorDetailsState();
}

class _GurrantorDetailsState extends State<GurrantorDetails> {
  double annualIncome;
  var location = [];
  var gender = "Male";
  String firstLine;
  String secondLine;
  double latitude;
  double longitude;
  int pincode;
  String city;
  String state;
  var value;
  
  SharedPreferences prefs;
  File aadharFront;
  File aadharBack;
  
  String aadharFrontURL;
  String aadharBackURL;
  String path;

  var validAadharNo = false;
  final picker = ImagePicker();

  String aadharNo;
  String name;
  String mobileNumber;

  @override
  void initState() {
    super.initState();
    location.insert(0, "Residence Address");
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
                        "3. Gurrantor Details",
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
                            hintText: "Name",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.name = value;
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
                            hintText: "Mobile Number",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.mobileNumber = value;
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
                            hintText: "Annual Income",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.annualIncome = double.parse(value);
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
                            value: this.gender,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.black
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                this.gender = newValue;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
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
                            "Aadhar Number",
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
                              hintText: "Enter 12-digit aadhar number",
                            ),
                            onChanged: (value) {
                              if (value.length >= 12){
                                bool status = aadharCardVerification(value);
                                if (status == true){
                                  this.aadharNo = value;
                                  setState(() {
                                      validAadharNo = true;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                if (validAadharNo == false)
                                  showToast("Type Aadhar No first", grey, error);
                                else{
                                  path = await getImage();

                                  bool status = await aadharCardMatch(path, this.aadharNo);
                                  if (status == true){
                                    setState(() {
                                      aadharFront = File(path);
                                    });
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String id = prefs.getString("firebase_id");
                                    aadharFrontURL = await uploadFile(aadharFront, "$id/Gurrantor/Aadhar/");
                                    showToast("Aadhar Card Front Image Uploaded", grey, primaryColor);
                                  }
                                }
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Aadhar Front",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: aadharFrontURL == null
                                  ? Container(
                                      child: SpinKitDoubleBounce(
                                        color: primaryColor,
                                        size: 25.0,
                                      )
                                    )
                                  : Image.file(aadharFront,
                                      height: 45.0,
                                      width: 45.0)
                                    ), 
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                if (aadharNo == null)
                                  showToast("Type Aadhar No first", grey, error);
                                else{
                                  path = await getImage();
                                  // bool status = await aadharCardMatch(path, this.aadharNo);
                                  // print(status);
                                  bool status = true;
                                  if (status == true){
                                    setState(() {
                                      aadharBack  = File(path);
                                    });
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String id = prefs.getString("firebase_id");
                                    aadharBackURL = await uploadFile(aadharBack, "$id/Gurrantor/Aadhar/");
                                    print(aadharBackURL);
                                    showToast("Aadhar Card Back Image Uploaded", grey, primaryColor);
                                  }
                                }
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Aadhar Back",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: aadharBackURL == null
                                  ? Container(
                                      child: SpinKitDoubleBounce(
                                        color: primaryColor,
                                        size: 25.0,
                                      )
                                    )
                                  : Image.file(aadharBack,
                                      height: 45.0,
                                      width: 45.0)
                                    ),
                          ],
                        ),
                        SizedBox(height: 15,)
                      ],
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
                          // bool status = await panCardMatch(path, this.electrictiyBillAmount);
                          bool status = true;
                          if (status == true){
                            setState(() {
                              electricityBill  = File(path);
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            String id = prefs.getString("firebase_id");
                            electricityBillURL = await uploadFile(electricityBill, "$id/Gurrantor/ElectricityBill");
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
                            ? Container(
                                child: SpinKitDoubleBounce(
                                  color: primaryColor,
                                  size: 25.0,
                                )
                              )
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
              
              RaisedButton(
                onPressed: () async{
                  bool confirm = gurrantor.confirmation(context, electricityBill, aadharFront, aadharBack);
                    if (confirm == true){
                      int status = await gurrantor.gurrantorRegistration(name, mobileNumber, gender, annualIncome, firstLine, secondLine, latitude, longitude, pincode, city, state, electricityBillAmount, electricityBillURL, aadharNo, aadharFrontURL, aadharBackURL);
                      if (status == 4){
                          Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              child: StoreDetails()));
                    }
                  }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: primaryColor,
              elevation: 5,
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 0.1 * screenWidth, vertical: 0.01 * screenHeight),
            )
              
          ],
        ),
      ),
    );
  }
}