import 'package:arezue/login_page.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/provider.dart';
import 'package:arezue/auth.dart';

class SettingsPage extends StatefulWidget {

  SettingsPage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextStyle textStyle = TextStyle(
    color: ArezueColors.outPrimaryColor,
    fontSize: 18,
    fontFamily: 'Arezue',
    fontWeight: FontWeight.w400,
  );

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {

    final nameField = Container(
      width: 40,
      height: 40,
      color: Colors.redAccent,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
          right: 50, left: 50, bottom: 10, top: 35),
      child: Text(
        'Name: Rohan Poojary',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );

    final phoneNumberField = Container(
      width: 40,
      height: 40,
      color: Colors.redAccent,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
          right: 50, left: 50, bottom: 10, top: 10),
      child: Text(
        'Phone: (647) 331-9530',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );

    final appLanguageField = Container(
      width: 40,
      height: 40,
      color: Colors.redAccent,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
          right: 50, left: 50, bottom: 10, top: 10),
      child: Text(
        'App Language: English',
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );


    final changePasswordButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text("Change Password",
            style: textStyle),
      ),
    );

    final billingButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text("Billing & Payments",
            style: textStyle),
      ),
    );

    final premiumButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Upgrade to Premium',
            style: textStyle),
      ),
    );

    final agreementButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('User Agreement',
            style: textStyle),
      ),
    );

    final helpCenterButton = Padding(
      padding: EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Help Center',
            style: textStyle),
      ),
    );
    final privacyButton = Padding(
      padding: EdgeInsets.fromLTRB(35.0, 10.0, 0.0, 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Privacy',
            style: textStyle),
      ),
    );
    final versionButton = Padding(
      padding: EdgeInsets.fromLTRB(50.0, 10.0, 0.0,10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Version',
            style: textStyle),
      ),
    );

    final signOutButton = Padding(
      padding: EdgeInsets.fromLTRB(60.0, 10.0, 50.0, 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _signOut, //() async {
//          try {
//            Auth auth = Provider.of(context).auth;
//            await auth.signOut();
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => LoginPage()),
//            );
//          } catch (e) {
//            print(e);
//          }
//        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Sign out',
            style: textStyle),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ArezueColors.secondaryColor,
        title: Text('Settings'),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.help, color: Colors.white),
            onPressed: null,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          nameField,
          phoneNumberField,
          appLanguageField,
          changePasswordButton,
          billingButton,
          premiumButton,
          agreementButton,
          Row(
            children: <Widget>[
              helpCenterButton,
              privacyButton
            ],
          ),
          Row(
            children: <Widget>[
              versionButton,
              signOutButton,
            ],
          )
        ],
      ),
    );
  }
}
