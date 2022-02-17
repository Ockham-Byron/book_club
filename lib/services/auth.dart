import 'package:book_club/models/auth_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:book_club/services/db_future.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create auth obj based on firebase user
  AuthModel? _userFromFirebaseUser(User user) {
    return AuthModel(uid: user.uid);
  }

  // auth change user stream
  Stream<AuthModel?> get authUser {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //Sign in with email and password

  Future<bool> logInUser(String email, String password) async {
    bool retValue = false;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      retValue = true;
    } catch (e) {
      // print(e);
    }

    return retValue;
  }

  //Register with email and password

  Future<String> registerUser(
      String email, String password, String pseudo, String pictureUrl) async {
    String message = "error";

    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);

      UserModel _user = UserModel(
        uid: _userCredential.user!.uid,
        email: _userCredential.user!.email,
        pseudo: pseudo.trim(),
        pictureUrl: pictureUrl,
      );

      String _resultMessage = await DBFuture().createUser(_user);
      if (_resultMessage == "success") {
        message = "success";
      }
      message = "success";
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          message =
              "$email a déjà été enregistré. Avez-vous oublié votre mot de passe ?";
        }
      }
    }
    return message;
  }

  //Sign Out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

  // Reset Password
  Future<String> sendPasswordResetEmail(String email) async {
    String retVal = "error";
    try {
      _auth.sendPasswordResetEmail(email: email);
      retVal = "sucess";
    } catch (e) {
      //print(e);
    }
    return retVal;
  }

  // Reset email
  Future<String> resetEmail(String email) async {
    String retVal = "error";
    try {
      await _auth.currentUser!.updateEmail(email);
      retVal = "success";
    } on PlatformException catch (e) {
      //print(e);
      retVal = "exception";
    } catch (e) {
      //print(e);
    }
    return retVal;
  }

  // Reset password
  Future<String> resetPassword(String password) async {
    String retVal = "error";
    try {
      _auth.currentUser!.updatePassword(password);
      retVal = "success";
    } catch (e) {
      // print(e);
    }

    return retVal;
  }

  //Delete user
  Future<String> deleteUser() async {
    String message = "error";
    try {
      _auth.currentUser!.delete();
      message = "success";
    } catch (e) {
      //print(e);
    }
    return message;
  }
}
