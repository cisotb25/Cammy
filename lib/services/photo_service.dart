import 'package:photo_manager/photo_manager.dart';

class PhotoService {
  static Future<List<AssetEntity>> getRecentPhotos() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!ps.isAuth) return [];

    // Request all types but we'll filter for images
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    if (albums.isEmpty) {
      print("ENGINE: No albums found at all.");
      return [];
    }

    // Debug: Print album names to your console so you can see what the phone is reporting
    for (var album in albums) {
      print("ENGINE: Found album: ${album.name} with ${await album.assetCountAsync} photos");
    }

    // Try to find the "Recent" or "All" album specifically,
    // or just take the one with the most photos.
    AssetPathEntity mainAlbum = albums.firstWhere(
            (a) => a.isAll,
        orElse: () => albums[0]
    );

    return await mainAlbum.getAssetListRange(start: 0, end: 50);
  }
}