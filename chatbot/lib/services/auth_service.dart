import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Signup: Create anonymous user, store email and name
  Future<String?> signup(String email, String name) async {
    try {
      // Sign in anonymously to get a UID
      UserCredential cred = await _auth.signInAnonymously();
      String uid = cred.user!.uid;

      // Store email and name in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email.toLowerCase(),
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return uid; // Return UID on success
    } catch (e) {
      print('Signup error: $e');
      return null; // Return null on failure
    }
  }

  // Login: Verify email and name in Firestore, use anonymous auth
  Future<String?> login(String email, String name) async {
    try {
      // Check if email and name exist in Firestore
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email.toLowerCase())
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null; // No matching user
      }

      // Get UID from Firestore
      String uid = query.docs.first.id;

      // Sign in anonymously to create a session
      await _auth.signInAnonymously();

      return uid; // Return UID on success
    } catch (e) {
      print('Login error: $e');
      return null; // Return null on failure
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
