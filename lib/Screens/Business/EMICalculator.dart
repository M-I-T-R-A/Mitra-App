import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/constants.dart';
import "package:flutter/material.dart";
import "dart:math";

class EMICalculatorScreen extends StatefulWidget {
  @override
  EMICalculatorScreenState createState() => EMICalculatorScreenState();
}

class EMICalculatorScreenState extends State<EMICalculatorScreen> {

  List _tenureTypes = [ 'Month(s)', 'Year(s)' ];
  String _tenureType = "Year(s)";
  String _emiResult = "";

  final TextEditingController _principalAmount = TextEditingController();
  final TextEditingController _interestRate = TextEditingController();
  final TextEditingController _tenure = TextEditingController();

  bool _switchValue = true;
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'EMI Calculator!',
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
                      image: AssetImage("assets/images/calculator.png"),
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
                        controller: _principalAmount,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Principal Amount",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
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
                        controller: _interestRate,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Interest Rate",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
            Container(
                width: 0.8 * screenWidth,
                margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -8),
                  ],
                ),
                child:Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _tenure,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Tenure",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          )
                        ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    _tenureType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Switch(
                    value: _switchValue,
                    onChanged: (bool value) {
                      print(value);

                      if( value ) {
                        _tenureType = _tenureTypes[1];
                      } else {
                        _tenureType = _tenureTypes[0];
                      }

                      setState(() {
                        _switchValue = value;
                      });
                    }

                  )
                ]
              ),
              Flexible(
                fit: FlexFit.loose,
                child: FlatButton(
                  onPressed: _handleCalculation,
                  child: Text("Calculate"),
                  color: primaryColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 24.0, right: 24.0)
                )
              ),

              emiResultsWidget(_emiResult)
              
            ],
          )
        )
      )
    );
  }

  void _handleCalculation() {

    //  A = Payment amount per period
    //  P = Initial Principal (loan amount)
    //  r = interest rate
    //  n = total number of payments or periods
    print(_principalAmount.text);

    if (_principalAmount.text == '' || this._interestRate.text == '' || this._tenure.text == '' ){
      showToast("Check fields", Colors.grey[200], error);  
      return;
    }
    double A = 0.0;
    int P = int.parse(_principalAmount.text); 
    double r = int.parse(_interestRate.text) / 12 / 100;
    int n = _tenureType == "Year(s)" ? int.parse(_tenure.text) * 12  : int.parse(_tenure.text);

    A = (P * r * pow((1+r), n) / ( pow((1+r),n) -1));
    
    _emiResult = A.toStringAsFixed(2);

    setState(() {

    });
  }


  Widget emiResultsWidget(emiResult) {

    bool canShow = false;
    String _emiResult = emiResult;

    if( _emiResult.length > 0 ) {
      canShow = true;
    }
    return
    Container(
      margin: EdgeInsets.only(top: 40.0),
      child: canShow ? Column(
        children: [
          Text("Your Monthly EMI is",
            style: TextStyle(
              fontSize: 18.0,
              color: primaryColor,
              fontWeight: FontWeight.bold
            )
          ),
          Container(
            child: Text("₹ " + _emiResult,
            style: TextStyle(
              fontSize: 50.0,
              fontWeight: FontWeight.bold
            ))
          )
        ]
      ) : Container()
    );
  }
}