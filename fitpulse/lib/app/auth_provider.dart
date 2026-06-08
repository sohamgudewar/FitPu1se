import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final provider = GoogleAuthProvider();
    await FirebaseAuth.instance.signInWithPopup(provider);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) => AuthNotifier());
