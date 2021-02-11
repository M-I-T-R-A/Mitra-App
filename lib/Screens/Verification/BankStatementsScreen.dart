import 'dart:async';
import 'dart:io';
import 'package:Mitra/Screens/Verification/WeeksPurchase.dart';
import 'package:Mitra/Services/BankStatement.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class BankStatementScreen extends StatefulWidget {
  @override
  _BankStatementScreenState createState() => _BankStatementScreenState();
}

class _BankStatementScreenState extends State<BankStatementScreen> {
  @override
  void initState() {
    super.initState();
  }
  File bankStatement;
  File incomeTax;

  String bankStatementURL;
  String incomeTaxURL;
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void register() async {
    Timer(Duration(seconds: 3), () async{
        bool confirm = confirmation(context, bankStatement, incomeTax);
        if (confirm == true){
          int status = await uploadFiles(bankStatementURL, incomeTaxURL);
          if (status == 6){
             _btnController.success();
            Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: WeeksPurchaseScreen()));
          }
          else{
            _btnController.error();
              showToast( "Huh, some glitch, please wait...", grey, primaryColor);        
            _btnController.reset();  
          }
        }
        else{
            _btnController.error();
              showToast( "Some documents are yet to upload...", grey, primaryColor);        
            _btnController.reset();  
        }
      });
    }

  @override
  Widget build(BuildContext context) {
    Future<String> getPdf() async {
      FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

      File file;
      if(result != null) {
        file = File(result.files.single.path);
      } else {
        print("No file selected");
      }
      return file.path;
    }

    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    //print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    String path;
    return Scaffold(
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: ListTile(
                        title: Text(
                          "Verification",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                      ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: ListTile(
                        title: Text(
                          "5. Upload Bank Statements and Income Tax Statement",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                      ),
                ),
              ],
            ),
            Container(
                height: leftHeight,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/statements.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                        ),
                        child: null
                      ),
                    ),
                    
                    SizedBox(height: 30,),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      shadowColor: primaryColor,
                      elevation: 2.0,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                          child: Text(
                            "Upload Bank Statement",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                path = await getPdf();
                                showToast("Uploading your documents, just a moment please...", grey, primaryColor);
                                  
                                setState(() {
                                    bankStatement = File(path);
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String id = prefs.getString("firebase_id");
                                  bankStatementURL = await uploadFile(bankStatement, "$id/BankStatement/");
                                  showToast("Bank Statement Uploaded", grey, primaryColor);
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "BankStatement",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Flexible(
                              child: bankStatementURL == null
                                  ? Center()
                                  : Container(
                                        padding: new EdgeInsets.only(right: 13.0),
                                        child: new Text(
                                          bankStatement.toString().split('/').last,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: 'Roboto',
                                            color: new Color(0xFF212121),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                          ],
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                    
                    ),
                    Card(
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      shadowColor: primaryColor,
                      elevation: 2.0,
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                          child: Text(
                            "Upload incomeTax Statements",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                              onPressed: () async{
                                path = await getPdf();
                                showToast("Uploading your documents, just a moment please...", grey, primaryColor);
                                  
                                  setState(() {
                                    incomeTax  = File(path);
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String id = prefs.getString("firebase_id");
                                  incomeTaxURL = await uploadFile(incomeTax, "$id/incomeTaxStatements/");
                                  showToast("Income Tax Statements Uploaded", grey, primaryColor);
                              },
                              color: primaryColor,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "incomeTax Statements",
                                      style: TextStyle(
                                          letterSpacing: 1,
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ),
                            Flexible(
                              child: incomeTaxURL == null
                                  ? Center()
                                  : Container(
                                        padding: new EdgeInsets.only(right: 13.0),
                                        child: new Text(
                                          incomeTax.toString().split('/').last,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: 'Roboto',
                                            color: new Color(0xFF212121),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ) 
                          ],
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                    
                    ),
                    
                    SizedBox(height: 30,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: RoundedLoadingButton(
                            color: primaryColor,
                            borderRadius: 35,
                            child: Text(
                              'Confirm!', 
                              style: TextStyle(
                                letterSpacing: 1,
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                                )
                              ),
                            controller: _btnController,
                            onPressed: register,
                            width: 200,
                          ),
                      )
                    ),
                  ],
                ),
              ),
          ]
         )
        )
    );
  }
}