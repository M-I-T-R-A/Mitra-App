import 'package:Mitra/Services/Login.dart';
import 'package:flutter/material.dart';
import 'package:Mitra/constants.dart';
import 'package:quiver/async.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({@required this.mobileNo, this.mode});
  final String mobileNo;
  final String mode;
  @override
  _OTPScreenState createState() => _OTPScreenState(mobileNo, mode);
}

class _OTPScreenState extends State<OTPScreen> {
  String smsOTP;
  String mobileno;
  String errorMessage = '';
  int _start = 30;
  int _current = 30;
  LoginFunctions loginFunctions = new LoginFunctions();
  String mode;

  _OTPScreenState(String mobileno, String mode){
    this.mobileno = "+91" + mobileno;
    this.mode = mode;
  }
    
  @override
  void initState() {
    super.initState();
    initialise();
    startTimer();
  }
  
  void initialise() async {
    await loginFunctions.verifyPhone(mobileno,context);
  }

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      sub.cancel();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    return Scaffold(
        backgroundColor: white,
        appBar: null,
        body: SingleChildScrollView(
          // physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
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
                              image: AssetImage("assets/images/otp.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                        ),
                        child: null
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      child: Text(
                        "OTP sent to " + this.mobileno,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 15, bottom: 5),
                          child: Text(
                            "One Time Password",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(80),
                                borderSide:
                                    const BorderSide(color: Colors.transparent, width: 0.0),
                              ),
                              // disabledBorder: new InputBorder(borderSide: BorderSide.none),
                              hintStyle: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                              filled: true,
                              fillColor: darkGrey,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 17, vertical: 12),

                              hintText: "Enter the OTP send to your number",
                            ),
                            onChanged: (value) {
                                  this.smsOTP = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    (errorMessage != '' ? Text(errorMessage, style: TextStyle(color: Colors.red)) : Container()),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45,
                        child: RaisedButton(
                          // padding: EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0)),
                          onPressed: () {
                            loginFunctions.verifyOTP(errorMessage, context, smsOTP, mobileno, mode);
                          },
                          color: primaryColor,
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Get In",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "By Sign up, you agree our ",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                        FlatButton(
                          padding: EdgeInsets.only(left: 5),
                          onPressed: () {},
                          child: Text(
                            "Terms and Condition",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(),
                       _current !=0  ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You will get an OTP by SMS in "),
                          Text("$_current", style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                              )
                        ]
                      ) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Didn't get OTP? "),
                          FlatButton(
                            padding: EdgeInsets.only(right: 20),
                            onPressed: () {
                              initState();
                            },
                            child: Text(
                              "Resend in $_start",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
