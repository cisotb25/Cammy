import 'package:flutter/material.dart';
import '../models/photo_item.dart'; // Import the model
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
  int _currentIndex = 2;

  // --- THE STATE ---
  // This is the "Brain" of the app for now.
  final List<PhotoItem> _trashList = [];

  // Dummy data for Home Screen
  final List<PhotoItem> _deck = [
    PhotoItem(id: '1', color: Colors.red),
    PhotoItem(id: '2', color: Colors.blue),
    PhotoItem(id: '3', color: Colors.green),
  ];

  // --- ACTIONS ---
  void _onSwipeLeft(PhotoItem item) {
    setState(() {
      _trashList.add(item); // Add to trash
    });
    print("Trash now has ${_trashList.length} items");
  }

  void _onFeedTrashy() {
    setState(() {
      _trashList.clear(); // Empty the trash!
    });
    // Show a snackbar or popup here later for "YUM!"
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("BURP! Trashy is full.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We recreate the list of screens every build to pass the updated data
    final List<Widget> screens = [
      TrashScreen(
          trashItems: _trashList,
          onFeedTrashy: _onFeedTrashy
      ),
      const GalleryScreen(),
      HomeScreen(
          deck: _deck,
          onSwipeLeft: _onSwipeLeft
      ),
      const StatsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex], // Display current screen
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