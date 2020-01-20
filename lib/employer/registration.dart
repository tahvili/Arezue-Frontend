import 'package:arezue/login_page.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class EmployerRegistration extends StatefulWidget {
  static String tag = 'employee-registration-page';
  @override
  _EmployerRegistrationState createState() => new _EmployerRegistrationState();
}

class _EmployerRegistrationState extends State<EmployerRegistration> {
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final welcomeText = Text(ArezueTexts.employerRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));

    final sloganText = Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.employeeSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));

    final name = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: (String value) {
          if (value.isEmpty) {
            return ArezueTexts.nameError;
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.account_circle, color: ArezueColors.highGreyColor),
          hintText: ArezueTexts.name,
          filled: true,
          fillColor: ArezueColors.lowGreyColor,
          hintStyle: TextStyle(color: ArezueColors.highGreyColor),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.highGreyColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );

    final company = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: (String value) {
          if (value.isEmpty) {
            return ArezueTexts.companyError;
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.business_center, color: ArezueColors.highGreyColor),
          hintText: ArezueTexts.company,
          filled: true,
          fillColor: ArezueColors.lowGreyColor,
          hintStyle: TextStyle(color: ArezueColors.highGreyColor),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.highGreyColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );

    final email = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: (String value) {
          if (value.isEmpty) {
            return ArezueTexts.emailError;
          } else if (!value.contains('@')) {
            return ArezueTexts.emailValidError;
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.alternate_email, color: ArezueColors.highGreyColor),
          hintText: ArezueTexts.email,
          filled: true,
          fillColor: ArezueColors.lowGreyColor,
          hintStyle: TextStyle(color: ArezueColors.highGreyColor),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.highGreyColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );

    final password = Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 0,
        bottom: 0,
      ),
      child: TextFormField(
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        //initialValue: 'some password',
        obscureText: true,
        validator: (value) {
          if (value.isEmpty) {
            return ArezueTexts.passwordError;
          } else if (value.length <= 8) {
            return ArezueTexts.passwordShort;
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: ArezueColors.highGreyColor),
//        style: TextStyle(color: Colors.white),
          hintText: ArezueTexts.password,
          filled: true,
          fillColor: ArezueColors.lowGreyColor,
          hintStyle: TextStyle(color: ArezueColors.highGreyColor),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: ArezueColors.highGreyColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );

    final jobSeekerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: ArezueColors.outSecondaryColor),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outPrimaryColor,
        child: Text(ArezueTexts.employee,
            style: TextStyle(color: ArezueColors.outSecondaryColor)),
      ),
    );

    final createButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text(ArezueTexts.create,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        ArezueTexts.existingAccount,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );

    return Form(
      key: _formKey,
      child: Stack(
//      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.white),
        children: <Widget>[
          Scaffold(
            backgroundColor: ArezueColors.outPrimaryColor,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  welcomeText,
                  sloganText,
                  name,
                  company,
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        jobSeekerButton,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        createButton
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: signInLabel,
              )),
        ],
      ),
    );
  }
}
