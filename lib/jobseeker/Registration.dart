import 'package:arezue/Employer/Registration.dart';
import 'package:arezue/login_page.dart';
import 'package:arezue/utils/texts.dart';
import 'package:flutter/material.dart';

class EmployeeRegistration extends StatefulWidget {
  static String tag = 'employee-registration-page';
  @override
  _EmployeeRegistrationState createState() => new _EmployeeRegistrationState();
}

class _EmployeeRegistrationState extends State<EmployeeRegistration> {
  TextStyle style = TextStyle(color: Colors.white);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final welcome_text = Text(ArezueTexts.employeeRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));

    final slogan_text = Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 60),
        child: Text(ArezueTexts.employeeSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));

    final name = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: style,
        cursorColor: Colors.white,
//      validator: (String value) {
//        return value.contains('@') ? null : 'Enter a valid email';
//      },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle, color: Colors.white),
          hintText: ArezueTexts.name,
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
        ),
      ),
    );

    final email = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: style,
        cursorColor: Colors.white,
        validator: (String value) {
          if (value.isEmpty) {
            return "Please enter an email";
          } else if (!value.contains('@')) {
            return "Please enter a valid email";
          }
          return null;
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
        //initialValue: 'some password',
        obscureText: true,
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a Password';
          } else if (value.length <= 8) {
            return 'Make sure the Password is atleast 8 characters ';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Colors.white),
//        style: TextStyle(color: Colors.white),
          hintText: ArezueTexts.password,
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
        ),
      ),
    );

    final employerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployerRegistration()),
          );
        },
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        color: Colors.white,
        child:
            Text(ArezueTexts.employer, style: TextStyle(color: Colors.black)),
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
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        color: Colors.white,
        child: Text(ArezueTexts.Create,
            style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
    );

    final signInLabel = FlatButton(
      child: Text(
        ArezueTexts.existingAccount,
        style: TextStyle(color: Colors.white, fontSize: 16),
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
                  name,
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        employerButton,
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
