import 'package:flutter/material.dart';
import '../models/photo_item.dart';
import '../services/photo_service.dart';
import 'home_screen.dart';
import 'trash_screen.dart';
import 'gallery_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 2; // Start at Home (Cammy)

  // --- 1. Titles for the AppBar ---
  final List<String> _titles = [
    "TRASHY",
    "GALLERY",
    "CAMMY",
    "FLASHY",
    "PROFILE",
  ];

  // --- 2. State for Photos ---
  List<PhotoItem> _deck = [];
  List<PhotoItem> _trashList = [];
  bool _isLoading = true;

  // --- 3. State for Flashy's Stats ---
  int _totalOrganized = 1067;
  int _todayCount = 0;
  int _totalDeleted = 421;
  int _todayTrash = 0;
  int _streak = 66;

  @override
  void initState() {
    super.initState();
    _loadRealPhotos(); // Fetch photos from Samsung gallery on startup
  }

  Future<void> _loadRealPhotos() async {
    setState(() => _isLoading = true); // Show spinner

    try {
      print("LAYOUT: Calling PhotoService...");
      final assets = await PhotoService.getRecentPhotos();

      setState(() {
        _deck = assets.map((asset) => PhotoItem(id: asset.id, asset: asset)).toList();
        _isLoading = false;
        print("LAYOUT: Loaded ${_deck.length} photos into deck.");
      });
    } catch (e) {
      print("LAYOUT: Error: $e");
      setState(() => _isLoading = false);
    }
  }


  // --- 4. Logic for Swiping ---
  void _handleSwipe(bool isDelete, PhotoItem item) {
    setState(() {
      _totalOrganized++;
      _todayCount++;

      if (isDelete) {
        item.status = PhotoStatus.delete; // NEW: Update the item itself
        _trashList.add(item);
        _todayTrash++;
        _totalDeleted++;
      } else {
        item.status = PhotoStatus.keep;   // NEW: Update the item itself
      }

      if (_todayCount == 1) {
        _streak++;
      }
    });
  }

  void _emptyTrash() {
    setState(() {
      _trashList.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("BURP! Trashy is full.")),
    );
  }

  // Groups the deck by date for the Gallery
  Map<DateTime, List<PhotoItem>> get groupedPhotos {
    Map<DateTime, List<PhotoItem>> groups = {};
    for (var photo in _deck) {
      // We normalize the date to just Year-Month-Day so photos from the
      // same day group together regardless of the hour.
      DateTime date = DateTime(photo.date.year, photo.date.month, photo.date.day);
      if (!groups.containsKey(date)) {
        groups[date] = [];
      }
      groups[date]!.add(photo);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    // Define the screens inside build so they update when the state changes
    final List<Widget> screens = [
      TrashScreen(trashItems: _trashList, onFeedTrashy: _emptyTrash),
      GalleryScreen(groupedPhotos: groupedPhotos),

      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : HomeScreen(
        deck: _deck,
        onSwipeLeft: (item) => _handleSwipe(true, item),
        onSwipeRight: (item) => _handleSwipe(false, item),
      ),
      StatsScreen(
        streakCount: _streak,
        totalPhotos: _totalOrganized,
        todayPhotos: _todayCount,
        deletedPhotos: _totalDeleted,
        todayTrash: _todayTrash,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _loadRealPhotos(), // Call your load function again!
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: IndexedStack( // IndexedStack preserves the state of tabs when switching
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.delete_outline), label: "Trash"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Gallery"),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Stats"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

