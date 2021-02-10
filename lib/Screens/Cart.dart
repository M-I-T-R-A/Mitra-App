import 'dart:convert';

import 'package:Mitra/Services/CartState.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Mitra/Models/Grocery.dart';
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
  bool loading = false;

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

  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(fontSize: 24),
        ),
      ),
      backgroundColor: Colors.white,
      body: cnt > 0 ? !loading ? Column(
        children: [
          header(context),
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
              trailing: Container(
                alignment: Alignment.center,
                width: 0.3 * w,
                child: RaisedButton(
                  onPressed: () async{
                    await updateProduct(prod);
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
      ) : Container(
        child: SpinKitDoubleBounce(
          color: primaryColor,
          size: 50.0,
        )
      ) : Column(
        children: [
          header(context),
          Center(
            child: Text(
              "Voila! Nothing here",
              style: TextStyle(
                fontSize: 36
              ),
            ),
          )
        ],
      )
    );
  }
  Widget header(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 0.25 * h,
          margin:
              EdgeInsets.symmetric(horizontal: 0.1 * w, vertical: 0.05 * h),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: primaryColor, blurRadius: 15.0, spreadRadius: -6),
            ],
          ),
          child: Container(
            color: Colors.white,
            child: Image.asset(
              "assets/images/cart.png",
            ),
          ),
        ),
      ],
    );
  }
}