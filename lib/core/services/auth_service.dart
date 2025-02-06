import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:helphive_flutter/core/models/user.dart' as custom;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user object based on Firebase user
  custom.User? _userFromFirebaseUser(User? user) {
    return user != null ? custom.User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<custom.User?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in with email & password
  Future<custom.User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Fetch the token
      String? token = await gethUserToken();

      // Save the token if it is available
      if (token != null) {
        await saveUserToken(user!.uid, token);
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Register with email & password and username
  Future<custom.User?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Store the username in Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });

        // Fetch the token
        String? token = await gethUserToken();

        // Save the token if it is available
        if (token != null) {
          await saveUserToken(user.uid, token);
        }
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // Password Reset
  Future passwordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

/*------------------- VALIDATIONS----------------- */

  //Sign In validation
  Future<String?> signInWithEmailAndPasswordWithValidation(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Bitte füllen Sie alle Felder aus!';
    }

    if (!isValidEmail(email)) {
      return 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
    }

    dynamic result = await signInWithEmailAndPassword(email, password);
    if (result == null) {
      return 'Bitte Daten überprüfen!';
    }

    return null;
  }

  //E-Mail validation
  bool isValidEmail(String email) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Überprüft die Passwortstärke
  bool isValidPassword(String password) {
    // Mindestens 10 Zeichen, mindestens ein Buchstabe und eine Zahl
    const pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  // Überprüft, ob Passwort und Bestätigungspasswort übereinstimmen
  bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /*------------------- OTHERS----------------- */

  // Get the current logged-in user ID

  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  // Get username by user ID
  Future<String?> getUsernameById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc['username'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
  // user_service.dart

  Future<String> getUsername() async {
    String? userId = AuthService().getCurrentUserId();
    if (userId != null) {
      String? fetchedUsername = await AuthService().getUsernameById(userId);
      return fetchedUsername ?? 'Unknown User';
    }
    return 'Unknown User';
  }

  Future<Map<String, String>> getAllUsernames() async {
    Map<String, String> usernames = {};
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      for (var doc in querySnapshot.docs) {
        usernames[doc.id] = doc['username'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return usernames;
  }

  Future<void> saveUserToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
      if (kDebugMode) {
        print("Token saved for user: $userId");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving token to Firestore: $e');
      }
    }
  }

  Future<String?> gethUserToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching token: $e');
      }
      return null;
    }
  }
}
