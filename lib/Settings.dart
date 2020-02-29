import 'package:arezue/login_page.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.auth, this.onSignOut, this.formType});
  final BaseAuth auth;
  final FormType2 formType;
  final VoidCallback onSignOut;
  @override
  _SettingsPageState createState() => new _SettingsPageState(formType: this.formType);
}

enum FormType2 { employer, jobseeker }
enum AuthStatus { notSignedIn, signedIn,
}

class _SettingsPageState extends State<SettingsPage> {
  FormType2 formType;
  _SettingsPageState({this.formType});
  //static final _formKey = new GlobalKey<FormState>();
  AuthStatus authStatus = AuthStatus.notSignedIn;
  static TextStyle textStyle = TextStyle(
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

  void _updateAuthStatus(AuthStatus status) {
    if (this.mounted) {
      setState(() {
        authStatus = status;
      });
    }
  }

  final Widget nameField = Container(
    width: 40,
    height: 40,
    color: Colors.redAccent,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 35),
    child: Text(
      'Name: Rohan Poojary',
      style: textStyle,
      textAlign: TextAlign.center,
    ),
  );

  final Widget phoneNumberField = Container(
    width: 40,
    height: 40,
    color: Colors.redAccent,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 10),
    child: Text(
      'Phone: (647) 331-9530',
      style: textStyle,
      textAlign: TextAlign.center,
    ),
  );

  final Widget appLanguageField = Container(
    width: 40,
    height: 40,
    color: Colors.redAccent,
    alignment: Alignment.center,
    margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 10),
    child: Text(
      'App Language: English',
      style: textStyle,
      textAlign: TextAlign.center,
    ),
  );

  final Widget changePasswordButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text("Change Password", style: textStyle),
    ),
  );

  final Widget billingButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text("Billing & Payments", style: textStyle),
    ),
  );

  final Widget premiumButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Upgrade to Premium', style: textStyle),
    ),
  );

  final Widget downloadResume = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Download Resume', style: textStyle),
    ),
  );

  final Widget connectedAccounts = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Connected Accounts', style: textStyle),
    ),
  );

  final Widget agreementButton = Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('User Agreement', style: textStyle),
    ),
  );

  final Widget helpCenterButton = Padding(
    padding: EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 10.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Help Center', style: textStyle),
    ),
  );

  final Widget privacyButton = Padding(
    padding: EdgeInsets.fromLTRB(35.0, 10.0, 0.0, 10.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Privacy', style: textStyle),
    ),
  );

  final Widget versionButton = Padding(
    padding: EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 10.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: null,
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Version', style: textStyle),
    ),
  );

  Widget signOutButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(60.0, 10.0, 50.0, 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _signOut();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      auth: widget.auth,
                      onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
                      formType: FormType.login,
                    )),
          );
        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text('Sign out', style: textStyle),
      ),
    );
  }

  List<Widget> submitWidgets() {
    switch (formType) {
      case FormType2.employer:
        return [
          nameField,
          appLanguageField,
          changePasswordButton,
          billingButton,
          premiumButton,
          agreementButton,
          Row(
            children: <Widget>[helpCenterButton, privacyButton],
          ),
          Row(
            children: <Widget>[
              versionButton,
              signOutButton(),
            ],
          ),
        ];
        break;
      case FormType2.jobseeker:
        return [
          nameField,
          phoneNumberField,
          appLanguageField,
          changePasswordButton,
          connectedAccounts,
          downloadResume,
          agreementButton,
          Row(
            children: <Widget>[helpCenterButton, privacyButton],
          ),
          Row(
            children: <Widget>[
              versionButton,
              signOutButton(),
            ],
          ),
        ];
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
        children: submitWidgets(),
      ),
    );
  }
}