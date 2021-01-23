import 'package:Mitra/Screens/HomeScreen.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Home extends StatefulWidget {
  final int index;
  Home({this.index});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String firstName;
  
  @override
  void initState() {
    super.initState();
    initialise();
  }

  int _selectedIndex =0;
  void initialise() async {
    _selectedIndex = widget.index; 
  }
  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  List<Widget> _widgetOptions = [HomeScreen(), HomeScreen(), HomeScreen(), HomeScreen()];

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.home_ant),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.book_ant),
            title: Text('Khata'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.shop_ent),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterIcons.setting_ant),
            title: Text('Settings'),
          ),
        ],
        unselectedItemColor: grey,
        selectedItemColor: primaryColor,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(size: 40, color: primaryColor),
      ),
    );
  }
}