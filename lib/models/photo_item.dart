import 'package:photo_manager/photo_manager.dart';

// Possible states for a photo
enum PhotoStatus { unorganized, keep, delete }

class PhotoItem {
  final String id;
  final AssetEntity asset;
  PhotoStatus status; // Track if it's kept or deleted

  PhotoItem({
    required this.id,
    required this.asset,
    this.status = PhotoStatus.unorganized
  });

  // Helper to get the date of the photo
  DateTime get date => asset.createDateTime;
}