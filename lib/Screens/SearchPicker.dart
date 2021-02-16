import 'package:Mitra/Models/Grocery.dart';
import 'package:Mitra/Services/Groceries.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchPicker extends StatefulWidget {
  final String header;
  SearchPicker({this.header});
  @override
  _SearchPickerState createState() => _SearchPickerState();
}

class _SearchPickerState extends State<SearchPicker> {
  double w,h;
  
  String pattern = "";
  final TextEditingController _typeAheadController1 = TextEditingController();

  Product currentSearch;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.header,
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
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/search.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              child: null
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.1 * w, right: 0.1 * w, top: 0.05 * h),
            decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: primaryColor,
                  blurRadius: 15.0,
                  spreadRadius: -5
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: TextField(
                    autofocus: true,
                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter product name",
                      hintStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 18
                      ) 
                    ),
                    controller: this._typeAheadController1,
                    onChanged: (value) {
                      setState(() {
                        pattern = value;
                      });
                    },
                )
              ),
            ),
          ),
          FutureBuilder(
            future: pattern.length < 4 && pattern.length % 2 == 0 ? null : getProductByName(pattern),
            builder: (context, snapshot) => pattern.length < 4 && pattern.length % 2 == 0? Container() : 
              snapshot.hasData ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        currentSearch = snapshot.data[index];
                      });
                      print(currentSearch);
                      Navigator.pop(context, currentSearch);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text(snapshot.data[index].name + ', ' + snapshot.data[index].unit,
                        style: TextStyle(
                          fontSize: 16
                        )
                      )
                    ),
                  ),
                  itemCount: snapshot.data.length,
                )
              ) : SpinKitThreeBounce(
                  color: primaryColor,
                  size: 50.0,
                ),
          )
        ],
      ),
    );
  }
}