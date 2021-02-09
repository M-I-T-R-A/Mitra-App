import 'package:Mitra/Screens/AddKhata.dart';
import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Screens/Notifications.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KhataScreen extends StatefulWidget {
  @override
  _KhataScreenState createState() => _KhataScreenState();
}

class _KhataScreenState extends State<KhataScreen> {
  double w, h, slat, slng;
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    init();
  }
  String customerName;
  int customerMobile;

  init() async {

  }
  int value = 2;

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }
  _buildRow(int index) {
    return Text("Item " + index.toString());
  }
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavigationDrawer(),
        floatingActionButton: new FloatingActionButton(
          heroTag: null,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: AddKhata()));
          },
          tooltip: 'Add Khata',
          child: new Icon(Icons.add),
        ),
        body: Column(
          children: [
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
                          "Khata",
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
          Container(
            height: 0.25 * h,
            decoration: BoxDecoration(
              boxShadow: [ 
                BoxShadow(
                  color: primaryColor,
                  blurRadius: 15.0,
                  spreadRadius: -20
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10, 
                      horizontal: 20
                    ),
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Mr. Ajinkya Taranekar',
                      style: TextStyle(
                        fontSize: 20
                      )
                    ),
                    subtitle: Text('27/01/2021 \n6:30 PM',
                      style: TextStyle(
                        fontSize: 12, 
                        color: grey
                      )
                    ),
                    trailing: Text("₹198",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 0.05 * w
                      )
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        color: primaryColor,
                        child: Text(
                          "Contact",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 0.03 * w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.04 * w, vertical: 0.01 * h),
                      ),
                      SizedBox(
                        width: 0.2 * w,
                      ),
                      RaisedButton(
                        onPressed: () => {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => View()))
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        color: primaryColor,
                        child: Text(
                          "View",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 0.03 * w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.06 * w, vertical: 0.01 * h),
                      ),
                    ],
                  )

                ],
              )
            ),
          ),
        ],
      ),
    
    );
  }
}