import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:intl/intl.dart';
import '../models/photo_item.dart';
import 'photo_viewer_screen.dart';

enum GalleryViewMode { day, month, year }

class GalleryScreen extends StatefulWidget {
  final List<PhotoItem> allPhotos;

  const GalleryScreen({super.key, required this.allPhotos});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GalleryViewMode _currentMode = GalleryViewMode.day;

  // Helper to group photos based on the selected mode
  Map<String, List<PhotoItem>> get _groupedPhotos {
    Map<String, List<PhotoItem>> groups = {};
    for (var photo in widget.allPhotos) {
      String key;
      if (_currentMode == GalleryViewMode.year) {
        key = DateFormat('yyyy').format(photo.date);
      } else if (_currentMode == GalleryViewMode.month) {
        key = DateFormat('MMMM yyyy').format(photo.date);
      } else {
        key = DateFormat('MMMM dd, yyyy').format(photo.date);
      }

      if (!groups.containsKey(key)) groups[key] = [];
      groups[key]!.add(photo);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupedPhotos;
    final sortedKeys = groups.keys.toList(); // Note: For a pro app, sort by DateTime objects

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- THE SORT TOGGLES (From Mockup Page 2) ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _toggleButton("Days", GalleryViewMode.day),
                _toggleButton("Months", GalleryViewMode.month),
                _toggleButton("Years", GalleryViewMode.year),
              ],
            ),
          ),

          Expanded(
            child: sortedKeys.isEmpty
                ? const Center(child: Text("No photos found"))
                : ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                String title = sortedKeys[index];
                List<PhotoItem> photos = groups[title]!;
                int done = photos.where((p) => p.status != PhotoStatus.unorganized).length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("$done/${photos.length} done", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    _buildPhotoGrid(photos),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, GalleryViewMode mode) {
    bool isSelected = _currentMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _currentMode = mode),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(List<PhotoItem> photos) {
    // Show smaller thumbnails for Month/Year views
    int count = (_currentMode == GalleryViewMode.day) ? 4 : 6;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) => _buildPhotoTile(photos[index]),
    );
  }

  Widget _buildPhotoTile(PhotoItem photo) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotoViewerScreen(asset: photo.asset))
      ),
      child: Hero(
        tag: photo.asset.id,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AssetEntityImage(
                photo.asset,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(200),
                fit: BoxFit.cover,
              ),
            ),
            // Status icons
            if (photo.status != PhotoStatus.unorganized)
              Container(
                color: Colors.black26,
                child: Center(
                  child: Icon(
                    photo.status == PhotoStatus.delete ? Icons.delete_outline : Icons.favorite,
                    color: photo.status == PhotoStatus.delete ? Colors.redAccent : Colors.greenAccent,
                    size: (_currentMode == GalleryViewMode.day) ? 20 : 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}