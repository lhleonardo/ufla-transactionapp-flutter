import "package:firebase_auth/firebase_auth.dart";
import 'package:start/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _convertFirebaseUser(FirebaseUser user) {
    if (user != null) {
      return User(name: user.displayName, uid: user.uid);
    }

    return null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_convertFirebaseUser);
  }

  Future signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return _convertFirebaseUser(result.user);
  }

  Future registerWithEmailWithPassword(
      String name, String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;

    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;

    await user.updateProfile(userUpdateInfo);
    await user.reload();
    return _convertFirebaseUser(result.user);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
