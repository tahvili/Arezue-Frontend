import 'package:arezue/ResetPassword.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/validations.dart';
import 'package:flutter/material.dart';
import 'auth.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth, this.onSignIn, this.formType}) : super(key: key);
  final FormType formType;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState(formType: this.formType);
}

enum FormType { login, employerRegister, jobseekerRegister }

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.formType});
  FormType formType;
  static final _formKey = new GlobalKey<FormState>();
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);

  String _email;
  String _name;
  String _password;
//  FormType _formType = FormType.login;
//  change(form);'

//  void change(String form){
//    if(form == "login"){
//      _formType = FormType.login;
//
//    }else if(form == "jobseeker"){
//      _formType = FormType.jobseekerRegister;
//    }
//  }

  String _authHint = '';

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = formType == FormType.login
            ? await widget.auth.signInWithEmailAndPassword(_email, _password)
            : await widget.auth.createUserWithEmailAndPassword(_name, _email, _password);
        setState(() {
          _authHint = 'Signed In\n\nUser id: $userId';
        });
        widget.onSignIn();
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToJobseekerRegister() {
    _formKey.currentState.reset();
    setState(() {
      print("HEy");
      formType = FormType.jobseekerRegister;
      _authHint = '';
    });
  }

  void moveToEmployerRegister() {
    _formKey.currentState.reset();
    setState(() {
      formType = FormType.employerRegister;
      _authHint = '';
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
      _authHint = '';
    });
  }

  Widget welcomeText() {
    return Text(ArezueTexts.employeeRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget sloganText() {
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.employeeSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));
  }

  Widget employerButton () {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: ArezueColors.outSecondaryColor),
        ),
        onPressed: () {
          moveToEmployerRegister();
        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outPrimaryColor,
        child: Text(ArezueTexts.employer,
            style: TextStyle(color: ArezueColors.outSecondaryColor)),
      ),
    );
  }

  Widget createButton () {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed:
 //         submit();
//          _showVerifyEmailDialog();
          validateAndSubmit,
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outSecondaryColor,
        child: Text(ArezueTexts.create,
            style: TextStyle(color: ArezueColors.outPrimaryColor)),
      ),
    );
  }

  Widget name() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: style,
        onSaved: (value) => _name = value,
        cursorColor: ArezueColors.outSecondaryColor,
        validator: NameValidator.validate,
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
  }

  Widget company() {
    return Padding(
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
  }

  Widget email() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
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
  }

  Widget password() {
    return Padding(
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
        validator: PasswordValidator.validate,
        obscureText: true,
        onSaved: (value) => _password = value,
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
  }

  Widget signInLabel() {
    return FlatButton(
      child: Text(
        ArezueTexts.existingAccount,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) => Intermediate()),
//        );
        moveToLogin();
      },
    );
  }

  Widget employerWelcomeText() {
    return Text(ArezueTexts.employerRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget employerSloganText() {
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.employeeSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            ))
    );
  }

  Widget jobSeekerButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: ArezueColors.outSecondaryColor),
        ),
        onPressed: () {
          moveToJobseekerRegister();
        },
        padding: EdgeInsets.fromLTRB(31, 10, 31, 10),
        color: ArezueColors.outPrimaryColor,
        child: Text(ArezueTexts.employee,
            style: TextStyle(color: ArezueColors.outSecondaryColor)),
      ),
    );
  }

  Widget loginWelcomeText() {
    return Text(ArezueTexts.signInHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget loginSloganText() {
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.signInSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));
  }


  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: ArezueColors.outSecondaryColor,
        child: Text(ArezueTexts.signin,
            style:
            TextStyle(color: ArezueColors.outPrimaryColor, fontSize: 16)),
      ),
    );
  }

  Widget forgotLabel() {
    return FlatButton(
        child: Text(
          ArezueTexts.forgotPassword,
          style: TextStyle(color: ArezueColors.highGreyColor, fontSize: 16),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordPage(),
                fullscreenDialog: true),
          );
        });
  }

  Widget signUpLabel() {
    return FlatButton(
      child: Text(
        ArezueTexts.registerPrompt,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
        moveToJobseekerRegister();
      },
    );
  }

  List<Widget> submitWidgets() {
    switch (formType) {
      case FormType.login:
        return [
          loginWelcomeText(),
          loginSloganText(),
          email(),
          SizedBox(height: 8.0),
          password(),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              forgotLabel(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
              ),
            ],
          ),
          loginButton(),
          signUpLabel(),
        ];
      case FormType.employerRegister:
        return [
          employerWelcomeText(),
          employerSloganText(),
          name(),
          company(),
          email(),
          SizedBox(height: 8.0),
          password(),
          SizedBox(height: 24.0),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                jobSeekerButton(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                createButton(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: signInLabel(),
                    )),
              ],
            ),
          ),
        ];
      case FormType.jobseekerRegister:
        return [
          welcomeText(),
          sloganText(),
          name(),
          email(),
          SizedBox(height: 8.0),
          password(),
          SizedBox(height: 24.0),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                employerButton(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                createButton(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: signInLabel(),
                    )),
              ],
            ),
          ),
        ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
                children: submitWidgets(),
              ),
            ),
          ),

        ],
      ),
    );
  }

}