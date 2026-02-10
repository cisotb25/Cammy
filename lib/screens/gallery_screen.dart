import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'; // ADD THIS IMPORT
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import '../models/photo_item.dart';
import 'package:intl/intl.dart';

class GalleryScreen extends StatelessWidget {
  final Map<DateTime, List<PhotoItem>> groupedPhotos;

  const GalleryScreen({super.key, required this.groupedPhotos});

  @override
  Widget build(BuildContext context) {
    var sortedDates = groupedPhotos.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          DateTime date = sortedDates[index];
          List<PhotoItem> photos = groupedPhotos[date]!;

          int doneCount = photos.where((p) => p.status != PhotoStatus.unorganized).toList().length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // FIXED: was .between
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
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AssetEntityImage(
                          photo.asset,
                          isOriginal: false,
                          thumbnailSize: const ThumbnailSize.square(200), // FIXED: Now it knows what this is
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),

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