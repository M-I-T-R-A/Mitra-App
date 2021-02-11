import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Services/Business.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';

class BookLoanScreen extends StatefulWidget {
  @override
  BookLoanScreenState createState() => BookLoanScreenState();
}

class BookLoanScreenState extends State<BookLoanScreen> {

  final TextEditingController _amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Book Loan',
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

      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/loan.png"),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter),
                ),
                child: null
              ),
              Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _amount,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Amount",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: FlatButton(
                  onPressed: () async {
                    String approval = await bookLoan(double.parse(_amount.text));
                    if (approval == "APPROVED")
                      showToast("Loan is Approved, see options below!", grey, primaryColor);
                    else if (approval == "WAITING")
                      showToast("Please wait we are checking, please consider!", grey, primaryColor);
                    else
                      showToast("Your loan is rejected!", grey, primaryColor);
                     Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightWithFade,
                          child: Home(index:2)));
                  },
                  child: Text("Book Loan"),
                  color: primaryColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 24.0, right: 24.0)
                )
              ),

              resultsWidget()
              
            ],
          )
        )
      )
    );
  }

  Widget resultsWidget() {

    bool canShow = false;
    String _emiResult = "emiResult";

    if( _emiResult.length > 0 ) {
      canShow = true;
    }
    return
    Container(
      margin: EdgeInsets.only(top: 40.0),
      child: canShow ? Column(
        children: [
          Text("Loan Options",
            style: TextStyle(
              fontSize: 18.0,
              color: primaryColor,
              fontWeight: FontWeight.bold
            )
          )
        ]
      ) : Container()
    );
  }
}