import 'package:arezue/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Stream<String> get OnAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
      String email, String password,
      );
  Future<String> createUserWithEmailAndPassword(
      String name,
      String email, String password,
      );
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  User userFromFirebaseUser(FirebaseUser user);
  Future<bool> checkEmailVerification();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth =  FirebaseAuth.instance; //this will get FirebaseAuth from a
  // singleton instance

  //create user obj based on FirebaseUser
  User userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  // TODO: implement OnAuthStateChanged
  Stream<String> get OnAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
          (FirebaseUser user) => userFromFirebaseUser(user)?.uid); //to tell us whether or not the user is signed in to firebase

  @override
  Future<String> createUserWithEmailAndPassword(String name, String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
//    return (await _firebaseAuth.createUserWithEmailAndPassword(
//        email: email,
//        password: password,
//    )).user.uid;
//  }
    FirebaseUser user = (await _firebaseAuth.
    createUserWithEmailAndPassword(email: email, password: password)).user;
    try {
      await user.sendEmailVerification(); //make an api
      return user.uid;
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
  }

  Future<bool> checkEmailVerification() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    //await user.reload();
    //user = await _firebaseAuth.currentUser();
    bool flag = user.isEmailVerified;
    return flag;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
//    try {
//      return (await _firebaseAuth.signInWithEmailAndPassword(email: email,
//          password: password)).user.uid;
//    } catch (e) {
//      print(e.toString());
//      return null;
//    }
    FirebaseUser user = (await  _firebaseAuth.signInWithEmailAndPassword(email: email, password:password)).user;
    if (user.isEmailVerified)
      return user.uid;
    return null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}
