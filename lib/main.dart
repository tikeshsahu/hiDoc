import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidoc/screens/mobileScreens/homePage.dart';
import 'package:hidoc/screens/webScreens/webPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: !kIsWeb ? HomePage() : const WebPage(),
      // Please Run WebPage on Chrome.
      // I'm stuck on a Prod issue at my current company, has made this project in hurry
      // It is not 100% complete but please consider.
    );
  }
}
