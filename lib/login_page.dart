import 'package:arezue/jobseeker/registration.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);
  @override
  Widget build(BuildContext context) {
    final welcomeText = Text(ArezueTexts.signInHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));

    final sloganText = Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.signInSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));

    final email = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: (String value) {
          return value.contains('@') ? null : ArezueTexts.emailError;
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
        validator: (value) {
          if (value.isEmpty) {
            return ArezueTexts.passwordError;
          } else if (value.length <= 8) {
            return ArezueTexts.passwordShort;
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: ArezueColors.highGreyColor),
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

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false
          // otherwise.
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
        padding: EdgeInsets.all(12),
        color: ArezueColors.outSecondaryColor,
        child: Text(ArezueTexts.signin,
            style:
                TextStyle(color: ArezueColors.outPrimaryColor, fontSize: 16)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        ArezueTexts.forgotPassword,
        style: TextStyle(color: ArezueColors.highGreyColor, fontSize: 16),
      ),
      onPressed: () {},
    );

    final signUpLabel = FlatButton(
      child: Text(
        ArezueTexts.registerPrompt,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeRegistration()),
        );
      },
    );

    return Form(
      key: _formKey,
      child: Stack(
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
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      forgotLabel,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0),
                      ),
                    ],
                  ),
                  loginButton,
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: signUpLabel,
              )),
        ],
      ),
    );
  }
}
