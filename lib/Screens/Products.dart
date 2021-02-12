import 'package:Mitra/Models/Grocery.dart';
import 'package:Mitra/Screens/Cart.dart';
import 'package:Mitra/Screens/SearchPicker.dart';
import 'package:Mitra/Services/Groceries.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Mitra/Services/CartState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  final category, name, image;
  Products({this.category, this.name, this.image});
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  CartState cs = new CartState();
  var count;
  int cnt = 0;
  SharedPreferences prefs;
  List<Product> prod, _filteredProducts = List();
  double w, h;
  void initState() {
    super.initState();
    print("init");
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();    
    setState(() {
      cnt = prefs.getInt('cnt') ?? 0;
    });
    List<Product> _lst = await getProductsByCategory(widget.category);
    print(_lst);
    setState(() {
      prod = _lst;
      _filteredProducts = _lst;
    });
    count = new List(_lst.length);
    for(int i=0;i<_lst.length;i++) {
      count[i] = 0;
    }
  }

  updateTotal() async {
    await prefs.setInt('cnt', cnt);
  }

  setStart(var value) async {
      if(value != null) {
        List<Product> _lst = new List();
        _lst.add(value);
        setState(() {
          _filteredProducts = _lst;
        });
      }
    }
    
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            widget.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 0.025*h,
                color: black,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,  
        ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 0.02 * h, horizontal: 0.04 * w),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  blurRadius: 15.0,
                  spreadRadius: -8
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 0.01 * h),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPicker(header: "Search in " + widget.name))).then((value) => setStart(value))
                },
                child: Container(
                  width: 0.8 *  MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Center(
                    child: Text("Search in " + widget.name,
                      style: TextStyle(
                        fontSize: 0.02 *  MediaQuery.of(context).size.height,
                        color: grey
                      )
                    ),
                  )
                ),
              ),
            ),
          ),
          _filteredProducts.length != 0 ? Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: _filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
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
                                Text(_filteredProducts[index].name,
                                  style: TextStyle(
                                    fontSize: 16,
                                  )
                                ),
                                Text(_filteredProducts[index].unit,
                                  style: TextStyle(
                                    fontSize: 10, 
                                    color: grey
                                  )
                                ),
                                Text("Stock: " + _filteredProducts[index].quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 12, 
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
                        child: count[index] == 0 ? RaisedButton(
                          onPressed: () => {
                            setState(() {
                              count[index] += 1;
                              cnt++;
                              updateTotal();
                            }),
                            cs.addData(prod[index], count[index])
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
                            horizontal: 0.01 * w, 
                            vertical: 0.01 * h
                          ),
                        ) : Row(
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
                );
              }
            ),
          ) : Container(
            height: 0.4 * h,
            child: SpinKitDoubleBounce(
              color: primaryColor,
              size: 50.0,
            )
          ),
          cnt > 0 && prod != null? Container(
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: Text('$cnt items',
                style: TextStyle(
                  fontSize: 17, 
                  color: Colors.grey
                )
              ),
              trailing: Container(
                alignment: Alignment.center,
                width: 0.3 * w,
                child: RaisedButton(
                  onPressed: () => {
                    cs.getAll(),
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Cart()))
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: primaryColor,
                  child: Text("View Cart",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 14
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.04 * w, 
                    vertical: 0.01 * h
                  ),
                ),
              ),
            ),
          ) : Container()
        ],
      )
    );
  }
}