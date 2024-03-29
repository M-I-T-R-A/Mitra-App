import 'dart:async';
import 'dart:io';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Screens/HomeScreen.dart';
import 'package:Mitra/Screens/Verification/StoreDetailsScreen.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/Services/WeeksPurchase.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeksPurchaseScreen extends StatefulWidget {
  @override
  _WeeksPurchaseScreenState createState() => _WeeksPurchaseScreenState();
}

class _WeeksPurchaseScreenState extends State<WeeksPurchaseScreen> {
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void register() async {
    Timer(Duration(seconds: 3), () async{
        bool confirm = confirmation(context, weekPurchase);
        if (confirm == true){
          //post method
          int status = await uploadFiles(weekPurchaseURL);
          if (status == 7){
            _btnController.success();
            Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: Home(index: 0)));
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
  }
  File weekPurchase;
  String weekPurchaseURL;
  final picker = ImagePicker();

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
                          "6. Week's Purchase",
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
                              image: AssetImage("assets/images/statements.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                        ),
                        child: null
                      ),
                    ),
                    SizedBox(height: 15,),
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
                        SizedBox(height: 15,),
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                          child: Text(
                            "Add Your Latest Week's Purchase",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
    
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                  path = await getImage();
                                  showToast("Uploading your documents, just a moment please...", grey, primaryColor);
                                  setState(() {
                                    weekPurchase = File(path);
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String id = prefs.getString("firebase_id");
                                  weekPurchaseURL = await uploadFile(weekPurchase, "$id/PassBook/");
                                  showToast("Week Purchase Image Uploaded", grey, primaryColor);
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "Week's Purchase",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Center(
                              child: weekPurchaseURL == null
                                  ? Center()
                                  : Image.file(weekPurchase,
                                      height: 45.0,
                                      width: 45.0)
                                    ), 
                          ],
                        ),
                        SizedBox(height: 35,)
                      ],
                    ),
                    
                    ),
                    
                    SizedBox(height: 35,),
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
              
          ]
         )
        )
    );
  }
}