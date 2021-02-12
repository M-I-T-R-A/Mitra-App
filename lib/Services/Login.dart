import 'dart:convert';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Screens/LandingScreen.dart';
import 'package:Mitra/Screens/Verification/KYCScreen.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Mitra/Screens/Verification/BankStatementsScreen.dart';
import 'package:Mitra/Screens/Verification/GurrantorDetails.dart';
import 'package:Mitra/Screens/Verification/StoreDetailsScreen.dart';
import 'package:Mitra/Screens/Verification/StoreOwnerDetails.dart';
import 'package:Mitra/Screens/Verification/WeeksPurchase.dart';

class LoginFunctions{
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone(String mobileNo, BuildContext context) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobileNo,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent, 
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            print("verifying");
           // onVerify(context);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (error) {
      handleError(error, context);
    }
  }

  Future<void> verifyOTP(String status, BuildContext context, String smsOTP, String mobileNo, String mode) async {
      _auth.currentUser().then((user) async {
        if (mode == 'Register') {
          print("New User Register");
          status = signIn(context,smsOTP,mobileNo).toString();
          onVerify(context);
        } else {
          print("Old User Login");
          status = signIn(context,smsOTP,mobileNo).toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('mobile', user.phoneNumber.substring(3));
          await checkMobile(user.phoneNumber.substring(3));
          
          var login = prefs.getInt('login');
          print("login status" + login.toString());
          Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: getHomeScreen(login)));
        }
      });
  }

  void createRecord(String mobileNo) async {
    print(mobileNo);
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: mobileNo, password: "abc123");
          print(newUser.user);
    } catch (e) {
      print(e);
    }
  }

  signIn(BuildContext context, String smsOTP, String mobileNo) async {
    String status = 'OK!';
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      createRecord(mobileNo);
    } catch (error) {
      status = handleError(error,context);
    }
    return status;
  }

  handleError(PlatformException error, BuildContext context) {
    print(error);
    String errorMessage;
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        errorMessage = 'Invalid Code';
        break;
      default:
        errorMessage = error.message;
        break;
    }
    return errorMessage;
  }

  signOut(BuildContext context)  async{
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', 0);
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: LandingScreen()));
  }

  checkMobile(String mobile) async{
    final url = (server+"customer/check?phoneNumber=" + mobile);
    
    Response response = await get(Uri.encodeFull(url), headers: {"Content-Type": "application/json"});
    print(response.body);

    int status = jsonDecode(response.body)["status"];
    if (status != null){
      int id = jsonDecode(response.body)["id"];
      print(status);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('login', status);
      await prefs.setInt('id', id);
      await prefs.setString("firstName", jsonDecode(response.body)["name"].split(" ")[0]);
      await prefs.setString("lastName", jsonDecode(response.body)["name"].split(" ")[0]);
          
      return true;
    }
    return false;
  }

  getHomeScreen(login){
    switch(login){
      case 0: return LandingScreen();
      case 1: return KYCScreen();
      case 2: return StoreOwnerDetails();
      case 3: return GurrantorDetails();
      case 4: return StoreDetails();
      case 5: return BankStatementScreen();
      case 6: return WeeksPurchaseScreen();
      case 7: return Home(index: 0,);
    }
  }

  onVerify(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final FirebaseUser currentUser = await _auth.currentUser();
    
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    var tokenId;
    await _firebaseMessaging.getToken().then((token) {
      print(token);
      tokenId = token;
    });
    
    var firstName = prefs.getString("firstName");
    var lastName = prefs.getString("lastName");
    var phone = currentUser.phoneNumber.substring(3);

    final user = {
      "name": firstName + " " + lastName,
      "phoneNumber": phone,
      "status": 1,
      // 'firebase_id': currentUser.uid,
      // 'device_token': tokenId
    };

    await prefs.setString("firebase_id", currentUser.uid);
    final url = (server+"customer/add");
    print(user);
    
    Response response = await post(Uri.encodeFull(url), body: json.encode(user), headers: {"Content-Type": "application/json"});
    print(response.body);

    int status = jsonDecode(response.body)["status"];
    int id = jsonDecode(response.body)["id"];
    print(id);
    if (status == 1){
      await prefs.setInt('login', 1);
      await prefs.setInt('id', id);
      await prefs.setString('mobile', currentUser.phoneNumber.substring(3));
      
        Navigator.pushReplacement(
        context,
          PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              child: KYCScreen()));
    }
  }
}