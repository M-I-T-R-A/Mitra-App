import 'dart:convert';

import 'package:Mitra/Screens/OnBoarding/OTPScreen.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:Mitra/constants.dart';
import 'package:Mitra/Screens/OnBoarding/RegisterScreen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String mobileNo;
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void login() async {
    if (this.mobileNo.length != 10){
      _btnController.error();
      showToast("Mobile Number is not valid", Colors.grey[200], error);  
      _btnController.reset();
    }
    else{
      LoginFunctions loginFunction = new LoginFunctions();  
      Timer(Duration(seconds: 3), () async{
          bool status = await loginFunction.checkMobile(mobileNo);
          if (status == false){
            _btnController.error();
            print("New User Login");
            showToast("Seems you are new here, please register", Colors.grey[200], primaryColor);
                  
            _btnController.reset();
          }
          else{
            _btnController.success();
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: OTPScreen(mobileNo: this.mobileNo, mode: "Login")));
            
          }
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    //print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    return Scaffold(
        backgroundColor: white,
        appBar: null,
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
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
                              image: AssetImage("assets/images/welcome.png"),
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
                        "Welcome Back",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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
                              hintText: "Enter 10-digit mobile number",
                            ),
                            onChanged: (value) {
                                  this.mobileNo = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
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
                            onPressed: login,
                            width: 200,
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have a account?"),
                          FlatButton(
                            padding: EdgeInsets.only(right: 20),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.leftToRightWithFade,
                                      child: RegisterScreen()));
                            },
                            child: Text(
                              "Register ",
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
          ),
        ));
  }
}
