/// Login/Registration Form Page
///
/// the purpose of this page is to build the login, and register forms.
/// giving users the ability to create and login to their accounts and connect to firebase.

import 'package:arezue/services/http.dart';
import 'package:arezue/utils/colors.dart';
import 'package:arezue/utils/texts.dart';
import 'package:arezue/validations.dart';
import 'package:flutter/material.dart';
import 'package:arezue/jobseeker/homePage.dart';
import 'services/auth.dart';
import 'package:arezue/loading.dart';
import 'package:arezue/employer/employer.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/employer/employer_homePage.dart';

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
  Requests request = new Requests();
  _LoginPageState({this.formType});
  AuthStatus authStatus = AuthStatus.notSignedIn;
  FormType formType;
  static final _formKey = new GlobalKey<FormState>();
  TextStyle style = TextStyle(color: ArezueColors.outSecondaryColor);

  String _email, _name, _password, _errorMessage, _company;
  bool loading;
  String userId;

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
    // Validate and login or register user
    setState(() {
      loading = true;
      _errorMessage = "";
    });
    if (validateAndSave()) {
      try {
        if (formType == FormType.login) {
          Object value =
              await widget.auth.signInWithEmailAndPassword(_email, _password);

          if (value != null) {
            // if user exists
            setState(() {
              Navigator.pop(context);
              if (value is Employer) {
                // if user is employer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployerHomePage(
                            auth: widget.auth,
                            onSignOut: () =>
                                _updateAuthStatus(AuthStatus.notSignedIn),
                            formType: FormType4.employer,
                          ),
                      fullscreenDialog: true),
                );
              }
              if (value is Jobseeker) {
                // if user is jobseeker
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
              }
            });
            widget.onSignIn();
          }
        } else if (formType == FormType.jobseekerRegister) {
          // If registering jobseeker
          if (await widget.auth.createUserWithEmailAndPassword(
                  _name, _email, _password, null, "jobseeker") !=
              null) {
            _showVerifyEmailSentDialog();
          }
        } else if (formType == FormType.employerRegister) {
          // if registering employer
          if (await widget.auth.createUserWithEmailAndPassword(
                  _name, _email, _password, _company, "employer") !=
              null) {
            _showVerifyEmailSentDialog();
          }
        }
        if (!await widget.auth.checkEmailVerification()) {
          // if validating email didn't go right
          _errorMessage = "Something didn't go as plan!";
        }
        setState(() {
          loading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          loading = false;
          _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        loading = false;
        _errorMessage = "Something didn't go as plan!";
        //_authHint = '';
      });
    }
  }

  void forgotSubmit() async {
    // Forgot Password Submit Button
    if (validateAndSave()) {
      try {
        if (await widget.auth.sendPasswordResetEmail(_email) != null) {
          _showPasswordResetSentDialog();
        } else {
          setState(() {
            loading = false;
            _errorMessage = 'Please supply a valid email';
          });
        }
      } catch (e) {
        setState(() {
          loading = false;
          _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        loading = false;
        _errorMessage = "Something didn't go as plan!";
      });
    }
  }

  void moveToJobseekerRegister() {
    // Move to jobseeker registration page
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.jobseekerRegister;
    });
  }

  void moveToEmployerRegister() {
    // Move to employer registration page
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.employerRegister;
    });
  }

  void moveToLogin() {
    // Move to login page
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.login;
    });
  }

  void moveToForgotPassword() {
    // Move to forget page
    _formKey.currentState.reset();
    setState(() {
      _errorMessage = "";
      formType = FormType.forgot;
    });
  }

  Widget welcomeText() {
    // Jobseeker Welcome Text
    return Text(ArezueTexts.employeeRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget sloganText() {
    // Jobseeker Slogan Text
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
    // Employer Register Button
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
    // Create Account
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
    // Name Input
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  Widget company() {
    // Company Input
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: style,
        cursorColor: ArezueColors.outSecondaryColor,
        onSaved: (value) => _company = value,
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  Widget email() {
    // Email Input
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  Widget password() {
    // Password Input
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  Widget signInLabel() {
    // Signin Button
    return FlatButton(
      child: Text(
        ArezueTexts.existingAccount,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
        moveToLogin();
      },
    );
  }

  Widget employerWelcomeText() {
    // Employer Page Welcome Text
    return Text(ArezueTexts.employerRegistrationHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget employerSloganText() {
    // Employer Page Slogan
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
    // Jobseeker Registration Button
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
    // Go Back Button
    return FlatButton(
      child: Text(
        ArezueTexts.back,
        style: TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16),
      ),
      onPressed: () {
        moveToLogin();
      },
    );
  }

  Widget loginForgotPasswordText() {
    // Forgot Password Page Welcome Text
    return Text(ArezueTexts.forgotPasswordHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget loginForgotText() {
    // Forgot Password Page Slogan
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
    // Login Page Welcome Text
    return Text(ArezueTexts.signInHeader,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: ArezueColors.outSecondaryColor,
          fontSize: 30,
          fontFamily: 'Arezue',
        ));
  }

  Widget loginSloganText() {
    // Login Page Slogan
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
    // Forgot Password Button
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
    // Login Button
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
    // Forgot Password Button
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
    // Signup Button
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
      case FormType.login: // If user trying to login
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
      case FormType.forgot: // If pressed forgot password
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
      case FormType.employerRegister: // If want to register as an employer
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
      case FormType.jobseekerRegister: // If want to register as a jobseeker
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
    // Page Builder
    return loading
        ? Loading()
        : new Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () {
                //allows us to hide the soft keyboard when the user
                // taps anywhere on the screen
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
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
            ),
          );
  }

  void _showVerifyEmailSentDialog() {
    // Verification Email Success Prompt
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Check your Email!"),
            content: new Text(
                "We have sent you the verification link to be able to active your account."),
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
    // Password Reset Success Prompt
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Check your Email!"),
            content: new Text("A Password Reset link has been sent to you."),
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
    // Error Message Trigger
    return new Text(
      _errorMessage,
      style: TextStyle(fontSize: 14.0, color: Colors.red),
      textAlign: TextAlign.center,
    );
  }
}
