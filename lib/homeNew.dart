// import 'dart:convert';
//
// import 'package:availablestore/basicAuth.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/foundation.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart';
// import 'package:progress_hud/progress_hud.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class Homepage extends StatefulWidget {
//   Homepage({Key key, this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<Homepage> {
//   ProgressHUD progressHUD;
//   List<dynamic> dropdownlist = new List<dynamic>();
//   List<dynamic> storeNamelList = new List<dynamic>();
//   String _drugId;
//   String message = "Please select the drug name";
//
//   bool visibleList = false;
//   bool visibleDefault = false;
//
//   String selectedValue;
//   Position _location = Position(latitude: 0.0, longitude: 0.0);
//
//   @override
//   void initState() {
//     progressHUD = new ProgressHUD(
//       backgroundColor: Colors.black12,
//       color: Colors.white,
//       containerColor: Color.fromRGBO(75, 172, 198, 1),
//       borderRadius: 5.0,
//       loading: true,
//       text: 'Loading...',
//     );
//     super.initState();
//     _getDrugList();
//   }
//
//   final searchDrugLabel = Text(
//     'Search the Drugs',
//     textAlign: TextAlign.center,
//     style: TextStyle(
//         fontSize: 18,
//         fontFamily: 'Poppins',
//         color: Color(0xff4b2b59),
//         fontWeight: FontWeight.w500),
//   );
//
//   void _getDrugList() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       final formData = jsonEncode({
//         "primaryKeys": ["10002"]
//       });
//       Response response = await ioClient.post(
//           "https://cdashboard.dcservices.in/HISUtilities/services/restful/DataService/DATAJSON/getCentralDrugList",
//           headers: headers1,
//           body: formData);
//       //
//       // if (response.statusCode == 200) {
//       //   Map<String, dynamic> list = json.decode(response.body);
//       //   List<dynamic> userid = list["dataValue"];
//       //   return userid.map((f) => (f)).toList();
//       // } else {
//       //   throw Exception('Failed to load data');
//       // }
//
//       if (response.statusCode == 200) {
//         progressHUD.state.dismiss();
//         Map<String, dynamic> list = json.decode(response.body);
//         print(list);
//         setState(() {
//           dropdownlist = list['dataValue'];
//           print("drop.." + dropdownlist.toString());
//         });
//       } else {
//         progressHUD.state.dismiss();
//         throw Exception('Failed to load data');
//       }
//     } else {
//       return showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Color(0xffffffff),
//               title: Text("Please Check your Internet Connection",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Color(0xff000000))),
//             );
//           });
//     }
//   }
//
//   void _getStore(String drugid) async {
//     progressHUD.state.show();
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       message = "";
//
//       var list;
//       final location = await Geolocator()
//           .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _location = location;
//       });
//       print("==> ${drugid}");
//       final formData = jsonEncode({
//         "primaryKeys": [
//           "${_location.latitude}",
//           "${_location.longitude}",
//           "1000",
//           drugid
//         ]
//       });
//
//       print("formData........" + formData);
//       print("header...." + headers.toString());
//       Response response = await ioClient.post(
//           "https://cdashboard.dcservices.in/HISUtilities/services/restful/GenericProcessesDataWebService/getDataService/StockAvailabeDistanceWise",
//           headers: headers,
//           body: formData);
//
//       if (response.statusCode == 200) {
//         progressHUD.state.dismiss();
//         Map<String, dynamic> list = json.decode(response.body);
//         print(list);
//         visibleDefault = false;
//         visibleList = false;
//
//         setState(() {
//           storeNamelList = list['dataValue'];
//           print("storeNamelList.." + storeNamelList.toString());
//           message = list['msg'];
//           if(message.isEmpty){
//             visibleList = false;
//             visibleDefault = true;
//           }else{
//             if((storeNamelList == null)){
//               visibleList = false;
//               visibleDefault = true;
//             }else{
//               visibleList = true;
//               visibleDefault = false;
//             }
//           }
//           //
//           // if (storeNamelList == null) {
//           //   message = list['msg'];
//           //   print("message........" + message);
//           //   visibleList = false;
//           //   visibleDefault = true;
//           // } else {
//           //   visibleDefault = false;
//           //   visibleList = true;
//           //
//           //   print(storeNamelList.length.toString());
//           //   print(storeNamelList[0][1]);
//           //   // a = selectedStoreStringList[2];
//           // }
//         });
//       } else {
//         progressHUD.state.dismiss();
//         throw Exception('Failed to load data');
//       }
//     } else {
//       return showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               backgroundColor: Color(0xffffffff),
//               title: Text("Please Check your Internet Connection",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Color(0xff000000))),
//             );
//           });
//     }
//   }
//
//   _launchCaller() async {
//     const url = "tel:123456789";
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   _launchURL() async {
//     var url = 'mailto:example@gmail.com';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Widget _buildBar(BuildContext context) {
//     return new AppBar(
//       backgroundColor: Color.fromRGBO(75, 172, 198, 1),
//       iconTheme: new IconThemeData(color: Colors.black),
//       title: _buildTitle(context),
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.logout), // The "-" icon
//           onPressed: () async {
//             showDialog(
//                 barrierDismissible: false,
//                 context: context,
//                 builder: (BuildContext context) {
//                   return WillPopScope(
//                     child: AlertDialog(
//                       backgroundColor: Color(0xffffffff),
//                       title: Text("Are you sure you want to logout ?",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 16, color: Color(0xff000000))),
//                       actions: <Widget>[
//                         new FlatButton(
//                           child: new Text("Cancel"),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         new FlatButton(
//                           child: new Text("Logout"),
//                           onPressed: () async {
//                             SharedPreferences prefs =
//                                 await SharedPreferences.getInstance();
//                             prefs.remove("username");
//                             prefs.remove("password");
//                             Navigator.of(context)
//                                 .popUntil((route) => route.isFirst);
//                             Navigator.pushReplacementNamed(context, "/login");
//                           },
//                         ),
//                       ],
//                     ),
//                     onWillPop: () async {
//                       return false;
//                     },
//                   );
//                 });
//           }, // The `_decrementCounter` function
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTitle(BuildContext context) {
//     /*var horizontalTitleAlignment =
//           Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;*/
//     return new InkWell(
//       // onTap: () => scaffoldKey.currentState.openDrawer(),
//       child: new Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 1.0),
//           child: new Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               new Expanded(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Health Facility Identifier',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         fontStyle: FontStyle.normal,
//                         fontFamily: 'Raleway'),
//                   ),
//                 ],
//               )),
//               new Image.asset(
//                 'assets/images/hfi_appicon.png',
//                 width: 30,
//                 height: 30,
//               ),
//             ],
//           )),
//     );
//   }
//
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color.fromRGBO(75, 172, 198, 1),
//           title: Text(
//             "Health Facility Identifier",
//             style: TextStyle(fontFamily: 'Poppins'),
//           ),
//         ),
//         body: new Stack(children: <Widget>[
//           new Padding(
//               padding: const EdgeInsets.all(10),
//               child: new Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   new Padding(padding: new EdgeInsets.all(10)),
//                   new Container(
//                     // color: const Color(0xFFf2f3f5),
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.symmetric(horizontal: 5),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Center(child: searchDrugLabel),
//                         new Padding(
//                             padding: new EdgeInsets.symmetric(vertical: 5)),
//                         SizedBox(
//                           width: double.infinity,
//                           child: new SearchableDropdown(
//                             hint: new Text("Please choose a drug name"),
//                             underline: SizedBox(),
//                             isExpanded: true,
//                             isCaseSensitiveSearch: false,
//                             value: selectedValue,
//                             onChanged: (value) async {
//                               setState(() {
//                                 selectedValue = value;
//                                 _drugId = value.substring(1, 9);
//                                 _getStore(_drugId);
//                                 visibleList = false;
//                                 visibleDefault = false;
//                               });
//                               // getDropDownItem();
//                             },
//                             items: dropdownlist?.map((item) {
//                                   // print("item==> ${item[1].toString()}");
//                                   return new DropdownMenuItem<String>(
//                                     value: item.toString(),
//                                     child: new Text(item[1],
//                                         style:
//                                             new TextStyle(color: Colors.black)),
//                                   );
//                                 })?.toList() ??
//                                 [],
//                           ),
//                         ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   new Visibility(
//                       visible: visibleList,
//                       child: Flexible(
//                           child: ListView.builder(
// //                            physics: NeverScrollableScrollPhysics(),
//                         itemCount: storeNamelList.length,
//                         itemBuilder: (context, int i) => Column(
//                           children: [
//                             new GestureDetector(
//                               child: Container(
//                                   // color:Colors.white,
//                                   // width: 200,
//                                   // height:200,
//                                   margin: const EdgeInsets.only(
//                                       left: 20, right: 20, top: 20, bottom: 10),
//                                   padding: const EdgeInsets.all(20.0),
//                                   decoration: new BoxDecoration(
//                                       borderRadius: new BorderRadius.all(
//                                           new Radius.circular(10.0)),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Color(0xffd2c8c8),
//                                             blurRadius: 2.0,
//                                             spreadRadius: 1.0,
//                                             offset: Offset(1.0, 3.0))
//                                       ],
//                                       color: Color(0xffeeeeee)),
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 6, bottom: 6),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text("Store Name:  ",
//                                                     style: new TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     )),
//                                                 Expanded(
//                                                     child: Text(
//                                                         storeNamelList[i][8],
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 15,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500))),
//                                               ],
//                                             )),
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 6, bottom: 6),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text("Dist Name:  ",
//                                                     style: new TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     )),
//                                                 Expanded(
//                                                     child: Text(
//                                                         storeNamelList[i][2],
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 15,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500))),
//                                               ],
//                                             )),
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 6, bottom: 6),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text("State Name:  ",
//                                                     style: new TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     )),
//                                                 Expanded(
//                                                     child: Text(
//                                                         storeNamelList[i][0],
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 15,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500))),
//                                               ],
//                                             )),
//                                         Container(
//                                             margin: EdgeInsets.only(
//                                                 top: 6, bottom: 6),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text("Facility Type:  ",
//                                                     style: new TextStyle(
//                                                       color: Colors.black,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     )),
//                                                 Expanded(
//                                                     child: Text(
//                                                         storeNamelList[i][4],
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             fontSize: 15,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500))),
//                                               ],
//                                             )),
//                                         GestureDetector(
//                                             onTap: () {
//                                               print("destlat.." +
//                                                   storeNamelList[i][16]);
//                                               print("destlong.." +
//                                                   storeNamelList[i][17]);
//                                               // navigationToMap(
//                                               //     storeNamelList[16], storeNamelList[17]);
//                                             },
//
//                                             // onTap: () => launch(
//                                             //     "https://www.google.com/maps/dir/?api=AIzaSyASPD9LyAHVA2eky3B8ecDl0qElQDZV6xo&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate"),
//                                             child: Container(
//                                                 margin: EdgeInsets.only(
//                                                     top: 6, bottom: 6),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   children: <Widget>[
//                                                     Icon(Icons.location_on),
//                                                     Expanded(
//                                                         child: Text(
//                                                             storeNamelList[i]
//                                                                 [18],
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'Poppins',
//                                                                 fontSize: 15,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500))),
//                                                   ],
//                                                 ))),
//                                         GestureDetector(
//                                             onTap: _launchCaller,
//                                             child: Container(
//                                                 margin: EdgeInsets.only(
//                                                     top: 6, bottom: 6),
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       Icon(Icons.phone),
//                                                       Expanded(
//                                                           child: Text(
//                                                               storeNamelList[i]
//                                                                   [14],
//                                                               style: TextStyle(
//                                                                   fontFamily:
//                                                                       'Poppins',
//                                                                   fontSize: 15,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500))),
//                                                     ]))),
//                                         InkWell(
//                                             onTap: _launchURL,
//                                             child: Container(
//                                                 margin: EdgeInsets.only(
//                                                     top: 6, bottom: 6),
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: <Widget>[
//                                                       Icon(Icons.mail,
//                                                           size: 18),
//                                                       Expanded(
//                                                           child: Text(
//                                                               storeNamelList[i]
//                                                                   [15],
//                                                               style: TextStyle(
//                                                                   fontFamily:
//                                                                       'Poppins',
//                                                                   fontSize: 15,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   decoration:
//                                                                       TextDecoration
//                                                                           .underline,
//                                                                   color: Color(
//                                                                       0xff4b2b59)))),
//                                                     ]))),
//                                       ])),
//                             ),
//                           ],
//                         ),
//                       ))),
//                   new Visibility(
//                     visible: visibleDefault,
//                     child: Text(
//                       message,
//                       style: new TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   child: _renderWidget(context),
//                   // )
//                 ],
//               )),
//           progressHUD
//         ]));
//   }
//
//   _renderWidget(context) {
//     print("userid  w.." + storeNamelList.toString());
//     print("message  w.." + message);
//     List<dynamic> listofStore = storeNamelList;
//     return (message.isEmpty)
//         ? (listofStore == null)
//             ? CircularProgressIndicator()
//             : Container(
//                 width: double.infinity,
//                 height: MediaQuery.of(context).size.height,
//                 child: ListView(
//                   shrinkWrap: true,
//                   primary: false,
//                   physics: NeverScrollableScrollPhysics(),
//                   children: listofStore.map((post) {
//                     return Container(
//                         // color:Colors.white,
//                         width: 200,
//                         // height:200,
//                         margin: const EdgeInsets.only(
//                             left: 20, right: 20, top: 20, bottom: 10),
//                         padding: const EdgeInsets.all(20.0),
//                         decoration: new BoxDecoration(
//                             borderRadius:
//                                 new BorderRadius.all(new Radius.circular(10.0)),
//                             boxShadow: [
//                               BoxShadow(
//                                   color: Color(0xffd2c8c8),
//                                   blurRadius: 2.0,
//                                   spreadRadius: 1.0,
//                                   offset: Offset(1.0, 3.0))
//                             ],
//                             color: Color(0xffeeeeee)),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                   margin: EdgeInsets.only(top: 6, bottom: 6),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text("Store Name:  ",
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       Expanded(
//                                           child: Text(post[8],
//                                               style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                       FontWeight.w500))),
//                                     ],
//                                   )),
//                               Container(
//                                   margin: EdgeInsets.only(top: 6, bottom: 6),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text("Dist Name:  ",
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       Expanded(
//                                           child: Text(post[2],
//                                               style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                       FontWeight.w500))),
//                                     ],
//                                   )),
//                               Container(
//                                   margin: EdgeInsets.only(top: 6, bottom: 6),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text("State Name:  ",
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       Expanded(
//                                           child: Text(post[0],
//                                               style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                       FontWeight.w500))),
//                                     ],
//                                   )),
//                               Container(
//                                   margin: EdgeInsets.only(top: 6, bottom: 6),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text("Facility Type:  ",
//                                           style: new TextStyle(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       Expanded(
//                                           child: Text(post[4],
//                                               style: TextStyle(
//                                                   fontFamily: 'Poppins',
//                                                   fontSize: 15,
//                                                   fontWeight:
//                                                       FontWeight.w500))),
//                                     ],
//                                   )),
//                               GestureDetector(
//                                   onTap: () {
//                                     print("destlat.." + post[16]);
//                                     print("destlong.." + post[17]);
//                                     // navigationToMap(
//                                     //     post[16], post[17]
//                                     // );
//                                   },
//
//                                   // onTap: () => launch(
//                                   //     "https://www.google.com/maps/dir/?api=AIzaSyASPD9LyAHVA2eky3B8ecDl0qElQDZV6xo&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate"),
//                                   child: Container(
//                                       margin:
//                                           EdgeInsets.only(top: 6, bottom: 6),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: <Widget>[
//                                           Icon(Icons.location_on),
//                                           Expanded(
//                                               child: Text(post[18],
//                                                   style: TextStyle(
//                                                       fontFamily: 'Poppins',
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.w500))),
//                                         ],
//                                       ))),
//                               GestureDetector(
//                                   onTap: _launchCaller,
//                                   child: Container(
//                                       margin:
//                                           EdgeInsets.only(top: 6, bottom: 6),
//                                       child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Icon(Icons.phone),
//                                             Expanded(
//                                                 child: Text(post[14],
//                                                     style: TextStyle(
//                                                         fontFamily: 'Poppins',
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.w500))),
//                                           ]))),
//                               InkWell(
//                                   onTap: _launchURL,
//                                   child: Container(
//                                       margin:
//                                           EdgeInsets.only(top: 6, bottom: 6),
//                                       child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Icon(Icons.mail, size: 18),
//                                             Expanded(
//                                                 child: Text(post[15],
//                                                     style: TextStyle(
//                                                         fontFamily: 'Poppins',
//                                                         fontSize: 15,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         decoration:
//                                                             TextDecoration
//                                                                 .underline,
//                                                         color: Color(
//                                                             0xff4b2b59)))),
//                                           ]))),
//                             ]));
//                   }).toList(),
//                 ))
//         : Text(
//             message,
//             style: new TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           );
//   }
// }
