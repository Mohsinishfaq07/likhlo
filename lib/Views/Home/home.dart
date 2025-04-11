import 'package:flutter/material.dart';
import 'package:likhlo/Views/Data/Dashboard/Dashboard.dart';
import 'package:likhlo/Views/Data/Dashboard/InventoryDashboard.dart';
import 'package:likhlo/Views/Data/Dashboard/SuppDashboard.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0; // Index for the selected tab
  final PageController _pageController = PageController();

  // List of screens to show in bottom navigation
  final List<Widget> _screens = [
    DashboardScreen(), // Customers Screen
    SupplierDashboardScreen(),
    InventoryDashboardScreen(),
    const PlaceholderScreen(title: 'Profile'), // Profile Screen
  ];

  // Function to handle navigation on bottom nav tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Jump to the selected page
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose the PageController when the screen is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens, // List of screens
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue, // BottomNav background color
        selectedItemColor: Colors.blue, // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ), // Bold text for selected item
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Suppliers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen (Placeholder)',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
