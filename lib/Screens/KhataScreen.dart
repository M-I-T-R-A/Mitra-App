import 'package:Mitra/Models/Khata.dart';
import 'package:Mitra/Screens/AddKhata.dart';
import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Screens/Notifications.dart';
import 'package:Mitra/Services/GenerateKhataPdf.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class KhataScreen extends StatefulWidget {
  @override
  _KhataScreenState createState() => _KhataScreenState();
}

class _KhataScreenState extends State<KhataScreen> {
  double w, h, slat, slng;
  SharedPreferences prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    init();
  }
  String customerName;
  int customerMobile;
  List<Khata> khata;
  init() async {
    List<Khata> temp = await getAllKhata();
    setState(() {
      khata = temp;
    });
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
            this.khata.length !=0 ? Expanded(
            child: ListView.builder(
              itemCount: this.khata.length,
              itemBuilder: (context, i) {
                return Container(
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
                          title: Text(this.khata[i].shopCustomer.name,
                            style: TextStyle(
                              fontSize: 20
                            )
                          ),
                          subtitle: Text(this.khata[i].timeOfSell.toString(),
                            style: TextStyle(
                              fontSize: 12, 
                              color: grey
                            )
                          ),
                          trailing: Text("₹ " + this.khata[i].shopCustomer.creditAmount.toString(),
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
                                _launchCaller(this.khata[i].shopCustomer.phoneNumber.toString());
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
                              onPressed: () {
                                _launchPDF(this.khata[i].invoiceImageUrl);  
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
                );
              },
            ) 
          ): Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/khataAll.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter),
                  ),
                  child: null
            ),
        ],
      ),
    
    );
  }
  _launchCaller(String mobile) async {
    String url = "tel:"+mobile;   
    if (await canLaunch(url)) {
       await launch(url);
    } else {
      throw 'Could not launch $url';
    }   
  }
  _launchPDF(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}