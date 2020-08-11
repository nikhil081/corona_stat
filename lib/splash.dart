import 'dart:async';
import 'package:flutter/material.dart';
import 'homepage.dart';

class spl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return srt();
  }
}

class srt extends State<spl> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed("/registerpage"));
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    return Scaffold(
      body: new Container(
        color: Color(0xff192A56),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Container(
                height: hei * 0.45,
              ),
              new Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/stay.jpg"),
                        fit: BoxFit.fill)),
              ),
              new Container(
                height: hei * 0.025,
              ),
              Text(
                "Covid19 App",
                style: TextStyle(color: Color(0xffFFFFFF), fontSize: 15),
                textDirection: TextDirection.ltr,
              )
            ],
          ),
        ),
      ),
    );
  }
}
