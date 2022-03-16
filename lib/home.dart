import 'dart:async';
import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:availablestore/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'basicAuth.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Homepage> {
  String selectedValue;
  String holder;
  String _drugId;
  List<dynamic> userid;
  String message = "Please select the drug name";

  Future<List<dynamic>> _getDrugName() async {
    final formData = jsonEncode({
      "primaryKeys": ["10002"]
    });

    Response response = await ioClient.post(
        "https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/getCentralDrugList",
        headers: headers1,
        body: formData);
    if (response.statusCode == 200) {
      Map<String, dynamic> list = json.decode(response.body);
      List<dynamic> userid = list["dataValue"];
      return userid.map((f) => (f)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Position _location = Position(latitude: 0.0, longitude: 0.0);

  Future<List<dynamic>> _getStoreName(String drugid) async {
    message = "";
    // userid.clear();

    var list;
    // getLocation();
    print("==> ${drugid}");

    // "30.62584","76.99376"
    final formData = jsonEncode({
      "primaryKeys": [
        "${_location.latitude}",
        "${_location.longitude}",
      // "30.62584","76.99376",
        "10000",
        drugid
      ]
    });
    print("formData........" + formData);
    print("header...." + headers.toString());
    Response response = await ioClient.post(
        "https://cdashboard.dcservices.in/HISUtilities/services/restful/GenericProcessesDataWebService/getDataService/StockAvailabeDistanceWise",
        headers: headers,
        body: formData);

    if (response.statusCode == 200) {
      print("response. " + response.statusCode.toString());
      list = json.decode(response.body);
      setState(() {
        userid = list['dataValue'];
        if (userid == null) {
          message = list['msg'];
          print("message........" + message);
        }
        print("userid........" + userid.toString());

        return list["dataValue"];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  _launchURL(String url) async {
    // var url = 'mailto:example@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  _launchCaller(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  @override
  void initState() {
    // _gpsService();
    getLocation();
    _getDrugName();
    super.initState();
  }
  Future<void> getLocation() async {
    try {
      var serviceEnabled = await Geolocator().isLocationServiceEnabled();
      print("1..." + serviceEnabled.toString());
      if (serviceEnabled) {
        var geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
        print("2...." + geolocationStatus.toString());
        if (geolocationStatus == GeolocationStatus.granted ||
            geolocationStatus == GeolocationStatus.unknown) {
          _location = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          print("3....." + _location.toString());
          return;
        }
      }
    } catch (e) {
      print(e);
    }
  }


  _renderWidget(context) {
    // _getStoreName(drugid)
    print("userid  w.." + userid.toString());
    print("message  w.." + message);
    List<dynamic> listofStore = userid;
    return (message.isEmpty) ?
    (listofStore == null)
        ? CircularProgressIndicator()
        : Flexible(child:ListView(
      shrinkWrap: true,
      primary: false,
      // physics: NeverScrollableScrollPhysics(),
      children: listofStore.map((post) {
        return Container(
          // color:Colors.white,
            width: 200,
            // height:200,
            margin: const EdgeInsets.only(
                left: 20, right: 20, top: 20, bottom: 10),
            padding: const EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
                borderRadius:
                new BorderRadius.all(new Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffd2c8c8),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                      offset: Offset(1.0, 3.0))
                ],
                color: Color(0xffeeeeee)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Store Name:  ", style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          Expanded(child: Text(post[8],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                        ],
                      )),

                  Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Dist Name:  ", style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          Expanded(child: Text(post[2],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("State Name:  ", style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          Expanded(child: Text(post[0],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Facility Type:  ", style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                          Expanded(child: Text(post[4],
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))),
                        ],
                      )),
                  GestureDetector(
                      onTap: () {
                        print("destlat.." +post[16]);
                        print("destlong.." +post[17]);
                        navigationToMap(
                            post[16], post[17]
                        );
                      },


                      // onTap: () => launch(
                      //     "https://www.google.com/maps/dir/?api=AIzaSyASPD9LyAHVA2eky3B8ecDl0qElQDZV6xo&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate"),
                      child: Container(
                          margin: EdgeInsets.only(top: 6, bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.location_on),
                              Expanded(child: Text(post[18],
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500))),
                            ],
                          ))),

                  GestureDetector(
                      onTap: () {
                        _launchCaller('tel:+${post[14].toString()}');
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 6, bottom: 6),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.phone),
                                Expanded(child: Text(post[14],
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500))),
                              ]))),
                  InkWell(
                      onTap: () {
                        _launchURL('mailto:+${post[15].toString()}');
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 6, bottom: 6),
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.mail, size: 18),
                                Expanded(child: Text(post[15],
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        decoration:
                                        TextDecoration.underline,
                                        color: Color(0xff4b2b59)))),
                              ]))),
                ]));
      }).toList(),
    )) : Text(message, style: new TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),);
  }

  Widget _buildTitle(BuildContext context) {
    /*var horizontalTitleAlignment =
          Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;*/
    return new InkWell(
      // onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Availablity of Store',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Raleway'),
                      ),
                    ],
                  )),


            ],
          )),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color(0xff4b2b59),
      iconTheme: new IconThemeData(color: Colors.black),
      title: _buildTitle(context),
      actions: <Widget>[IconButton(
        icon: Icon(Icons.logout),
        color: Colors.white,
        // The "-" icon
        onPressed: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  child: AlertDialog(
                    backgroundColor: Color(0xffffffff),
                    title: Text("Are you sure you want to logout ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Color(0xff000000))),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      new FlatButton(
                        child: new Text("Logout"),
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.remove("username");
                          prefs.remove("password");
                          Navigator.of(context).popUntil((route) =>
                          route.isFirst);
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                      ),
                    ],
                  ),
                  onWillPop: () async {
                    return false;
                  },
                );
              });
        }, // The `_decrementCounter` function
      ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: /* AppBar(
        backgroundColor: Color(0xff4b2b59),
        title: Text(
          "Availablity of Store",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),*/ _buildBar(context),


        body:  new Stack(children: <Widget>[
          new Padding(
              padding: const EdgeInsets.all(10),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.all(10)),
                  new Container(
                    // color: const Color(0xFFf2f3f5),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(child: new Text('Search the Drugs',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                color: Color(0xff4b2b59),
                                fontWeight: FontWeight.w500))),
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 5)),
                        new Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: new Container(
                              width: 350,
                              child: FutureBuilder(
                                future: _getDrugName(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<dynamic> drugsName = snapshot.data;
                                    print("drufmm .." + drugsName.toString());
                                    return SearchableDropdown(
                                      hint: Text('Search'),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          color: Colors.black),
                                      items: drugsName.map((item) {
                                        // print("item==> ${item[1].toString()}");
                                        return new DropdownMenuItem<String>(
                                          value: item.toString(),
                                          child: Text(
                                            item[1],
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 13),
                                          ),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      value: selectedValue == null
                                          ? selectedValue
                                          : snapshot.data.firstWhere(
                                              (i) => i == selectedValue,
                                          orElse: () => null),
                                      isCaseSensitiveSearch: false,
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedValue = value;
                                          _drugId = value.substring(1, 9);
                                          _getStoreName(_drugId);
                                        });
                                        getDropDownItem();
                                      },
                                    );
                                  } else {
                                    return Center(child: Text("loading..."));
                                  }
                                },
                              )),
                        ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    child: _renderWidget(context),
                  )
                ],
              )),
        ]));
  }

  navigationToMap(var lat, var lng) {
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => MapScreen(
            destLat : lat,
            destLong :lng)));
  }
}
