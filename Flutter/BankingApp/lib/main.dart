import 'package:bankingapp/View/Auth/login.dart';
import 'package:bankingapp/View/HomePage/Dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:LoginScreen() , // Set the LoginScreen as the home widget
    );
  }
}