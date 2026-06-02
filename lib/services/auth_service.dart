import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Track Auth State efficiently
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Basic SignUp (Name is stored in displayName)
  Future<User?> signUp(String name, String email, String password) async {
    try {
      debugPrint('[NARICARE DIAGNOSTICS] Starting SignUp for: $email');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('[NARICARE DIAGNOSTICS] ERR: SignUp timed out (Check internet/DNS)');
        throw FirebaseAuthException(code: 'network-request-failed', message: 'The connection timed out.');
      });

      User? user = result.user;
      if (user != null) {
        debugPrint('[NARICARE DIAGNOSTICS] User Created: ${user.uid}. Updating display name to $name');
        await user.updateDisplayName(name).timeout(const Duration(seconds: 5));
        await user.reload();
        debugPrint('[NARICARE DIAGNOSTICS] SignUp Complete for: ${user.uid}');
        return _auth.currentUser;
      }
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] ERR: SignUp Firebase Exception: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] ERR: SignUp Unknown Error: $e');
      throw 'An unexpected error occurred during signup.';
    }
  }

  // Basic SignIn
  Future<User?> signIn(String email, String password) async {
    try {
      debugPrint('[NARICARE DIAGNOSTICS] Starting SignIn for: $email');
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('[NARICARE DIAGNOSTICS] ERR: SignIn timed out (Check internet/DNS)');
        throw FirebaseAuthException(code: 'network-request-failed', message: 'The connection timed out.');
      });

      debugPrint('[NARICARE DIAGNOSTICS] SignIn Success for: ${result.user?.uid}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] ERR: SignIn Firebase Exception: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('[NARICARE DIAGNOSTICS] ERR: SignIn Unknown Error: $e');
      throw 'An unexpected error occurred during login.';
    }
  }

  // Basic SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user details
  User? get currentUser => _auth.currentUser;

  // Simple Error Handling
  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No user found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'invalid-email': return 'The email address is badly formatted.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use': return 'An account already exists for this email.';
      case 'weak-password': return 'The password is too weak.';
      default: return e.message ?? 'An unknown error occurred.';
    }
  }
}
