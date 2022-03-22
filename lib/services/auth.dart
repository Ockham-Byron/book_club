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

  Future<String> logInUser(String email, String password) async {
    String message = "error";

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      message = "success";
    } on FirebaseAuthException catch (error) {
      //print(error.message);
      message = error.message.toString();
    }

    return message;
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
    } on FirebaseAuthException catch (signUpError) {
      if (signUpError.message ==
          "The email address is already in use by another account.") {
        message = "Il existe déjà un compte avec ce mail.";
      } else {
        message = "erreur inconnue";
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
  // Future<String> sendPasswordResetEmail(String email) async {
  //   String message = "error";
  //   try {
  //     _auth.sendPasswordResetEmail(email: email);
  //     message = "success";
  //   } on FirebaseAuthException catch (emailError) {
  //     print("problème mail :");
  //     print(emailError.message);
  //     if (emailError.message ==
  //         "There is no user record corresponding to this identifier. The user may have been deleted.") {
  //       message = "Aucun compte correspondant à ce mail.";
  //     } else {
  //       message = "erreur inconnue";
  //     }
  //   }
  //   return message;
  // }

  Future<String> sendPasswordResetEmail(String email) async {
    String message = "error";
    try {
      _auth.sendPasswordResetEmail(email: email);

      message = "success";
    } catch (e) {
      print(e);
    }

    return message;
  }

  // Reset email
  Future<String> resetEmail(String email) async {
    String message = "error";
    try {
      await _auth.currentUser!.updateEmail(email);
      message = "success";
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          "This operation is sensitive and requires recent authentication. Log in again before retrying this request.") {
        message = "exception";
      }
    } catch (e) {
      //print("autre problème");
    }
    return message;
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
    } on PlatformException catch (e) {
      print(e.message);
      message = "error";
    }
    return message;
  }
}
