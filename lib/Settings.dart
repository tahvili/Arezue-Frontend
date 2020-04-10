import 'package:arezue/employer/employer.dart';
import 'package:arezue/loading.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.auth, this.onSignOut, this.formType});
  final BaseAuth auth;
  final FormType2 formType;
  final VoidCallback onSignOut;
  @override
  _SettingsPageState createState() =>
      new _SettingsPageState(formType: this.formType);
}

enum FormType2 { employer, jobseeker }
enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _SettingsPageState extends State<SettingsPage> {
  FormType2 formType;
  bool loading = false;
  _SettingsPageState({this.formType});
  Future<Jobseeker> futureUser;
  Future<Employer> futureEmployer;
  AuthStatus authStatus = AuthStatus.notSignedIn;
  static TextStyle textStyle = TextStyle(
    color: ArezueColors.outPrimaryColor,
    fontSize: 18,
    fontFamily: 'Arezue',
    fontWeight: FontWeight.w400,
  );
  Requests request = new Requests();

  @override
  void initState() {
    //calling the appropriate http get request
    super.initState();
    loading = false;
  }

//  Future<Object> fetchData() async {
//    return await request.profileGetRequest(widget.auth.currentUser());
//  }
  Future<Object> fetchData() async {
    if (this.formType == FormType2.jobseeker) {
      return await request.jobseekerGetRequest(widget.auth.currentUser());
    } else {
      return await request.employerGetRequest(widget.auth.currentUser());
    }
  }

  void _signOut() async {
    try {
      setState(() {
        loading = true;
      });
      await widget.auth.signOut();
      widget.onSignOut();
      setState(() {
        loading = false;
      });
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

  Widget nameField(String text) {
    return Container(
      width: 40,
      height: 40,
      //color: Colors.redAccent,
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 35),
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget phoneNumberField(String number) {
    var phone;
    if (number == null) {
      phone = '--';
    } else {
      phone = number;
    }
    return Container(
      width: 40,
      height: 40,
      //color: Colors.redAccent,
      decoration: BoxDecoration(
        color: ArezueColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: ArezueColors.shadowColor,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          ),
        ],
      ),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 50, left: 50, bottom: 10, top: 10),

      child: Text(
        phone,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  final Widget appLanguageField = Container(
    width: 40,
    height: 40,
    //color: Colors.redAccent,
    decoration: BoxDecoration(
      color: ArezueColors.primaryColor,
      boxShadow: [
        BoxShadow(
          color: ArezueColors.shadowColor,
          blurRadius: 10.0,
          spreadRadius: 5.0,
          offset: Offset(
            0.0, // horizontal, move right 10
            0.0, // vertical, move down 10
          ),
        ),
      ],
    ),
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
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
      onPressed: () {},
      padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
      color: ArezueColors.outSecondaryColor,
      child: Text('Privacy', style: textStyle),
    ),
  );

  final Widget versionButton = Padding(
    padding: EdgeInsets.fromLTRB(50.0, 10.0, 0, 10.0),
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {},
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

  List<Widget> submitWidgetsEmployer(String name) {
    return [
      nameField(name),
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
  }

  List<Widget> submitWidgetsJobseeker(String name, String phoneNumber) {
    return [
      nameField(name),
      phoneNumberField(phoneNumber),
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: fetchData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
        // AsyncSnapshot<Your object type>
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return Loading();
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else {
              if (this.formType == FormType2.jobseeker) {
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
                    children: submitWidgetsJobseeker(
                        (((snapshot.data) as Jobseeker).name),
                        (((snapshot.data) as Jobseeker).phoneNumber)),
                  ),
                );
              } else
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
                    children: submitWidgetsEmployer(
                        (((snapshot.data) as Employer).name)),
                  ),
                );
            }
        }
      },
    );
  }
}
