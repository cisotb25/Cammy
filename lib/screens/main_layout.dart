import 'package:flutter/material.dart';
import '../models/photo_item.dart';
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
  int _currentIndex = 2; // Start at Home

  // --- 1. The Titles for each screen (Based on your Mockup) ---
  final List<String> _titles = [
    "TRASHY",   // 0
    "GALLERY",  // 1
    "CAMMY",    // 2
    "FLASHY",   // 3
    "PROFILE",  // 4
  ];

  // --- STATE ---
  List<PhotoItem> _trashList = [];

  // --- ACTIONS ---
  void _addToTrash(PhotoItem item) {
    setState(() {
      _trashList.add(item);
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      TrashScreen(trashItems: _trashList, onFeedTrashy: _emptyTrash),
      const GalleryScreen(),
      HomeScreen(
        // Assuming you updated HomeScreen to accept deck/onSwipeLeft
          deck: [
            PhotoItem(id: '1', color: Colors.red),
            PhotoItem(id: '2', color: Colors.blue),
            PhotoItem(id: '3', color: Colors.green),
          ],
          onSwipeLeft: _addToTrash
      ),
      const StatsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      // --- 2. HERE IS THE MISSING APP BAR! ---
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex], // Changes based on the tab!
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Flat style like mockup
        actions: [
          // The Settings Icon
          IconButton(
            onPressed: () {
              // We can add settings logic later
              debugPrint("Settings Clicked");
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),

      body: screens[_currentIndex],

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