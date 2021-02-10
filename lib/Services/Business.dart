import 'dart:convert';
import 'package:Mitra/Models/Business.dart';
import 'package:Mitra/Screens/Business/EMICalculator.dart';
import 'package:Mitra/Screens/Business/WebView.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<BusinessOptions>> getBusinessOptions() async{
  List<BusinessOptions> businessOptions = [];
  try {
    List<dynamic> dmap = await parseJsonFromAssets('assets/json/businessOptions.json');
    for (int i = 0; i < dmap.length; i++) {
      BusinessOptions _cat = new BusinessOptions(name: dmap[i]["name"], displayName: dmap[i]["displayName"], icon: dmap[i]["icon"]);
      businessOptions.add(_cat);
    }
  } catch (e) {
    print(e);
  }
  return businessOptions;
} 
getBusinessOptionsScreens(int index){
  switch(index){
      case 0: return EMICalculatorScreen();
      case 1: return WebViewScreen(name: "Explore Loans", url: "https://www.tvscredit.com/loans/business-loans");
      case 2: return EMICalculatorScreen();
      case 3: return WebViewScreen(name: "Enquiry", url: "https://www.tvscredit.com/get-in-touch#customer-service");
      case 4: return WebViewScreen(name: "CIBIL Score", url: "https://www.bajajfinserv.in/check-free-cibil-score#;");
      case 5: return WebViewScreen(name: "Contact Us", url: "https://www.tvscredit.com/get-in-touch#contact-us");    
  }  
}
Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }