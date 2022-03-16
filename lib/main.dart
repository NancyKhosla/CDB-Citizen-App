
import 'package:availablestore/routes.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nearest Available Stores',
      routes: routes,
      // home: Homepage(title: 'Availablity of Store'),
    );
  }
}


