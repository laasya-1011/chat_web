import 'package:chat_web/models/appuse.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:chat_web/utils/firebaseConstans.dart';

class AuthMethod {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AppUse _userFromFirebaseUser(User user) {
    return user != null ? AppUse(userId: user.uid) : null;
  }

  Future signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
