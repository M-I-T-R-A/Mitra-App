import 'dart:io';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Services/CartState.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/UploadImageFirestore.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Mitra/Models/Grocery.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  var count;
  double w, h;
  int cnt = 0;
  List<Cartprod> prod;
  CartState cs = new CartState();
  SharedPreferences prefs;
  Map<String, dynamic> port;
  Map<String, dynamic> prodLst;
  String supplierName;
  String supplierMobile;
  String supplierBillURL;
  
  void initState() {
    super.initState();
    init();
  }
  
  init() async {
    prefs = await SharedPreferences.getInstance();    
    setState(() {
      cnt = prefs.getInt('cnt');
    });
    List<Cartprod> _lst = await cs.getAll();
    setState(() {
      prod = _lst;
    });
    count = new List(_lst.length);
    for(int i=0;i<_lst.length;i++) {
      count[i] = _lst[i].qty;
    }
  }

  updateTotal() async {
    await prefs.setInt('cnt', cnt);
  }
  File supplierBill;
  final picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  @override
  Widget build(BuildContext context) {
    String path;
    Future<String> getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      return pickedFile.path;
    }
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Cart!',
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
      backgroundColor: Colors.white,
      body: cnt > 0 ?  Column(
        children: <Widget>[
          Expanded(
          child: Column(
          children: [
            Container(
                  width: 0.8 * w,
                  margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Supplier Name",
                          hintStyle:
                              TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          onChanged: (value) {
                                this.supplierName = value;
                          },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.8 * w,
                  margin: EdgeInsets.symmetric(vertical: 0.01 * h),
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
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Supplier Mobile",
                              hintStyle:
                                  TextStyle(color: grey, fontSize: 16)),
                          style: TextStyle(
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                    this.supplierMobile = value;
                              },),
                    ),
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
                    SizedBox(height: 15,),
                    Padding(
                      padding: EdgeInsets.only(top: 15, left: 15, bottom: 5),
                      child: Text(
                        "Add Your Supplier Bill",
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
                            path = await getImage();
                              setState(() {
                                supplierBill = File(path);
                              });
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String id = prefs.getString("firebase_id");
                              supplierBillURL = await uploadFile(supplierBill, "$id/SupplierBills/");
                              showToast("Supplier Bills Image Uploaded", grey, primaryColor);
                          },
                          color: primaryColor,
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Supplier Bill",
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ),
                        Center(
                          child: supplierBillURL == null
                              ? Center(
                                  
                                )
                              : Image.file(supplierBill,
                                  height: 45.0,
                                  width: 45.0)
                                ), 
                      ],
                    ),
                    SizedBox(height: 35,)
                  ],
                ), 
                  ),
                  Text("Items Purchased",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: primaryColor,
                    fontWeight: FontWeight.bold
                  )
                ),
            prod != null ? Expanded(
              child: ListView.builder(
                itemCount: prod.length,
                itemBuilder: (BuildContext context, int index) {
                  return count[index] !=0 ? Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor,
                          blurRadius: 15.0,
                          spreadRadius: -20
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10, 
                          horizontal: 20
                        ),
                        leading: Container(
                          width: 0.6 * w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prod[index].name,
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  ),
                                  Text(prod[index].desc,
                                    style: TextStyle(
                                      fontSize: 10, 
                                      color: grey
                                    )
                                  )
                                ],
                              ),
                            ],
                          )
                        ),
                        trailing: Container(
                          width: 0.2 * w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 0.04 * w,
                                backgroundColor: primaryColor,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      count[index] -= 1;
                                      cnt--;
                                      updateTotal();
                                    });
                                    cs.updateData(prod[index].name, count[index]);
                                  },
                                  icon: Icon(Icons.remove)
                                ),
                              ),
                              Text(count[index].toString()),
                              CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 0.04 * w,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      count[index] += 1;
                                      cnt++;
                                      updateTotal();
                                    });
                                    cs.updateData(prod[index].name, count[index]);
                                  },
                                  icon: Icon(Icons.add)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : Container();
                }
              ),
            ) : Container(
              height: 0.4 * h,
              child: SpinKitDoubleBounce(
                color: primaryColor,
                size: 50.0,
              )
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                leading: IconButton(
                  onPressed: () => _selectDate(context), // Refer step 3
                  icon: Icon(Icons.calendar_today),
                  color: primaryColor,
                ),
                subtitle: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style:
                        TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                trailing: Container(
                  alignment: Alignment.center,
                  width: 0.3 * w,
                  child: RaisedButton(
                    onPressed: () async{
                      List<dynamic> products = await cs.getAll();
                      bool status = await updateProduct(products, supplierName, supplierMobile, supplierBillURL, selectedDate.toLocal().toString().split(' ')[0]);
                      if (status == true){
                        showToast("Items added!", grey, primaryColor);
                        cs.clear();
                        await prefs.setInt("cnt", 0);
                        Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRightWithFade,
                            child: Home(index:0)));
                      }
                      else
                        showToast("Please check!", grey, error);
                     
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: primaryColor,
                    child: Text(
                      "Checkout",
                      style:
                          TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.04 * w, vertical: 0.01 * h),
                  ),
                ),
              ),
            ),
          ],
        ) 
        )
        ],)
      : Container(
        child: SpinKitDoubleBounce(
          color: primaryColor,
          size: 50.0,
        )
      ) 
    );
  }
}