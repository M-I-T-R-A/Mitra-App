import 'package:Mitra/Screens/BusinessScreen.dart';
import 'package:Mitra/Screens/ChatbotScreen.dart';
import 'package:Mitra/Screens/HomeScreen.dart';
import 'package:Mitra/Screens/KhataScreen.dart';
import 'package:Mitra/Screens/SettingsScreen.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  final int index;
  Home({this.index});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _bottomNavigationKey = GlobalKey();
  String firstName;
  
  @override
  void initState() {
    super.initState();
    initialise();
  }

  int _selectedIndex = 0;
  void initialise() async {
    _selectedIndex = widget.index; 
  }
  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  List<Widget> _widgetOptions = [HomeScreen(), KhataScreen(), ChatBotScreen(), BusinessScreen(), SettingScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child:  _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: widget.index,
        height: 50.0,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        letIndexChange: (index) => true,
        items: <Widget>[
          Icon(FlutterIcons.home_ant),
          Icon(FlutterIcons.book_ant),
          Icon(Icons.chat_bubble_outline),
          Icon(FlutterIcons.shop_ent),
          Icon(FlutterIcons.setting_ant)
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}