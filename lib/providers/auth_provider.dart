import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  bool _isInitializing = true;
  String? _errorMessage;

  AuthProvider() {
    _initAuthStateListener();
  }

  bool get isAuthenticated => _user != null;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  
  // A profile is complete if the user has gone through onboarding and set their last period date
  bool get isProfileComplete => _user?.lastPeriodDate != null;

  void _initAuthStateListener() {
    _authService.authStateChanges.listen((firebase_auth.User? firebaseUser) async {
      debugPrint('[NARICARE DIAGNOSTICS] Auth State Changed: ${firebaseUser?.uid ?? 'Logged Out'}');
      
      try {
        if (firebaseUser != null) {
          // Fetch extended profile from Firestore
          debugPrint('[NARICARE DIAGNOSTICS] Fetching profile for: ${firebaseUser.uid}');
          final firestoreUser = await _firestoreService.getUser(firebaseUser.uid).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('[NARICARE DIAGNOSTICS] Profile fetch TIMEOUT');
              return null;
            },
          );
          
          if (firestoreUser != null) {
            debugPrint('[NARICARE DIAGNOSTICS] Profile Fetched Successfully');
            _user = firestoreUser;
          } else {
            debugPrint('[NARICARE DIAGNOSTICS] Profile not found. Creating skeleton.');
            _user = User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName ?? 'User',
              email: firebaseUser.email ?? '',
            );
          }
        } else {
          _user = null;
        }
      } catch (e) {
        debugPrint('[NARICARE DIAGNOSTICS] ERR: Auth Listener Error: $e');
        // Do not block _isInitializing if profile fetch fails
      } finally {
        _isInitializing = false;
        notifyListeners();
        debugPrint('[NARICARE DIAGNOSTICS] Auth Initialization Finished (Success/Fail)');
      }
    });
  }

  Future<void> tryAutoLogin() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser != null) {
      final firestoreUser = await _firestoreService.getUser(firebaseUser.uid);
      _user = firestoreUser ?? User(id: firebaseUser.uid, name: firebaseUser.displayName ?? 'User', email: firebaseUser.email ?? '');
    }
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> signup(String name, String email, String password) async {
    _errorMessage = null;
    try {
      final firebaseUser = await _authService.signUp(name, email, password);
      // Listener handles user creation
      return firebaseUser != null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    try {
      final firebaseUser = await _authService.signIn(email, password);
      // Listener handles profile loading
      return firebaseUser != null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<bool> updateCycleSettings({
    int? avgCycleLength,
    int? avgPeriodDuration,
    DateTime? lastPeriodDate,
  }) async {
    if (_user == null) return false;
    _user = _user!.copyWith(
      avgCycleLength: avgCycleLength,
      avgPeriodDuration: avgPeriodDuration,
      lastPeriodDate: lastPeriodDate,
    );
    
    // Persist to Firestore
    await _firestoreService.saveUser(_user!);
    notifyListeners();
    return true;
  }
}
