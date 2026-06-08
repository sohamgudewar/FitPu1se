import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

final class AuthNotifier extends ChangeNotifier {
  User? _user;
  bool _initialized = false;

  User? get user => _user;
  bool get isLoggedIn => _user != null && _initialized;
  bool get initialized => _initialized;

  Future<void> init() async {
    await Firebase.initializeApp(options: firebaseConfig);
    FirebaseAuth.instance.authStateChanges().listen((u) {
      _user = u;
      _initialized = true;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    final auth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) => AuthNotifier());
