import 'dart:async';

import 'package:Mitra/Models/Store.dart';
import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Screens/SearchPicker.dart';
import 'package:Mitra/Services/Fluttertoast.dart';
import 'package:Mitra/Services/GenerateKhataPdf.dart';
import 'package:Mitra/Services/StoreDetails.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart' as open_file;

class AddKhata extends StatefulWidget {
  @override
  _AddKhataState createState() => _AddKhataState();
}

class _AddKhataState extends State<AddKhata> {
  int customerMobile;
  String customerName;
  List<dynamic> products = new List();
  double screenWidth,screenHeight;
  List<int> count = new List();
  String storeName = "";
  double bill = 0;
  double customerAmount = 0;

  SharedPreferences prefs;
    void initState() {
    super.initState();
    print("init");
    init();
  }
final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void register() async {
    Timer(Duration(seconds: 3), () async{
          Map<String, dynamic> data = {
            "customerName": customerName,
            "customerMobile": customerMobile,
            "customerAmount": customerAmount,
            "totalBill": bill,
            "products": products,
            "quantity": count
          };
          String path = await generateKhata(data);
          if (path != null){
             _btnController.success();
            //Launch the file (used open_file package)
            await open_file.OpenFile.open(path);
            Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: Home(index : 1)));
          }
          else{
            _btnController.error();
              showToast( "Huh, some glitch, please wait...", grey, primaryColor);        
            _btnController.reset();  
          }
      });
    }

  init() async {
    Store store = await getStoreDetails();
    storeName = store.shopName;
    count = new List();
    for(int i=0;i<10000;i++) {
      count.add(0);
    }
  }

  setStart(var value) async {
      if(value != null) {
        setState(() {
          products.add(value);
        });
      }
    }

  _addItem() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: screenWidth*0.75,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Add Product",
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 0.01 * screenHeight),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPicker(header: "Search in " + storeName))).then((value) => setStart(value))
                          },
                          child: Container(
                            width: 0.8 *  MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            child: Center(
                              child: Text("Search in " + storeName,
                                style: TextStyle(
                                  fontSize: 0.02 *  MediaQuery.of(context).size.height,
                                  color: grey
                                )
                              ),
                            )
                          ),
                        ),
                      ),
                    ]
                  )
                ),
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      );
  }
  
  _buildRow(int index, List<dynamic> products) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: 15, 
        horizontal: 25
      ),
      leading: Container(
        width: 0.6 * screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(products[index].name,
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
                Text(products[index].unit,
                  style: TextStyle(
                    fontSize: 12, 
                    color: grey
                  )
                ),
                Row(
                  children: <Widget>[
                    Text("Stock: "+products[index].quantity.toString(),
                      style: TextStyle(
                        fontSize: 12, 
                        color: grey
                      )
                    ),
                    SizedBox(width: 25,),
                    Text("₹ "+products[index].pricePerUnit.toString(),
                      style: TextStyle(
                        fontSize: 12, 
                        color: error
                      )
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ),
      trailing: Container(
        width: 0.2 * screenWidth,
        child: count[index] == 0 ? RaisedButton(
          onPressed: () => {
            setState(() {
              count[index] += 1;
              bill+=products[index].pricePerUnit;
            }),
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          color: primaryColor,
          child: Text("Add",
            style: TextStyle(
            color: Colors.white,
            fontSize: 14),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 0.01 * screenWidth, 
            vertical: 0.01 * screenHeight
          ),
        ) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 0.04 * screenWidth,
              backgroundColor: primaryColor,
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    count[index] -= 1;
                    bill-=products[index].pricePerUnit;
                  });
                },
                icon: Icon(Icons.remove)
              ),
            ),
            Text(count[index].toString()),
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 0.04 * screenWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    count[index] += 1;
                    bill+=products[index].pricePerUnit;
                  });
                },
                icon: Icon(Icons.add)),
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    double abovePadding = MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom +
        30;
    print(abovePadding);
    double leftHeight = screenHeight - abovePadding;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Khata!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: new Icon(Icons.cancel),
            color: error,
            onPressed: () =>Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: Home(index : 1)))
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,  
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          child: Icon(Icons.add),
        ),
        body: storeName != null ? SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/khata.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter),
                  ),
                  child: null
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
                        decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Customer Name",
                        hintStyle:
                            TextStyle(color: grey, fontSize: 16)),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                              this.customerName = value;
                        },
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Customer Mobile",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                        style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.customerMobile = int.parse(value);
                            },),
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
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Customer Given Amount",
                            hintStyle:
                                TextStyle(color: grey, fontSize: 16)),
                        style: TextStyle(
                              fontSize: 16,
                            ),
                            onChanged: (value) {
                                  this.customerAmount = double.parse(value);
                            },),
                  ),
                ),
              ),
              Text("Items Purchased",
                style: TextStyle(
                  fontSize: 18.0,
                  color: primaryColor,
                  fontWeight: FontWeight.bold
                )
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: this.products.length,
                  itemBuilder: (context, index) => this._buildRow(index,this.products)
              ),
              Text("Total Bill = ₹ " + bill.toString(),
                style: TextStyle(
                  fontSize: 18.0,
                  color: black,
                  fontWeight: FontWeight.bold
                )
              ),    
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45,
                  child: RoundedLoadingButton(
                      color: primaryColor,
                      borderRadius: 35,
                      child: Text(
                        'Confirm !', 
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
                ),
              ),
          ],
        ),
      ) : Container(
            child: SpinKitDoubleBounce(
              color: primaryColor,
              size: 50.0,
            )
          ),
    );
  }
}