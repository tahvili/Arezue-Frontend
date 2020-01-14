import 'package:arezue/jobseeker/Registration.dart';
import 'package:arezue/utils/texts.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    final welcome_text = Text(ArezueTexts.signInHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));

    final slogan_text = Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 40),
        child: Text(ArezueTexts.signInSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));

    final email = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: style,
        cursorColor: Colors.white,
        validator: (String value) {
          return value.contains('@') ? null: 'Enter a valid email';
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.alternate_email, color: Colors.white),
          hintText: ArezueTexts.email,
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Colors.red)
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
        cursorColor: Colors.white,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a Password';
          } else if (value.length <= 8){
            return 'Make sure the Password is atleast 8 characters ';
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.white),
          hintText: ArezueTexts.password,
          hintStyle: TextStyle(color: Colors.white),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          filled: true,
          fillColor: Colors.black12,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
//            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
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
        color: Colors.white,
        child: Text(ArezueTexts.Signin,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        ArezueTexts.forgotPassword,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onPressed: () {},
    );

    final signUpLabel = FlatButton(
      child: Text(
        'New to Arezue? Create an Account',
        style: TextStyle(color: Colors.white, fontSize: 16),
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
            backgroundColor: Colors.black,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  welcome_text,
                  slogan_text,
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
