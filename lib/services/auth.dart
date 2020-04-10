import 'package:arezue/employer/employer.dart';
import 'package:arezue/services/http.dart';
import 'package:arezue/jobseeker/jobseeker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

abstract class BaseAuth {
  //Stream<String> get OnAuthStateChanged;
  Future signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future createUserWithEmailAndPassword(
      String name, String email, String password, String company, String type);
  Future<String> currentUser();
  Future<void> signOut();
  Future sendPasswordResetEmail(String email);
  Jobseeker userFromFirebaseUser(FirebaseUser user);
  Future<bool> checkEmailVerification();
  Future<void> sendEmailVerification();
}

class Auth implements BaseAuth {
  String dbID, userType;
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; //this will get FirebaseAuth from a
  // singleton instance
  Requests request = new Requests();

  //create user obj based on FirebaseUser
//  User userFromFirebaseUser(FirebaseUser user){
//    return user != null ? User(uid: user.uid) : null;
//  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Done";
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    var user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

//  @override
//  // TODO: implement OnAuthStateChanged
//  Stream<String> get OnAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
//      (FirebaseUser user) => userFromFirebaseUser(user)
//          ?.uid); //to tell us whether or not the user is signed in to firebase

  @override
  Future createUserWithEmailAndPassword(String name, String email,
      String password, String company, String type) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password)).user;
    try {
      await user.sendEmailVerification();
      Future<int> status;
      if (type == "employer") {
        status = request.employerPostRequest(user.uid, email, name, company);
      } else {
        status = request.jobseekerPostRequest(user.uid, email, name);
      }
      if ((await status) == 200) {
        signOut();
        return user;
      } else if ((await status) == 400) {
        print("User could not be created");
        user.delete();
        return null;
      } else {
        user.delete();
        print("server error");
        return null;
      }
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
      return null;
    }
  }

  Future<bool> checkEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    bool flag;
    if (user == null) {
      flag = false;
    } else {
      flag = user.isEmailVerified;
    }
    return flag;
  }

  Future<String> currentUser() async { // returns the current users database ID
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? dbID : null;
  }

  @override
  Future signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password)).user;
    try {
      if (user.isEmailVerified) {
        var url = 'https://api.daffychuy.com/api/v1/init';
        var response = await http.post(url,
            body: {'firebaseID': user.uid});
        var parsedResponse = json.decode(response.body);
        dbID = parsedResponse['payload']['uid'];
        userType = parsedResponse['payload']['user_type'];
        int statusCode = response.statusCode;
        if ((statusCode) == 200) {
          print(userType);
          if(userType == "employer"){
            return Employer.fromJson(parsedResponse);
          }
          else {
            return Jobseeker.fromJson(parsedResponse);
          }
        } else if (statusCode == 400) {
          print("User not found");
          return null;
        } else {
          print("Server error");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("An error occured while logging in");
      print(e.message);
      return null;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Jobseeker userFromFirebaseUser(FirebaseUser user) {
    // TODO: implement userFromFirebaseUser
    return null;
  }
}
