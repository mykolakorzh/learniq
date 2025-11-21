import 'package:flutter/material.dart';
import 'dart:async';

/// Centralized image loading service with caching and preloading support
class ImageService {
  // Cache for preloaded images
  static final Map<String, ImageProvider> _imageCache = {};

  // Track which images are being loaded
  static final Set<String> _loadingImages = {};

  /// Preload an image asset
  /// Returns true if preload was successful or already cached
  static Future<bool> preloadImage(String imagePath) async {
    if (_imageCache.containsKey(imagePath)) {
      return true; // Already cached
    }

    if (_loadingImages.contains(imagePath)) {
      return true; // Already loading
    }

    try {
      _loadingImages.add(imagePath);

      // Load the image asset
      final assetImage = AssetImage(imagePath);

      // Wait for the image to be loaded
      final completer = Completer<void>();
      final imageStream = assetImage.resolve(const ImageConfiguration());
      imageStream.addListener(
        ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onError: (exception, stackTrace) {
            if (!completer.isCompleted) {
              completer.completeError(exception);
            }
          },
        ),
      );

      await completer.future;
      _imageCache[imagePath] = assetImage;
      return true;
    } catch (e) {
      debugPrint('Failed to preload image $imagePath: $e');
      return false;
    } finally {
      _loadingImages.remove(imagePath);
    }
  }

  /// Preload multiple images
  static Future<void> preloadImages(List<String> imagePaths) async {
    final futures = imagePaths.map((path) => preloadImage(path));
    await Future.wait(futures, eagerError: false);
  }

  /// Clear the image cache
  static void clearCache() {
    _imageCache.clear();
  }

  /// Get cached image count
  static int getCacheSize() {
    return _imageCache.length;
  }
}

