import 'dart:convert';
import 'package:Mitra/Models/Business.dart';
import 'package:Mitra/Screens/Business/EMICalculator.dart';
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
      case 1: return EMICalculatorScreen();
      case 2: return EMICalculatorScreen();
      case 3: return EMICalculatorScreen();
      case 4: return EMICalculatorScreen();
      case 5: return EMICalculatorScreen();    
  }  
}
Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }