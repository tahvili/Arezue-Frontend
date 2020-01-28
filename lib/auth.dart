import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  Stream<String> get OnAuthStateChanged;
  Future<String> signInWithEmailAndPassword(
      String email, String password,
      );
  Future<String> createUserWithEmailAndPassword(
      String email, String password,
      );
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth =  FirebaseAuth.instance; //this will get FirebaseAuth from a singleton instance

  @override
  // TODO: implement OnAuthStateChanged
  Stream<String> get OnAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
          (FirebaseUser user) => user?.uid); //to tell us whether or not the user is signed in to firebase

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
    return (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    )).user.uid;
  }

  @override
  Future<String> currentUser() async { //just for grabbing the user once they have signed in
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email,
        password: password)).user.uid;
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

}
