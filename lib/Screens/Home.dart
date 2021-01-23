import 'package:Mitra/Screens/BusinessScreen.dart';
import 'package:Mitra/Screens/ChatbotScreen.dart';
import 'package:Mitra/Screens/HomeScreen.dart';
import 'package:Mitra/Screens/KhataScreen.dart';
import 'package:Mitra/Screens/SettingsScreen.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

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
  List<Widget> _widgetOptions = [HomeScreen(), KhataScreen(), BusinessScreen(), SettingScreen(), ChatbotScreen()];

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
      bottomNavigationBar: BottomAppBar(
          notchMargin: 2.0,
          shape: CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 100,
            child: BottomNavigationBar(
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
          ),
        ), 
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: new FloatingActionButton(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          onPressed:(){  
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: _widgetOptions.elementAt(4)));
          },
          tooltip: 'Chat with Mitra',
          child: new Icon(FlutterIcons.chat_mco),
        )
    );
  }
}