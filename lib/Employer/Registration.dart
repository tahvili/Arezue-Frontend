import 'package:arezue/login_page.dart';
import 'package:arezue/utils/texts.dart';
import 'package:flutter/material.dart';

class EmployerRegistration extends StatefulWidget {
  static String tag = 'employee-registration-page';
  @override
  _EmployerRegistrationState createState() => new _EmployerRegistrationState();
}

class _EmployerRegistrationState extends State<EmployerRegistration> {
  TextStyle style = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    final welcome_text = Text(ArezueTexts.employerRegistrationHeader,
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

    final company = Padding(
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
          prefixIcon: Icon(Icons.business_center, color: Colors.white),
          hintText: ArezueTexts.company,
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
//      validator: (String value) {
//        return value.contains('@') ? null : 'Enter a valid email';
//      },
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

    final jobSeekerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        color: Colors.white,
        child: Text(ArezueTexts.employee, style: TextStyle(color: Colors.black,
            fontSize: 16)),
      ),
    );

    final createButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {},
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        color: Colors.white,
        child: Text(ArezueTexts.Create, style: TextStyle(color: Colors.black)),
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

    return Stack(
//      theme: ThemeData(primaryColor: Colors.black, accentColor: Colors.white),
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
                company,
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[jobSeekerButton,Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),),
                      createButton],
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
    );
  }
}
