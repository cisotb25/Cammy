import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class PhotoViewerScreen extends StatelessWidget {
  final AssetEntity asset;

  const PhotoViewerScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Transparent AppBar so it doesn't distract from the photo
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: asset.id, // Must match the tag in the Gallery Screen
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: AssetEntityImage(
              asset,
              isOriginal: true, // Loads the full rectangular version
              fit: BoxFit.contain, // Shows the whole image without cropping
            ),
          ),
        ),
      ),
    );
  }
}