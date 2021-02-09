import 'dart:convert';

import 'package:Mitra/Models/Customer.dart';
import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Screens/Notifications.dart';
import 'package:Mitra/Services/Customer.dart';
import 'package:Mitra/Widget/SettingsDivider.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Customer customer;

  @override
  void initState() {
    super.initState();
    initialise();
  }
  
  void initialise() async {
    Customer temp = await getCustomerProfile();
    setState(() {
      customer = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(),      
      body: customer != null ? SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: new Icon(
                              Icons.menu,
                              size: 24,
                              color: black,
                            ),
                            onPressed: () => _scaffoldKey.currentState.openDrawer(),
                          ),
                        ),
                        title: Text(
                          "Settings",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: new Icon(
                              Icons.notifications,
                              size: 24,
                              color: black,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRightWithFade,
                                    child: NotificationScreen()));
                            },
                          ),
                        )
                      ),
                ),
              ],
            ),
            SettingsDivider(dividerTitle: "PERSONAL"),
            Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Name",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(this.customer.name ?? "Not Given",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    )
                  ],
                )),
            Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Phone Number",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("+91 " + this.customer.phoneNumber.toString()  ?? "Not Given",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Residence Address",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(this.customer.residenceAddress.toString()  ?? "Not Given",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Mitra Verified",
                            style: TextStyle(color: primaryColor, fontSize: 12, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: this.customer.verified != null ?
                        Icon(Icons.verified_user, color: primaryColor) :
                        Container()
                    )
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: FlatButton(
                      child : Text("Update Account", style: TextStyle(color: white, fontWeight: FontWeight.w400),),
                      onPressed: (){
                        
                      },
                      color: primaryColor,
                )
              ),
            Padding(padding: EdgeInsets.all(8)),
            SettingsDivider(dividerTitle: "NOTIFICATIONS"),
            Container(
                margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("Push Notifications",
                            style: TextStyle(color: Colors.black, fontSize: 15)),
                      ),
                    ),
                    Container(
                      child: Switch(value: true, onChanged: (bool value) {}),
                    )
                  ],
                )),
            SettingsDivider(dividerTitle: "OTHER"),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
              alignment: Alignment.topLeft,
              child: Text("Log Out",
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
              alignment: Alignment.topLeft,
              child: Text("Refer the App! ",
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            ),
            Padding(padding: EdgeInsets.all(8)),
            SettingsDivider(dividerTitle: "FEEDBACK"),
            Container(
              margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
              alignment: Alignment.topLeft,
              child: Text("Chat With Us",
                  style: TextStyle(color: Colors.black, fontSize: 15)),
            ),
          ],
        ),
      ): Container(
            child: SpinKitDoubleBounce(
              color: primaryColor,
              size: 50.0,
            )
          ),
    );
  }
}