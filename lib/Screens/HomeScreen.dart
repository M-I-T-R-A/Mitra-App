import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Screens/Products.dart';
import 'package:Mitra/Services/Groceries.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<HomeScreen> {
  double w, h;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> allCategoryList;
  void initState() {
    super.initState();
    initstate();
  }

  initstate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('login', 7);
    List<dynamic> tmp = await getCategory();
    setState(() {
      allCategoryList = tmp;
    });
  }
  
  List<dynamic> existingList;
  
  _showEditCategoryDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Category"),
            content: MultiSelectChip(
              allCategoryList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  existingList = (selectedList);
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Add"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavigationDrawer(),
        floatingActionButton: new FloatingActionButton(
          heroTag: null,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2.0,
          onPressed: () => _showEditCategoryDialog(),
          tooltip: 'Filter Categories',
          child: new Icon(Icons.filter_alt),
        ),
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
            SizedBox(height: 15,),
            existingList != null ? Expanded(
              child: GridView.builder(
                itemCount: existingList.length,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Products(category: existingList[index].name, name: existingList[index].dname, image: existingList[index].image)));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Image.asset(existingList[index].image),
                              Center(
                                child: Text(existingList[index].dname,
                                  style: TextStyle(fontSize: 10)
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
            ) : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/filter.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter),
                  ),
                  child: null
            ),
          ],
        ));
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> categoryList;
  final Function(List<dynamic>) onSelectionChanged;

  MultiSelectChip(this.categoryList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // dynamic selectedChoice = "";
  List<dynamic> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();
    
    widget.categoryList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.dname),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}