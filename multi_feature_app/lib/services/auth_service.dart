// Packages
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// Models
import '../models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return User(id: user.uid, email: user.email!);
  }

  Future<User> signUp(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    await user.sendEmailVerification(); // Send verification email
    return User(id: user.uid, email: user.email!);
  }

  // Sign up with additional user details for DL4D registration
  Future<User> signUpWithDetails(
    String firstName,
    String lastName,
    String phone,
    String userCode,
    String email,
    String password,
    String birthday,
    String department,
    String education,
    String gender,
    File? profileImage,
  ) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    await user.sendEmailVerification(); // Send verification email
    String? imageUrl;
    if (profileImage != null) {
      final storageRef = _storage.ref().child('profile_images/${user.uid}.jpg');
      await storageRef.putFile(profileImage);
      imageUrl = await storageRef.getDownloadURL();
    }
    await _firestore.collection('users').doc(user.uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'userCode': userCode,
      'email': email,
      'birthday': birthday,
      'department': department,
      'education': education,
      'gender': gender,
      'profileImageUrl': imageUrl,
    });
    return User(id: user.uid, email: user.email!);
  }

  // Sign in anonymously
  Future<User> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    final user = userCredential.user!;
    return User(id: user.uid, email: 'anonymous@${user.uid}');
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
