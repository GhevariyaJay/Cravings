import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/user.dart';

class AuthService {
  static final _auth = firebase_auth.FirebaseAuth.instance;
  static final _firestore = firestore.FirebaseFirestore.instance;

  // Get the current user from Firebase Authentication (basic data)
  static User? get currentUser => _auth.currentUser != null
      ? User(
    id: _auth.currentUser!.uid,
    name: _auth.currentUser!.displayName ?? '',
    email: _auth.currentUser!.email ?? '',
    isAdmin: false, // Default until role is fetched
  )
      : null;

  // Fetch user data with role from Firestore (includes isAdmin)
  static Future<User?> getCurrentUserWithRole() async {
    if (_auth.currentUser == null) {
      print("No authenticated user found");
      return null;
    }
    print("Fetching Firestore data for UID: ${_auth.currentUser!.uid}");
    try {
      final adminDoc = await _firestore.collection('admins').doc(_auth.currentUser!.uid).get();
      final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

      if (adminDoc.exists) {
        final adminData = adminDoc.data();
        print("Admin data: $adminData");
        return User(
          id: _auth.currentUser!.uid,
          name: adminData?['name'] ?? _auth.currentUser!.displayName ?? '',
          email: _auth.currentUser!.email ?? '',
          isAdmin: true,
        );
      } else if (userDoc.exists) {
        final userData = userDoc.data();
        print("User data: $userData");
        return User(
          id: _auth.currentUser!.uid,
          name: _auth.currentUser!.displayName ?? '',
          email: userData?['email'] ?? _auth.currentUser!.email ?? '',
          isAdmin: false,
        );
      } else {
        print("No Firestore document found for UID: ${_auth.currentUser!.uid}");
        return User(
          id: _auth.currentUser!.uid,
          name: _auth.currentUser!.displayName ?? '',
          email: _auth.currentUser!.email ?? '',
          isAdmin: false,
        );
      }
    } catch (e) {
      print("Error fetching Firestore data: $e");
      return User(
        id: _auth.currentUser!.uid,
        name: _auth.currentUser!.displayName ?? '',
        email: _auth.currentUser!.email ?? '',
        isAdmin: false,
      );
    }
  }

  // Login with email and password
  static Future<bool> login(String email, String password) async {
    try {
      print("Logging in with email: $email");
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("Login successful for UID: ${_auth.currentUser!.uid}");
      await _auth.currentUser!.reload();
      return true;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  // Signup with email, password, and name, then keep user logged in
  static Future<bool> signup(String email, String password, String name) async {
    try {
      print("Signing up with email: $email, name: $name");
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User created with UID: ${userCredential.user!.uid}");

      // Update display name in Firebase Auth
      await userCredential.user!.updateDisplayName(name);
      print("Display name updated to: $name");

      // Determine if user is admin based on email
      final isAdmin = email.toLowerCase().contains('admin');
      print("User isAdmin: $isAdmin");

      // Store data in appropriate collection
      if (isAdmin) {
        final adminData = {
          'name': name,
          'email': email,
          'password': password, // Note: Storing passwords in plain text is insecure; see notes
        };
        print("Writing admin data to Firestore: $adminData");
        await _firestore.collection('admins').doc(userCredential.user!.uid).set(adminData);
        print("Admin data stored in admins collection for UID: ${userCredential.user!.uid}");
      } else {
        final userData = {
          'name': name,
          'email': email,
        };
        print("Writing user data to Firestore: $userData");
        await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);
        print("User data stored in users collection for UID: ${userCredential.user!.uid}");
      }

      // Keep user logged in and refresh data for immediate home screen access
      print("Signup complete, keeping user logged in for redirect to home screen");
      await _auth.currentUser!.reload();
      return true; // Indicate signup success
    } catch (e) {
      print("Signup failed: $e");
      return false;
    }
  }

  // Logout from Firebase Authentication
  static Future<void> logout() async {
    try {
      print("Attempting to log out...");
      await _auth.signOut();
      print("Logout successful");
    } catch (e) {
      print("Logout failed: $e");
      throw e;
    }
  }

  // Force refresh user data after login
  static Future<User?> refreshUserData() async {
    if (_auth.currentUser == null) {
      print("No user to refresh");
      return null;
    }
    await _auth.currentUser!.reload();
    return getCurrentUserWithRole();
  }
}