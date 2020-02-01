import 'package:arezue/jobseeker/HomePage.dart';
import 'package:arezue/jobseeker/registration.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:arezue/provider.dart';
import 'package:arezue/auth.dart';
import 'package:arezue/validations.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => new _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _email, _password, _warning;
  final _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);

  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        await auth.sendPasswordResetEmail(_email);
        print('Password reset email sent!');
        _warning = "A password reset link has been sent to $_email";
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(), fullscreenDialog: true),
        );
      } catch (e) {
        print(e);
        //_warning = e.message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context).auth;
    final welcomeText = Text("Reset Password",
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));

    final email = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: style,
        onSaved: (value) => _email = value,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: EmailValidator.validate,
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

    final submitButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: submit, //submit,
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child:
            Text("Submit", style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );

    final backToLoginPage = FlatButton(
      child: Text(
        "Back to Sign In",
        style: TextStyle(color: ArezueColors.highGreyColor, fontSize: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(), fullscreenDialog: true),
        );
      },
    );

    return MaterialApp(
      home: Form(
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
                    email,
                    submitButton,
                    backToLoginPage,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
