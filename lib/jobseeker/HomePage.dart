import 'package:arezue/Settings.dart';
import 'package:arezue/auth.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JobseekerHomePage extends StatefulWidget {
  JobseekerHomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<JobseekerHomePage> {

  final middleSection = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
      ),
      child: Column(
        children: <Widget>[
          Text("0", textAlign: TextAlign.center),
          Text("pending interview requests", textAlign: TextAlign.center),
        ],
      ));
  final leftSection = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
      ),
      child: Column(
        children: <Widget>[
          Text("0", textAlign: TextAlign.center),
          Text("employers scanned your account", textAlign: TextAlign.center),
        ],
      ));
  final rightSection = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    decoration: BoxDecoration(
      border: Border.all(width: 2.0, color: const Color(0xFFFFFFFF)),
    ),
    child: Column(
      children: <Widget>[
        Text(
          "0",
          textAlign: TextAlign.center,
        ),
        Text("employers viewed your resume ", textAlign: TextAlign.center),
      ],
    ),
  );

  final activityBox = Container(
    margin: const EdgeInsets.only(right: 50, left: 50, bottom: 20, top: 0),
    height: 200,
    decoration: BoxDecoration(
      color: Colors.redAccent,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 20.0,
          spreadRadius: 5.0,
          offset: Offset(
            10.0, // horizontal, move right 10
            10.0, // vertical, move down 10
          ),
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("We can't find your resume"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("What are your dream companies?"),
            addNowButton,
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("What wage are you looking for?"),
            addNowButton,
          ],
        ),
      ],
    ),
  );

  static final addNowButton = RaisedButton(
    child: Text('Add now!'),
    onPressed: () {},
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: AppBar(
          leading: Container(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.create,
                    color: Colors.white,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage(
                        auth: widget.auth, onSignOut: widget.onSignOut,
                      )
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          backgroundColor: ArezueColors.appBarColor,
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  right: 50, left: 50, bottom: 20, top: 30),
              alignment: Alignment.center,
              child: Text(
                "Hey, Rohan Poojary!",
                style: TextStyle(
                  color: ArezueColors.outPrimaryColor,
                  fontSize: 25,
                  fontFamily: 'Arezue',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  right: 50, left: 50, bottom: 20, top: 0),
              width: 50,
              height: 50,
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Your account is incomplete!"),
                  RaisedButton(
                    child: Text('Fix it!'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  right: 50, left: 50, bottom: 20, top: 0),
              height: 125,
              color: Colors.redAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: leftSection),
                  Expanded(child: middleSection),
                  Expanded(child: rightSection),
                ],
              ),
            ),
            activityBox,
          ],
        ),
      ),
    );
  }
}
