import 'package:photo_manager/photo_manager.dart';

class PhotoService {
  static Future<List<AssetEntity>> getRecentPhotos() async {
    print("ENGINE: --- Method Started ---");

    // 1. Request Permission
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    print("ENGINE: Permission State: $ps");

    if (!ps.isAuth) {
      print("ENGINE: Permission NOT granted.");
      return [];
    }

    // 2. Fetch Albums
    print("ENGINE: Fetching albums...");
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isEmpty) {
      print("ENGINE: No albums found.");
      return [];
    }

    // 3. Log all albums found to help us debug
    for (var album in albums) {
      int count = await album.assetCountAsync;
      print("ENGINE: Album [${album.name}] has $count photos");
    }

    // 4. Get photos from the "Recent" folder (usually the first one)
    AssetPathEntity recentAlbum = albums.first;
    List<AssetEntity> photos = await recentAlbum.getAssetListRange(start: 0, end: 50);

    print("ENGINE: Successfully fetched ${photos.length} photos.");
    return photos;
  }
}