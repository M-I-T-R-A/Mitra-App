import 'dart:io';
import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  
  @override
  void initState() {
    super.initState();
    initialise();
  }
  
  void initialise() async {

  }


  var notification;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(
            'Notifications!',
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
      drawer: NavigationDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 32, right:32, top: 16, bottom: 16),
            color: Colors.grey[100],
            child: Text("0 Results Found", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),),
          ), 

          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/notification.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              child: null
            
          )
        ],
      ),
    );
  }
}