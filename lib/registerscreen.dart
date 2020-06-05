import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homepage.dart';

bool _obscureText = true;
final FirebaseAuth _auth = FirebaseAuth.instance;
bool _success= false;
class reg extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return regg();
  }
}

class regg extends State<reg> {
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _email, _password;
  var _formkey = GlobalKey<FormState>();
  bool isLoggedIn;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  void initState() {
    isLoggedIn = false;
    _auth.currentUser().then((user) =>
    user != null
        ? setState(() {
      isLoggedIn = true;
    })
        : null);
    super.initState();
    // new Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var hei = MediaQuery
        .of(context)
        .size
        .height;
    var wid = MediaQuery
        .of(context)
        .size
        .width;
    // TODO: implement build
    return isLoggedIn ? new my() : WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Color(0xff192A56),
              height: hei,
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: hei * 0.2,
                  ),
                  new Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/corona.png"),
                            fit: BoxFit.fill)),
                  ),
                  new Container(
                    height: hei * 0.1,
                  ),
                  new Form(
                    autovalidate: true,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: new TextFormField(
                              controller: _emailIdController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                  new TextStyle(color: Colors.grey[800]),
                                  hintText: "enter email",
                                  fillColor: Colors.white70),
                              validator: (String arg) {
                                bool emailValid = false;
                                emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(arg);
                                if (emailValid == true) {
                                  return null;
                                } else {
                                  return "Invalid email";
                                }
                              },
//                        onSaved: (String val) {
//                          no = val;
//                        },
                            ),
                          ),
                          new Container(
                            height: hei * 0.02,
                          ),
                          Container(
                            child: new TextFormField(
                              obscureText: _obscureText,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.vpn_key),
                                  suffixIcon: IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: _toggle),
                                  border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle:
                                  new TextStyle(color: Colors.grey[800]),
                                  hintText: "enter password",
                                  fillColor: Colors.white70),
                              validator: (String arg) {
                                if (arg.length < 8 && arg.length > 1)
                                  return 'Password must be more than 8 charater';
                                else
                                  return null;
                              },
//                        onSaved: (String val) {
//                          _password = val;
//                        },
                            ),
                          ),
                          new Container(
                            height: hei * 0.05,
                          ),
                          InkWell(
                              onTap: () {
                                _register();
                              },
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffEA5569),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                ),
                                width: wid * 0.4,
                                height: hei * 0.05,
                                child: Center(
                                  child: new Text(
                                    "REGISTER",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                          new Container(
                            height: hei * 0.05,
                          ),
                          InkWell(
                              onTap: () {
                                _signInWithEmailAndPassword();
                                if(_success){
                                  Navigator.of(context).pushReplacementNamed("/homepage");
                                }else{
                                  Fluttertoast.showToast(
                                      msg: "Register First",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              },
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffEA5569),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                ),
                                width: wid * 0.4,
                                height: hei * 0.05,
                                child: Center(
                                  child: new Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }


  Future<void> _register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: _emailIdController.text.trim(),
          password: _passwordController.text.trim());
      Navigator.of(context).pushReplacementNamed("/homepage");
    }
    catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmailAndPassword() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailIdController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
      });
    } else {
      _success = false;
    }
  }
}




