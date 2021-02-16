import 'package:Mitra/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Mitra/Services/LocationAutoComplete.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as Coding;

class LocationPicker extends StatefulWidget {
  final String header;
  LocationPicker({this.header});
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  double w,h;
  String origin;
  Map<String, double> originCoordinates = {
    'latitude': 0.0,
    'longitude': 0.0
  };

  dynamic places;

  String pattern = "";
  final TextEditingController _typeAheadController1 = TextEditingController();

  Location location = new Location();
  List<Coding.Placemark> placemarks;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  var currentLocation = [];

  @override
  void initState() {
    super.initState();
  }

  currentLoc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    placemarks = await Coding.placemarkFromCoordinates(_locationData.latitude, _locationData.longitude);
    await addData();
  }

  addData() async {
    currentLocation.insert(0, placemarks[0].name + ', ' +placemarks[0].subLocality);
    currentLocation.insert(1, placemarks[0].locality);
    currentLocation.insert(2, _locationData.latitude);
    currentLocation.insert(3, _locationData.longitude);
    currentLocation.insert(4, placemarks[0].subAdministrativeArea);
    currentLocation.insert(5, placemarks[0].administrativeArea);
    currentLocation.insert(6, placemarks[0].postalCode);
    print(currentLocation);
    currentLocation.length == 7 ? Navigator.pop(context, currentLocation) : addData();
  }

  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.header,
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
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/location.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
              child: null
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.1 * w, right: 0.1 * w, top: 0.05 * h),
            decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: primaryColor,
                  blurRadius: 15.0,
                  spreadRadius: -5
                ),
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: TextField(
                    autofocus: true,
                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your location here",
                      hintStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 18
                      ) 
                    ),
                    controller: this._typeAheadController1,
                    onChanged: (value) {
                      setState(() {
                        pattern = value;
                      });
                    },
                )
              ),
            ),
          ),
          currentLocation.length !=3 ? GestureDetector(
            onTap: () => {
              currentLoc()
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_searching),
                  Text(" Your current location")
                ],
              ),
            ),
          ) : SpinKitDoubleBounce(
            color: primaryColor,
            size: 50.0,
          ),
          FutureBuilder(
            future: pattern == "" ? null : AutoComplete.getSuggestions(pattern),
            builder: (context, snapshot) => pattern == "" ? Container(): 
              snapshot.hasData ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        currentLocation.insert(0, snapshot.data[index]['poi']['name'].toString() + ', ' + snapshot.data[index]['address']['streetName'].toString());
                        currentLocation.insert(1, snapshot.data[index]['address']['municipalitySubdivision'].toString() + ', ' + snapshot.data[index]['address']['municipality'].toString());
                        currentLocation.insert(2, snapshot.data[index]['position']['lat']);
                        currentLocation.insert(3, snapshot.data[index]['position']['lon']);
                        currentLocation.insert(4, snapshot.data[index]['address']['municipality']);
                        currentLocation.insert(5, snapshot.data[index]['address']['countrySubdivision']);
                        currentLocation.insert(6, snapshot.data[index]['address']['postalCode']);
                      });
                      print(currentLocation);
                      Navigator.pop(context, currentLocation);
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text(snapshot.data[index]['poi']['name'].toString() + ', ' + snapshot.data[index]['address']['freeformAddress'].toString(),
                        style: TextStyle(
                          fontSize: 16
                        )
                      )
                    ),
                  ),
                  itemCount: snapshot.data.length,
                )
              ) : SpinKitThreeBounce(
                  color: primaryColor,
                  size: 50.0,
                ),
          )
        ],
      ),
    );
  }
}