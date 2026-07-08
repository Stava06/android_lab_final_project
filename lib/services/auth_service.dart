import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Service responsible for managing user authentication and database synchronization.
/// Handles registration, login, logout, password hashing, and user profile retrieval.
class AuthService {
  // Instances of Firebase Auth and Realtime Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  /// Stream of user authentication state changes.
  /// Used by widgets like AuthGate to dynamically adapt the UI based on session status.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retrieves the currently authenticated Firebase user, if any.
  User? get currentUser => _auth.currentUser;

  /// Registers a new user.
  /// Creates the account in Firebase Auth, hashes the password using SHA-256,
  /// and saves the user record in Firebase Realtime Database.
  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // 1. Create user credential via Firebase Auth using email and password
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('User creation failed');
    }

    // 2. Hash the password using SHA-256 for secure database storage
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    // 3. Store the supplementary user details in Firebase Realtime Database
    await _database.child('users').child(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': email,
      'password': hashedPassword,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  /// Authenticates an existing user via email and password using Firebase Auth.
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Signs out the currently authenticated user.
  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  /// Retrieves user profile details from Firebase Realtime Database for the current user.
  /// Returns null if no user is signed in or if the profile record does not exist.
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    // Retrieve database snapshot for the user's UID
    final snapshot = await _database.child('users').child(user.uid).get();

    if (!snapshot.exists) {
      return null;
    }

    // Convert the database value map to a strongly typed Dart Map
    return Map<String, dynamic>.from(snapshot.value as Map);
  }
}
