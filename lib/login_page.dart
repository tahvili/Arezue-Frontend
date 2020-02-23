import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/validations.dart';
import 'package:flutter/material.dart';
import 'package:arezue/jobseeker/HomePage.dart';
import 'services/auth.dart';
import 'package:arezue/loading.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.auth, this.onSignIn, this.formType})
      : super(key: key);
  final FormType formType;
  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => new _LoginPageState(formType: this.formType);
}

enum FormType { login, employerRegister, jobseekerRegister, forgot }
enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _LoginPageState extends State<LoginPage> {
  Requests request = new Requests(); //instance of http class
  _LoginPageState({this.formType});
  AuthStatus authStatus = AuthStatus.notSignedIn;
  FormType formType;
  static final _formKey = new GlobalKey<FormState>();
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);

  String _email, _name, _password, _company, _errorMessage;
  bool loading;
  String userId;
  //String _authHint = '';

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = " ";
    loading = false;
  }

  void validateAndSubmit() async {
    setState(() {
      loading = true;
      _errorMessage = "";
    });
    if (validateAndSave()) {
      print(formType);
      try {
        if (formType == FormType.login) {
          if (await widget.auth.signInWithEmailAndPassword(_email, _password) !=
              null) {
            //setState(() => loading = true);
            setState(() {
              //_authHint = 'Signed In';
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          auth: widget.auth,
                          onSignOut: () =>
                              _updateAuthStatus(AuthStatus.notSignedIn),
                          formType: FormType3.jobseeker,
                        ),
                    fullscreenDialog: true),
              );
            });
            widget.onSignIn();
          }
//          else
//            {
//            setState(() {
//              loading = false;
//              _errorMessage = 'Could not sign in with those credentials';
//            });
//          }
        } else if (formType == FormType.jobseekerRegister) {
          if (await widget.auth.createUserWithEmailAndPassword(
                  _name, _email, _password, null, "jobseeker") !=
              null) {
            _showVerifyEmailSentDialog();
          }
        } else if (formType == FormType.employerRegister) {
          if (await widget.auth.createUserWithEmailAndPassword(
                  _name, _email, _password, _company, "employer") !=
              null) {
            _showVerifyEmailSentDialog();
          }
        }
//          else
//            {
//            setState(() {
//              loading = false;
//              _errorMessage = 'Please supply a valid email';
//            });
//          }
        setState(() {
          loading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          loading = false;
         // _authHint = 'Sign In Error\n\n${e.toString()}';
          _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        //_authHint = '';
      });
    }
  }

  void forgotSubmit() async {
    if (validateAndSave()) {
      try {
        if (await widget.auth.sendPasswordResetEmail(_email) != null) {
          //setState(() => loading = true);
          _showPasswordResetSentDialog();
        } else {
          setState(() {
            loading = false;
            _errorMessage = 'Please supply a valid email';
          });
        }
      } catch (e) {
        print(e);
        _errorMessage = e.message;
      }
    } else {
      setState(() {
       // _authHint = '';
      });
    }
  }

  void moveToJobseekerRegister() {
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.jobseekerRegister;
      //_authHint = '';
    });
  }

  void moveToEmployerRegister() {
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.employerRegister;
      //_authHint = '';
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.login;
      //_authHint = '';
    });
  }

  void moveToForgotPassword() {
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.forgot;
      //_authHint = '';
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

  Widget employerButton() {
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
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outPrimaryColor,
        child: Text(ArezueTexts.employer,
            style: TextStyle(color: ArezueColors.outSecondaryColor)),
      ),
    );
  }

  Widget createButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: validateAndSubmit,
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
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
        onSaved: (value) => _company = value,
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
            )));
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
        padding: EdgeInsets.fromLTRB(35, 12, 35, 12),
        color: ArezueColors.outPrimaryColor,
        child: Text(ArezueTexts.employee,
            style: TextStyle(color: ArezueColors.outSecondaryColor)),
      ),
    );
  }

  Widget backLabel() {
    return FlatButton(
      child: Text(
        ArezueTexts.back,
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

  Widget loginForgotPasswordText() {
    return Text(ArezueTexts.forgotPasswordHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget loginForgotText() {
    return Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 100),
        child: Text(ArezueTexts.forgotPasswordSlogan,
            textAlign: TextAlign.center,
            style: new TextStyle(
              color: ArezueColors.highGreyColor,
              fontSize: 16,
              fontFamily: 'Arezue',
            )));
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

  Widget forgotButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          forgotSubmit();
        },
        padding: EdgeInsets.all(12),
        color: ArezueColors.outSecondaryColor,
        child: Text(ArezueTexts.submit,
            style:
                TextStyle(color: ArezueColors.outPrimaryColor, fontSize: 16)),
      ),
    );
  }

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          validateAndSubmit();
        },
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
        moveToForgotPassword();
      },
    );
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
          _showErrorMessage(),
          signUpLabel(),
        ];
      case FormType.forgot:
        return [
          loginForgotPasswordText(),
          loginForgotText(),
          email(),
          SizedBox(height: 24.0),
          forgotButton(),
          // _showErrorMessage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: backLabel(),
            ),
          ),
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
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    jobSeekerButton(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                    ),
                    createButton(),
                  ],
                ),
                _showErrorMessage(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    employerButton(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                    ),
                    createButton(),
                  ],
                ),
                _showErrorMessage(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.0),
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
    return loading
        ? Loading()
        : new Form(
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

  void _showVerifyEmailSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Thank You"),
            content:
                new Text("A verification Link has been sent to your email"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    moveToLogin();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")),
            ],
          );
        });
  }

  void _showPasswordResetSentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Thank You"),
            content:
                new Text("A Password Reset link has been sent to your email"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    moveToLogin();
                    Navigator.of(context).pop();
                  },
                  child: Text("Dismiss")),
            ],
          );
        });
  }

  Widget _showErrorMessage() {
    return new Text(
      _errorMessage,
      style: TextStyle(fontSize: 14.0, color: Colors.red),
    );
  }
}
