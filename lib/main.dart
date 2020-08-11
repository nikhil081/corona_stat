import 'package:coronastat/registerscreen.dart';
import 'package:flutter/material.dart';
import "homepage.dart";
import "splash.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => new my(),
        '/registerpage': (BuildContext context) => new reg(),
      },
      home: spl(),
      debugShowCheckedModeBanner: false,
    );
  }
}
