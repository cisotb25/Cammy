import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../models/photo_item.dart';
import 'photo_viewer_screen.dart'; // Ensure this file exists!
import 'package:intl/intl.dart';

class GalleryScreen extends StatelessWidget {
  final Map<DateTime, List<PhotoItem>> groupedPhotos;

  const GalleryScreen({super.key, required this.groupedPhotos});

  @override
  Widget build(BuildContext context) {
    // 1. Sort the dates so the most recent photos are at the top
    var sortedDates = groupedPhotos.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.white,
      body: sortedDates.isEmpty
          ? const Center(child: Text("No photos organized yet!"))
          : ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          DateTime date = sortedDates[index];
          List<PhotoItem> photos = groupedPhotos[date]!;

          // 2. Calculate progress for the header
          int doneCount = photos.where((p) => p.status != PhotoStatus.unorganized).length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION HEADER (Date & Progress) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM dd, yyyy').format(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "$doneCount/${photos.length} done",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // --- PHOTO GRID FOR THIS DAY ---
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, photoIndex) {
                  final photo = photos[photoIndex];

                  return GestureDetector(
                    onTap: () {
                      // 3. Navigate to Full Screen View
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoViewerScreen(asset: photo.asset),
                        ),
                      );
                    },
                    child: Hero(
                      tag: photo.asset.id, // Enables the "flying" animation
                      child: Stack(
                        children: [
                          // The Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AssetEntityImage(
                              photo.asset,
                              isOriginal: false,
                              thumbnailSize: const ThumbnailSize.square(250),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),

                          // Status Overlay (Red Trash or Green Heart)
                          if (photo.status != PhotoStatus.unorganized)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Icon(
                                  photo.status == PhotoStatus.delete
                                      ? Icons.delete_outline
                                      : Icons.favorite,
                                  color: photo.status == PhotoStatus.delete
                                      ? Colors.redAccent
                                      : Colors.greenAccent,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}