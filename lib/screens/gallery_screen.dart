import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../models/photo_item.dart';
import 'package:intl/intl.dart'; // Add 'intl: ^0.19.0' to pubspec.yaml for date formatting

class GalleryScreen extends StatelessWidget {
  final Map<DateTime, List<PhotoItem>> groupedPhotos;

  const GalleryScreen({super.key, required this.groupedPhotos});

  @override
  Widget build(BuildContext context) {
    // Sort dates so the most recent days are at the top
    var sortedDates = groupedPhotos.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          DateTime date = sortedDates[index];
          List<PhotoItem> photos = groupedPhotos[date]!;

          // Calculate progress for the header (e.g., "2/8 photos done")
          int doneCount = photos.where((p) => p.status != PhotoStatus.unorganized).toList().length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- DAY HEADER ---
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      DateFormat('MMMM dd, yyyy').format(date),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "$doneCount/${photos.length} photos done",
                      style: TextStyle(color: Colors.grey[600]),
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
                  crossAxisCount: 4, // 4 photos per row
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, photoIndex) {
                  final photo = photos[photoIndex];
                  return Stack(
                    children: [
                      // The Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AssetEntityImage(
                          photo.asset,
                          isOriginal: false,
                          thumbnailSize: const ThumbnailSize.square(200),
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
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}