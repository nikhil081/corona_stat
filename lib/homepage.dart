import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'first.dart';
import 'second.dart';
import 'third.dart';

String countryname;

class my extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return myy();
  }
}

class myy extends State<my> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var getdata;
  String url = "https://covid-19-data.p.rapidapi.com/totals";
  var data;
  var conf;
  var rec;
  var dea;
  Country _selected;
  final _items = [new fst(), new sst(), new tst()];
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final _boxHeight = 150.0;
  int _currentPage = 0;

  Future<String> makeRequest() async {
    var response = await http.get((url), headers: {
      "Accept": "application/json",
      "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
      "x-rapidapi-key": "3e5f4f5044msh335e45ce458af55p1c603ejsn051028c3efeb"
    });
    setState(() {
      getdata = json.decode(response.body);
      data = getdata;
      conf = data[0]['confirmed'];
      rec = data[0]['recovered'];
      dea = data[0]['deaths'];
      print(conf);
      print(rec);
      print(dea);
    });
  }

  Future<String> makecountryRequest(String n) async {
    String countryurl;
    if (n == "United States") {
      countryurl = "https://covid-19-data.p.rapidapi.com/country?name=usa";
    } else {
      countryurl = "https://covid-19-data.p.rapidapi.com/country?name=" + n;
    }
    var response = await http.get((countryurl), headers: {
      "Accept": "application/json",
      "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
      "x-rapidapi-key": "3e5f4f5044msh335e45ce458af55p1c603ejsn051028c3efeb"
    });
    setState(() {
      getdata = json.decode(response.body);
      data = getdata;
      conf = data[0]['confirmed'];
      rec = data[0]['recovered'];
      dea = data[0]['deaths'];
      print(conf);
      print(rec);
      print(dea);
    });
  }

  Future getCurrentUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    print("User: ${_user.displayName ?? "None"}");
    return _user;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    this.makeRequest();
    getCurrentUser();
  }

  _signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Stat"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: hei,
            color: Color(0xff192A56),
            child: Column(
              children: <Widget>[
                _buildBody(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        border: Border.all(
                          color: Colors.red[500],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: hei * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                              child: new Text(
                                "Live Updates",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            new Container(
                              width: wid * 0.2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: new GestureDetector(
                                onTap: () {
                                  makeRequest();
                                },
                                child: new Container(
                                  child: Expanded(
                                      child: Text("Click for Global Count")),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                          child: new Text(
                            "About Coronavirus",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        new Row(
                          children: <Widget>[
                            new Container(
                              width: wid * 0.08,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Column(
                                children: <Widget>[
                                  new Text("Confirmed"),
                                  new Text(conf.toString()),
                                ],
                              ),
                            ),
                            Container(
                                height: 28,
                                child: VerticalDivider(color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Column(
                                children: <Widget>[
                                  new Text("Recovered"),
                                  new Text(rec.toString()),
                                ],
                              ),
                            ),
                            Container(
                                height: 28,
                                child: VerticalDivider(color: Colors.black)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Column(
                                children: <Widget>[
                                  new Text("Deaths"),
                                  new Text(dea.toString()),
                                ],
                              ),
                            ),
                            new CountryPicker(
                              dense: false,
                              showFlag: true,
                              //displays flag, true by default
                              showDialingCode: false,
                              //displays dialing code, false by default
                              showName: false,
                              //displays country name, true by default
                              showCurrency: false,
                              //eg. 'British pound'
                              showCurrencyISO: false,
                              //eg. 'GBP'
                              onChanged: (Country country) {
                                setState(() {
                                  _selected = country;
                                  countryname = _selected.name;
                                });
                                print(countryname);
                                makecountryRequest(countryname);
                              },
                              selectedCountry: _selected,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      _signOut();
                      Navigator.of(context)
                          .pushReplacementNamed('/registerpage');
                    },
                    child: new Container(
                      decoration: BoxDecoration(
                        color: Color(0xffEA5569),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      width: wid * 0.4,
                      height: hei * 0.05,
                      child: Center(
                        child: new Text(
                          "LOGOUT",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  _buildBody() {
    return Column(children: <Widget>[
      Stack(
        children: <Widget>[
          _buildPageView(),
          _buildCircleIndicator(),
        ],
      )
    ]);
  }

  _buildPageView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(
              color: Colors.red[500],
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: _boxHeight,
        child: PageView.builder(
            itemCount: _items.length,
            controller: _pageController,
            itemBuilder: (BuildContext context, int index) {
              return Center(child: _items[index]);
            },
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            }),
      ),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          itemCount: _items.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
