
import 'package:availablestore/Login/loggedIn.dart';
import 'package:availablestore/Login/login.dart';
import 'package:availablestore/home.dart';
import 'package:availablestore/homeNew.dart';
import 'package:flutter/material.dart';



// Navigation/Routing 

final routes = {
  '/': (BuildContext context) => new IsLoggedIn(),
  '/login': (BuildContext context) => new LoginPage(),
  '/stockDetail': (BuildContext context) => new Homepage(),
};
