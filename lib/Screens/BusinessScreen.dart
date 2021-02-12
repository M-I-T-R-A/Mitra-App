import 'package:Mitra/Screens/Drawer.dart';
import 'package:Mitra/Screens/Notifications.dart';
import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:Mitra/Services/Business.dart';

class _SalesData {
  _SalesData(this.day, this.sales);
  final String day;
  final double sales;
}

class BusinessScreen extends StatefulWidget {
  @override
  _BusinessState createState() => _BusinessState();
}

class _BusinessState extends State<BusinessScreen> {
  double w, h;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> lst;
  Map<String, dynamic> currentLoan;
  void initState() {
    super.initState();
    initstate();
  }

  initstate() async {
    List<dynamic> tmp = await getBusinessOptions();
    Map<String, dynamic> loan = await getCurrentLoan();
    setState(() {
      lst = tmp;
      currentLoan = loan;
    });
  }
  List<_SalesData> data = [
    _SalesData('Sun', 30000),
    _SalesData('Mon', 28000),
    _SalesData('Tue', 34000),
    _SalesData('Wed', 32000),
    _SalesData('Thurs', 40000),
    _SalesData('Fri', 32000),
    _SalesData('Sat', 45000)
  ];
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavigationDrawer(),
        body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
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
                          "Business",
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
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRightWithFade,
                                    child: NotificationScreen()));
                            },
                          ),
                        )
                      ),
                ),
              ],
            ),
            Container(
              width: w*0.9,
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12,),
                      Text(
                          "Daily Expenses",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              color: black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1),
                        ),
                      Container(
                        height: h*0.32,
                        child: SfCartesianChart(
                        title: ChartTitle(text: 'This Weeks Sales Analysis'),
                        plotAreaBorderWidth: 0,
                        enableAxisAnimation: true,
                        primaryXAxis: CategoryAxis(
                            labelPlacement: LabelPlacement.onTicks,
                            labelRotation: -45,
                            majorGridLines: MajorGridLines(width: 0)),
                        primaryYAxis: NumericAxis(
                          labelFormat: '{value}',
                          axisLine: AxisLine(width: 0),
                        ),
                        margin: EdgeInsets.all(15),
                        trackballBehavior: TrackballBehavior(enable: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_SalesData, String>>[
                          SplineAreaSeries<_SalesData, String>(
                              gradient: const LinearGradient(colors: <Color>[
                                Color.fromRGBO(51, 133, 255, 1),
                                Color.fromRGBO(160, 213, 255, 1)
                              ], stops: <double>[
                                0.2,
                                0.6
                              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                              borderWidth: 2,
                              borderColor: primaryColor,
                              dataSource: data,
                              xValueMapper: (_SalesData sales, _) => sales.day,
                              yValueMapper: (_SalesData sales, _) => sales.sales,
                              name: 'Sales',
                              markerSettings: MarkerSettings(isVisible: true),
                              dataLabelSettings: DataLabelSettings(isVisible: true))
                        ]),
                      ),
                  ],
                  )
                ),
              ),
            ),
            currentLoan != null ? Container(
            height: 0.20 * h,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 5, 
                      horizontal: 20
                    ),
                    leading: Icon(Icons.money),
                    title: Text('Current Loan',
                      style: TextStyle(
                        fontSize: 18
                      )
                    ),
                    subtitle: Column(
                      children: <Widget> [
                        Text('Demanded Amount: ₹' + currentLoan["demandedAmount"].toString(),
                          style: TextStyle(
                            fontSize: 12, 
                            color: grey
                          )
                        ),
                        Text('Approval Status: ' + currentLoan["approval"].toString(),
                          style: TextStyle(
                            fontSize: 12, 
                            color: grey
                          )
                        )
                      ]
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        color: primaryColor,
                        child: Text(
                          "Statement",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 0.03 * w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.04 * w, vertical: 0.01 * h),
                      ),
                      SizedBox(
                        width: 0.2 * w,
                      ),
                      RaisedButton(
                        onPressed: () => {
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        color: primaryColor,
                        child: Text(
                          "Loan Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 0.03 * w
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.06 * w, vertical: 0.01 * h),
                      ),
                    ],
                  )

                ],
              )
            ),
          ) : Container(),
            lst != null ? Container(
              child: GridView.builder(
                itemCount: lst.length,
                padding: EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 0.32 * w,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => getBusinessOptionsScreens(index)));
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
                              Icon(
                                 IconData(lst[index].icon, fontFamily: 'MaterialIcons'),
                                color: primaryColor,
                                size: 50,),
                              Center(
                                child: Text(lst[index].displayName,
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
            ) : Container(
              child: SpinKitDoubleBounce(
                color: primaryColor,
                size: 50.0,
              )
            ),
          ],
        )
      )
    );
  }
}