import 'dart:io';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Screens/Verification/StoreDetailsScreen.dart';
import 'package:Mitra/Services/KYC.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class KYCScreen extends StatefulWidget {
  @override
  _KYCScreenState createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  @override
  void initState() {
    super.initState();
  }
  File aadharFront;
  File aadharBack;
  File panFront;
  File panBack;
  final picker = ImagePicker();

  String aadharNo;
  String panNo;
  @override
  Widget build(BuildContext context) {
    Future<String> getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      return pickedFile.path;
    }

    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    //print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    String path;
    return Scaffold(
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: ListTile(
                        title: Text(
                          "Verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
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
                          "1. Know Your Customer",
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
            Container(
                height: leftHeight,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/kyc.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                        ),
                        child: null
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
                                if (status == true)
                                  this.aadharNo = value;
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
                                path = await getImage();

                                bool status = aadharCardMatch(path, this.aadharNo);
                                if (status == true){
                                  setState(() {
                                    aadharFront = File(path);
                                  });
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
                              child: aadharFront == null
                                  ? SizedBox()
                                  : Image.file(aadharFront,
                                      height: 45.0,
                                      width: 45.0)
                                    ), 
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                path = await getImage();
                                setState(() {
                                  aadharBack  = File(path);
                                });
                                
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
                              child: aadharBack == null
                                  ? SizedBox()
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
                            "PAN Number",
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
                              hintText: "Enter 12-digit pan number",
                            ),
                            onChanged: (value) {
                                  this.panNo = value;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                path = await getImage();
                                setState(() {
                                  panFront  = File(path);
                                });
                                var _extractText = await TesseractOcr.extractText(path);
                                print(_extractText);
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "PAN Front",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: panFront == null
                                  ? SizedBox()
                                  : Image.file(panFront,
                                      height: 45.0,
                                      width: 45.0)
                                    ), 
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                path = await getImage();
                                setState(() {
                                  panBack  = File(path);
                                });
                                var _extractText = await TesseractOcr.extractText(path);
                                print(_extractText);
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "PAN Back",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: panBack == null
                                  ? SizedBox()
                                  : Image.file(panBack,
                                      height: 45.0,
                                      width: 45.0)
                                    ),
                          ],
                        ),
                        SizedBox(height: 15,)
                      ],
                    ),
                    
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45,
                        child: RaisedButton(
                          // padding: EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                          onPressed: () async {
                            bool confirm = confirmation(context, aadharFront, aadharBack, panFront, panBack);
                            if (confirm == true){
                              //post method
                              bool status = true;
                              if (status == true){
                                Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRightWithFade,
                                    child: StoreDetails()));
                              }
                            }
                          },
                          color: primaryColor,
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Confirm",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
          ]
         )
        )
    );
  }
}