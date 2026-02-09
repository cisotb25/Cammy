import 'package:photo_manager/photo_manager.dart';

class PhotoItem {
  final String id;
  final AssetEntity asset; // This is the real file reference

  PhotoItem({required this.id, required this.asset});
}