
import 'package:flutter/cupertino.dart';

class User extends Object{

String uid;
String name = 'Mohammad Tahvili';
String email = 'tahvili@outlook.com';
String phoneNumber = '6479950165';
String location = 'Mississauga, Ontario, Canada';
String profilePicture = 'assets/profile.jpg';
String activeStates = 'true';
var dateCreated;
var dateLastLogin;


  User({this.uid});

  String isActive(){
    return activeStates;
  }

  String changeStatus(){
    if (activeStates=='true') {
      activeStates = 'false';
      print(activeStates);
    }
    else{
      activeStates = 'true';
      print(activeStates);
    }
  }

  String getProfilePicture(){
  return profilePicture;
  }

  String getName(){
    return name;
  }

}
