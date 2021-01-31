import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Services/Groceries.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<HomeScreen> {
  double w, h;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> lst;
  void initState() {
    super.initState();
    initstate();
  }

  initstate() async {
    List<dynamic> tmp = await getCategory();
    setState(() {
      lst = tmp;
    });
  }

  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavigationDrawer(),
        body: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: new Icon(
                              Icons.menu,
                              size: 24,
                              color: black,
                            ),
                            onPressed: () => _scaffoldKey.currentState.openDrawer(),
                          ),
                        ),
                        title: Text(
                          "Gupta Kirana",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: IconButton(
                            icon: new Icon(
                              Icons.notifications,
                              size: 24,
                              color: black,
                            ),
                            onPressed: () => {},
                          ),
                        )
                      ),
                ),
              ],
            ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15, 
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: "Search in Gupta Kirana",
                      hintStyle: TextStyle(
                        color: grey, 
                        fontSize: 16)
                      ),
                    style: TextStyle(
                      fontSize: 16,
                    )
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: ListTile(
                    title: Text(
                      "Categories",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3),
                    ),
                  ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 45,
                child: RaisedButton(
                  // padding: EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(35.0)),
                  onPressed: () async {
                        // Navigator.pushReplacement(
                        // context,
                        // PageTransition(
                        //     type: PageTransitionType.leftToRightWithFade,
                        //     child: EditCategories()));
                  },
                  color: primaryColor,
                  child: RichText(
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Edit Categories",
                          style: TextStyle(
                              letterSpacing: 1,
                              color: white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            lst != null ? Expanded(
              child: GridView.builder(
                itemCount: lst.length,
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 0.5 * w,
                  mainAxisSpacing: 0.01 * h,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor,
                          blurRadius: 15.0,
                          spreadRadius: -15
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => Products(category: lst[index].name, name: lst[index].dname, image: lst[index].image)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(lst[index].image),
                              Center(
                                child: Text(lst[index].dname,
                                  style: TextStyle(fontSize: 12)
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                  );
                }
              ),
            ) : Container(), 
          ],
        ));
  }
}