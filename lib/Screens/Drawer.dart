import 'package:Mitra/Services/Login.dart';
import 'package:flutter/material.dart';
import 'package:Mitra/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:Mitra/Screens/Home.dart';

class NavigationDrawer extends StatelessWidget {
  LoginFunctions loginFunctions = new LoginFunctions();
 @override
 Widget build(BuildContext context) {
   return Drawer(
     child: ListView(
       padding: EdgeInsets.zero,
       children: <Widget>[
         DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:  AssetImage('assets/images/drawer.png'))),
            child: Stack(children: <Widget>[
              Positioned(
                  bottom: -5.0,
                  left: 16.0,
                  child: Text("Welcome to Mitra!",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500))),
            ])
          ),
          SizedBox(height: 10,),
         createDrawerBodyItem(
           icon: Icons.home,
           title: 'Home',
           onTap: () =>
               Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: Home(index: 0))),
         ),
         createDrawerBodyItem(
           icon: Icons.settings,
           title: 'Settings',
           onTap: () =>
               Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: Home(index: 3))),
         ),
         createDrawerBodyItem(
           icon: Icons.book,
           title: 'Khata',
           onTap: () =>
               Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: Home(index: 1))),
         ),
         Divider(),
         createDrawerBodyItem(
           icon: Icons.store_mall_directory_outlined,
           title: 'Your Store',
           onTap: () =>
               Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: Home(index: 2))),
         ),
         ListTile(
           title: Text('App version .0.0.1'),
           onTap: () {},
         ),
         ListTile(
           title: Text('Logout'),
           onTap: () {
             loginFunctions.signOut(context);
           },
         ),
       ],
     ),
   );
 }
 Widget createDrawerBodyItem({IconData icon, String title, GestureTapCallback onTap}) {
  return ListTile(
      leading: Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(
            icon,
            size: 24,
            color: Colors.black,
          )
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              letterSpacing: 1.3),
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
              Icons.arrow_forward_ios,
              size: 24,
              color: Colors.black,
            ),
        ),
        onTap: onTap,
      );
  }
}
