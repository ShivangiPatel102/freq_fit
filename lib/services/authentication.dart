import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  static Future<UserCredential?> registerUser(
      String email, String password,String firstName, String lastName) async {
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // await UserDataStorage.saveUserData(firstName, lastName, email);
      if (newUser != null) {
        return newUser;
      }
    } catch (e) {
      // Handle registration errors
      print("Error registering user: $e");
      rethrow; // Rethrow the exception for further error handling
    }
  }

  static Future<void> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
      rethrow; // Rethrow the exception for further error handling
    }
  }

  static Future<void> signOutUser(BuildContext context) async {
    await _auth.signOut();
       try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout error
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}