import 'package:arezue/utils/colors.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:arezue/employer/employer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arezue/services/auth.dart';
import 'package:arezue/validations.dart';
import 'package:arezue/services/http.dart';

class UpdateUserData extends StatefulWidget {

  UpdateUserData(this.auth, this.formType);

  final BaseAuth auth;
  final FormType5 formType;
  //final Option option;

  @override
  _UpdateUserData createState() => new _UpdateUserData();


}

enum FormType5 { employer, jobseeker }
enum Option {password, phoneNumber}

class _UpdateUserData extends State<UpdateUserData>{

  FormType5 formType;
  Option option;
  _UpdateUserData({this.formType, this.option});
  Future<Jobseeker> futureUser;
  Future<Employer> futureEmployer;

  bool success = false;
  var user;
  String op, _new_password, _copy_password, _old_password;
  Requests request = new Requests();

  void initState() {   //calling the appropriate http get request
    super.initState();
//    if(this.formType == FormType5.jobseeker) {
//      futureUser = request.getRequest(widget.auth.currentUser(), 'jobseeker');
//    }else{
//      futureEmployer = request.getRequest(widget.auth.currentUser(), 'employer');
//    }

  }

  void updatePassword(String password) async{
    final finUser = await check_current_password(_old_password);

    if (finUser != false) {

      print("Hello, we are in the right place!");
      if (password != null &&
          compare_new_password(password, _copy_password)) {
        print("Chnage Password: complete");

        if(user != null){
          await widget.auth.updatePassword(password);
          success = true;
        }
      } else {
        success = false;
        _showDialog("Password is wrong", "The current password is wrong");
      }
      success = false;
    }
  }

  Future<bool> check_current_password(String password)async {
    var currEmail =  await widget.auth.getEmail();
    if (widget.auth.signInWithEmailAndPassword(
        currEmail,
        password) != null) {

      return true;
    }
    else {
      _showDialog("Current Password", "Incorrect password");
      return false;
    }
  }

  bool compare_new_password(String p1, String p2){

    if (p1 != null && p2 != null) {
      return p1 == p2;
    }
    else{
      _showDialog("Re-enter Password", "please re-enter the new"
          "password");
      return false;
    }
  }

  Widget currentPasswordText() {
    return Padding(
        padding: const EdgeInsets.only(
            left: 20, right: 20, top: 0, bottom: 12),
        child : Container(
          width: 40,
          height: 150,
          color: Colors.transparent,
          alignment: Alignment.center,
        )
    );
  }

  _showDialog(title, text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  updatePassword(_new_password);
                },
              )
            ],
          );
        }
    );
  }


  Widget currentPasswordInput(){
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
        child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            onChanged: (value){
              if(value.length > 0){
                _old_password = value;
              }
            },
            validator: PasswordValidator.validate,
            decoration: new InputDecoration(
                hintText: 'Enter current password',
                prefixIcon: Icon(Icons.lock, color: ArezueColors.shadowColor),
                hintStyle: TextStyle(color: ArezueColors.secondaryColor),
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),

                )
            )
        )
    );
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 110.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          updatePassword(_new_password);
        },
        padding: EdgeInsets.all(12),
        color: ArezueColors.outPrimaryColor,
        child: Text("Save",
            style:
            TextStyle(color: ArezueColors.outSecondaryColor, fontSize: 16)),
      ),
    );

  }


  Widget changePasswordInput(){
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
        child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            onChanged: (value){
              if(value.length > 0){
                _new_password = value;
              }
            },
            validator: PasswordValidator.validate,
            decoration: new InputDecoration(
                hintText: 'Enter a new password',
                prefixIcon: Icon(Icons.lock, color: ArezueColors.shadowColor),
                hintStyle: TextStyle(color: ArezueColors.secondaryColor),
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),

                )
            )
        )
    );

  }

  Widget enterNewPasswordInput(){
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 12),
        child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            onChanged: (value){
              if(value.length > 0){
                _copy_password = value;
              }
            },
            validator: PasswordValidator.validate,
            decoration: new InputDecoration(
                hintText: ' Re-enter new password',
                prefixIcon: Icon(Icons.lock_open, color: ArezueColors.shadowColor),
                hintStyle: TextStyle(color: ArezueColors.secondaryColor),
                contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: ArezueColors.secondaryColor, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),

                )
            )
        )
    );
  }

  List<Widget> submitWidgets(){
    return [
      currentPasswordText(),
      currentPasswordInput(),
      changePasswordInput(),
      enterNewPasswordInput(),
      saveButton()
    ];

  }


  Widget build(context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ArezueColors.secondaryColor,
          title: Text("Change Password")
      ),
      body: ListView(
        children: submitWidgets(),
      ),

    );
  }
}