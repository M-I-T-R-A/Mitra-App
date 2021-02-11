import 'dart:async';
import 'dart:convert';

import 'package:Mitra/Screens/OnBoarding/OTPScreen.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:Mitra/constants.dart';
import 'package:Mitra/Screens/OnBoarding/LoginScreen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName;
  String lastName;
  String mobileNo;
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void register() async {
    if (this.mobileNo.length != 10){
      _btnController.error();
      showToast("Mobile Number is not valid", Colors.grey[200], error);  
      _btnController.reset();
    }
    else{
      LoginFunctions loginFunction = new LoginFunctions();  
      Timer(Duration(seconds: 3), () async{
        bool status = await loginFunction.checkMobile(mobileNo);
        if (status == true){
          _btnController.error();
          print("Old User Login");
          showToast( "Seems you are already registered, please login", grey, primaryColor);        
          _btnController.reset();
        }
        else{
          _btnController.success();
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: OTPScreen(mobileNo: this.mobileNo, mode: "Register")));    
        }
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: null,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                height: MediaQuery.of(context).size.height,
                duration: Duration(milliseconds: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/register.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                        ),
                        child: null
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      child: Text(
                        "New Here?",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 15, bottom: 5),
                              child: Text(
                                "First Name",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  child:  TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      borderSide:
                                          const BorderSide(color: Colors.transparent, width: 0.0),
                                    ),
                                    border: OutlineInputBorder(
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
                                    hintText: "Enter your first name",
                                  ),
                                  onChanged: (value) async{
                                    if (value.length == 0)
                                      showToast("Please Enter your First Name", grey, error);
                                    else{
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setString('firstName', value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 15, bottom: 5),
                              child: Text(
                                "Last Name",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      borderSide:
                                          const BorderSide(color: Colors.transparent, width: 0.0),
                                    ),
                                    border: OutlineInputBorder(
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
                                    hintText: "Enter your last name",
                                  ),
                                  onChanged: (value) async{
                                    if (value.length == 0)
                                      showToast("Please Enter Your Last Name", grey, error);
                                    else{
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setString('lastName', value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 15, bottom: 5),
                              child: Text(
                                "Mobile Number",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(80),
                                      borderSide:
                                          const BorderSide(color: Colors.transparent, width: 0.0),
                                    ),
                                    border: OutlineInputBorder(
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
                                    hintText: "Enter your 10-digit mobile number",
                                  ),
                                  onChanged: (value) {
                                    this.mobileNo = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 45,
                        child: RoundedLoadingButton(
                            color: primaryColor,
                            borderRadius: 35,
                            child: Text(
                              'Send OTP!', 
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
              Positioned.fill(
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(
                        height: 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Already have a account?",
                            style: TextStyle(),
                          ),
                          FlatButton(
                            padding: EdgeInsets.only(right: 20),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeftWithFade,
                                      child: LoginScreen()));
                            },
                            child: Text(
                              "Login ",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
