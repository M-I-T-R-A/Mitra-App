import 'package:Mitra/Services/Login.dart';
import 'package:Mitra/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:Mitra/Services/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
  await Init.initialize();
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _versionName = 'v 0.0.1';
  final splashDelay = 3;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  @override
  void initState() {
    super.initState();

    _loadWidget();
    _firebaseMessaging.configure(
      onMessage: (message) async{
          print(message["notification"]["title"]);
          print("New Notification Alert");
      },
      onResume: (message) async{
        setState(() {
          print(message["data"]["title"]);
          print("Application opened from Notification");
        });

      },
    );
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Mitra()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              image: DecorationImage(
                  image: AssetImage("assets/images/store.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter),
            ),
            child: null),
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 152, 218, 0.85),
            ),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/toran.png"),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter),
                    ),
                    child: null
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5, right: 5),
                      child: Icon(
                        FlutterIcons.shop_ent,
                        color: white,
                        size: 40,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: RichText(
                          text: TextSpan(
                            semanticsLabel: "Mitra",
                            text: 'Mitra \n',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                height: 1.15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Khata Made Easy',
                                  style: TextStyle(
                                      color: Colors.grey[350],
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ))
                  ],
                ),
              ],
            )
          ),
      ],
    ));
  }
}

class Mitra extends StatefulWidget {
  @override
  _MitraState createState() => _MitraState();
}

class _MitraState extends State<Mitra> {

  int login = 0;
  LoginFunctions loginFunctions;
  
  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setInt("login", 0);
    int _login = prefs.getInt('login') ?? 0;
    setState(() {
      login = _login;
    });
  }

  void initState() {
    super.initState();
    init();
  }

  void init () async{
    checkLogin();
    print(login);
    loginFunctions = new LoginFunctions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginFunctions.getHomeScreen(login),
    );
  }
}