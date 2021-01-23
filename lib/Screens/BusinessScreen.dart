import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';

class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Stack(
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
                            onPressed: () => {},
                          ),
                        ),
                        title: Text(
                          "Business",
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
                            onPressed: () => {},
                          ),
                        )
                      ),
                ),
              ],
            ),
            
          ]
         )
        )
    );
  }
}