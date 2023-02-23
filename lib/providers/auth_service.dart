

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/user_provider.dart';

import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final userProvider = UserProvider();

  User? getCurrentUser() {
    var currentUser = _firebaseAuth.currentUser;

    return currentUser;
  }

  AppUser? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      email: user.email,
    );
  }

  Stream<AppUser?> get appUser {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(credential.user);
  }

  Future<AppUser?> createUserWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      currentUser.updateDisplayName(displayName);
    }
    AppUser appUser = new AppUser(email: email, displayName: displayName);
    userProvider.addUserToDatabase(appUser);

    return _userFromFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
