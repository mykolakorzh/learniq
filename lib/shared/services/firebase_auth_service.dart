import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// Firebase Authentication Service
///
/// Handles user authentication with:
/// - Anonymous sign-in (default, no prompts)
/// - Google Sign-In (optional upgrade)
/// - Account linking (anonymous → Google)
class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Current authenticated user (can be anonymous or signed in)
  User? get currentUser => _auth.currentUser;

  /// User ID for Firestore queries
  String? get userId => _auth.currentUser?.uid;

  /// Check if user is signed in with a real account (not anonymous)
  bool get isSignedIn => _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  /// Check if user is anonymous
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in anonymously (default for all new users)
  /// This happens automatically on first app launch
  Future<User?> signInAnonymously() async {
    try {
      debugPrint('[Auth] Signing in anonymously...');
      final userCredential = await _auth.signInAnonymously();
      debugPrint('[Auth] Anonymous sign-in successful: ${userCredential.user?.uid}');
      return userCredential.user;
    } catch (e) {
      debugPrint('[Auth] Anonymous sign-in failed: $e');
      rethrow;
    }
  }

  /// Sign in with Google and link to existing anonymous account
  /// This preserves all local progress when upgrading to a real account
  Future<User?> signInWithGoogle() async {
    try {
      debugPrint('[Auth] Starting Google Sign-In...');

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('[Auth] User cancelled Google Sign-In');
        return null; // User cancelled
      }

      debugPrint('[Auth] Google user signed in: ${googleUser.email}');

      // Get Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // If user is anonymous, link the accounts to preserve progress
      if (_auth.currentUser?.isAnonymous == true) {
        debugPrint('[Auth] Linking anonymous account with Google...');
        try {
          final userCredential = await _auth.currentUser!.linkWithCredential(credential);
          debugPrint('[Auth] Account linking successful: ${userCredential.user?.uid}');
          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use') {
            // This Google account is already linked to another user
            // Sign out anonymous user and sign in with Google
            debugPrint('[Auth] Google account already in use, signing in instead');
            await _auth.signOut();
            final userCredential = await _auth.signInWithCredential(credential);
            return userCredential.user;
          }
          rethrow;
        }
      } else {
        // User is not anonymous, just sign in with Google
        debugPrint('[Auth] Signing in with Google credential...');
        final userCredential = await _auth.signInWithCredential(credential);
        debugPrint('[Auth] Google sign-in successful: ${userCredential.user?.uid}');
        return userCredential.user;
      }
    } catch (e) {
      debugPrint('[Auth] Google sign-in error: $e');
      rethrow;
    }
  }

  /// Sign out and return to anonymous mode
  /// Note: This will clear the Google account but keep local data
  Future<void> signOut() async {
    try {
      debugPrint('[Auth] Signing out...');
      await _googleSignIn.signOut();
      await _auth.signOut();
      // Automatically sign in anonymously again
      await signInAnonymously();
      debugPrint('[Auth] Signed out and returned to anonymous mode');
    } catch (e) {
      debugPrint('[Auth] Sign out error: $e');
      rethrow;
    }
  }

  /// Get user display information
  Map<String, String?> getUserInfo() {
    final user = _auth.currentUser;
    if (user == null) return {};

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'isAnonymous': user.isAnonymous.toString(),
    };
  }

  /// Check if user has a linked Google account
  bool hasGoogleAccount() {
    final user = _auth.currentUser;
    if (user == null) return false;

    return user.providerData.any(
      (info) => info.providerId == 'google.com',
    );
  }

  /// Delete anonymous account (use with caution!)
  /// This will permanently delete the user and all their data
  Future<void> deleteAccount() async {
    try {
      debugPrint('[Auth] Deleting user account...');
      await _auth.currentUser?.delete();
      debugPrint('[Auth] Account deleted successfully');
    } catch (e) {
      debugPrint('[Auth] Delete account error: $e');
      rethrow;
    }
  }
}
