import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'firebase_auth_service.dart';
import '../../services/progress_service.dart';

/// Firestore Sync Service
///
/// Handles syncing progress data between local storage (SharedPreferences)
/// and cloud storage (Firestore).
///
/// Strategy:
/// - Anonymous users: Data stored locally only
/// - Signed-in users: Data synced to Firestore automatically
/// - On sign-in: Local data uploaded to cloud
/// - On sign-out: Cloud data remains, local data kept
class FirestoreSyncService {
  FirestoreSyncService._();
  static final FirestoreSyncService instance = FirestoreSyncService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService.instance;

  /// Upload local progress to Firestore (called when user signs in)
  /// Note: For now, syncing is disabled until you complete Firebase setup
  Future<void> uploadLocalProgress() async {
    debugPrint('[Sync] Cloud sync not yet configured - run Firebase setup first');
    // TODO: Implement after Firebase is configured
    // This will sync local progress (lastAccuracy, mistakeIds) to Firestore
  }

  /// Download progress from Firestore to local storage
  /// Note: For now, syncing is disabled until you complete Firebase setup
  Future<void> downloadProgress() async {
    debugPrint('[Sync] Cloud sync not yet configured - run Firebase setup first');
    // TODO: Implement after Firebase is configured
  }

  /// Sync a single topic's progress to Firestore
  /// Called after completing a quiz/test
  Future<void> syncTopicProgress(String topicId) async {
    debugPrint('[Sync] Cloud sync not yet configured - run Firebase setup first');
    // TODO: Implement after Firebase is configured
  }

  /// Listen to real-time progress updates from Firestore
  /// Not yet implemented - requires Firebase setup
  Stream<Map<String, TopicProgress>> watchProgress() {
    return Stream.value({});
  }

  /// Clear all cloud progress (called when user signs out)
  /// Note: This doesn't delete from Firestore, just stops syncing
  Future<void> clearCloudProgress() async {
    debugPrint('[Sync] Cloud sync stopped (user signed out)');
    // We don't actually delete cloud data, just stop syncing
    // This way user can sign back in and restore progress
  }

  /// Full sync: Upload local → Download cloud → Merge
  /// Called when user signs in with Google
  Future<void> fullSync() async {
    try {
      debugPrint('[Sync] Starting full sync...');

      // First, download cloud data
      await downloadProgress();

      // Then, upload any local data that's newer
      await uploadLocalProgress();

      debugPrint('[Sync] Full sync completed');
    } catch (e) {
      debugPrint('[Sync] Full sync error: $e');
    }
  }
}
