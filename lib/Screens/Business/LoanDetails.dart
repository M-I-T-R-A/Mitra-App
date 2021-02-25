import 'dart:async';
import 'package:Mitra/constants.dart';
import "package:flutter/material.dart";

class LoanDetailsScreen extends StatefulWidget {
  final  Map<String, dynamic> loan;
  LoanDetailsScreen({this.loan});
  @override
  LoanDetailsScreenState createState() => LoanDetailsScreenState();
}

class LoanDetailsScreenState extends State<LoanDetailsScreen> {

  
  @override
  Widget build(BuildContext context) {
    print(widget.loan);
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
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Demanded Amount",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Container(
                    child: Text("₹ " + widget.loan["demandedAmount"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ))
                  )
                ]
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Status",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: primaryColor,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Container(
                    child: Text( widget.loan["approval"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold
                    ))
                  )
                ]
              ),
              SizedBox(height: 15,),
              widget.loan["approvedInstantLoan"] != null ? 
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Approved Amount",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Container(
                        child: Text("₹ " + widget.loan["approvedInstantLoan"]["approvedAmount"].toString() ?? "NA",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ))
                      )
                    ]
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Rate of Interest",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Container(
                        child: Text(widget.loan["approvedInstantLoan"]["rateOfInterest"].toString() + ' %' ?? "NA",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ))
                      )
                    ]
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Time Factor",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Container(
                        child: Text(widget.loan["approvedInstantLoan"]["timeFactor"].toString() ?? "NA",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ))
                      )
                    ]
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Time Period",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Container(
                        child: Text(widget.loan["approvedInstantLoan"]["startDate"].toString() + ' - ' + widget.loan["approvedInstantLoan"]["startDate"].toString() ?? "NA",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ))
                      )
                    ]
                  )
                ]
              ) : Container()
            ],
          )
        )
      )
    );
  }
}