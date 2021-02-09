import 'package:Mitra/Screens/Home.dart';
import 'package:Mitra/Screens/Verification/BankStatementsScreen.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKhata extends StatefulWidget {
  @override
  _AddKhataState createState() => _AddKhataState();
}

class _AddKhataState extends State<AddKhata> {
  int customerMobile;
  String customerName;
  int qty = 5;
  String name = "Bhindi";
  String desc = "500g";
  List<dynamic> products = new List();
  double screenWidth,screenHeight;
  int count = 0;
  int cnt = 0;
  String query;

  SharedPreferences prefs;
  
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
                      TextField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search, color: primaryColor),
                          border: InputBorder.none,
                          hintText: "Search in Gupta Kirana",
                          hintStyle: TextStyle(
                            color: grey, 
                            fontSize: 18
                          )
                        ),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: (text) {
                          setState(() {
                            this.query = text;
                          });
                        },
                      ),
                      query != null ? Text(query) : Container(),
                      RaisedButton(
                        onPressed: () async{
                          // add product detail to list 
                            this.products.add({
                              "name" : "Bhindi",
                              "description" : "500g",
                              "qty" : 5,
                            });
                            setState((){
                              name = "Bhindi";
                              desc = "500g";
                              qty = 5;
                            });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: primaryColor,
                        elevation: 5,
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0.1 * screenWidth, vertical: 0.01 * screenHeight),
                      )
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
  
  updateTotal() async {
    await prefs.setInt('cnt', cnt);
  }

  _buildRow(int index, String productName, String productDescription, int quantity) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: 10, 
        horizontal: 20
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
                Text(productName,
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
                Text(productDescription,
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
        width: 0.2 * screenWidth,
        child: count == 0 ? RaisedButton(
          onPressed: () => {
            setState(() {
              count += 1;
              cnt++;
              updateTotal();
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
                    count -= 1;
                    cnt--;
                    updateTotal();
                  });
                },
                icon: Icon(Icons.remove)
              ),
            ),
            Text(count.toString()),
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 0.04 * screenWidth,
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    count += 1;
                    cnt++;
                    updateTotal();
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
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,  
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: _addItem,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
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
                  itemBuilder: (context, index) => this._buildRow(index,this.name,this.desc,this.qty)
              ),
              Text("Total Bill = ₹ ",
                style: TextStyle(
                  fontSize: 18.0,
                  color: black,
                  fontWeight: FontWeight.bold
                )
              ),    
              RaisedButton(
                onPressed: () async{
                  //post method
                  bool status = true;
                  if (status == true){
                    Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        child: Home(index: 1)));
                  }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: primaryColor,
              elevation: 5,
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              padding:
                  EdgeInsets.symmetric(horizontal: 0.1 * screenWidth, vertical: 0.01 * screenHeight),
            )
              
          ],
        ),
      ),
    );
  }
}