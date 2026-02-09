import 'package:photo_manager/photo_manager.dart';

class PhotoService {
  static Future<List<AssetEntity>> getRecentPhotos() async {
    // This is the correct method for photo_manager 3.0.0+
    // If it's red, we'll fix the IDE in the next step.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!ps.isAuth) {
      print("Permission denied or limited");
      return [];
    }

    // Fetch the list of albums
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) return [];

    // Get the first 50 photos from the first album (usually 'Recent' or 'All')
    return await albums[0].getAssetListRange(start: 0, end: 50);
  }
}