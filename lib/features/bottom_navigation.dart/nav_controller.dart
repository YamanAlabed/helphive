import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/features/bottom_navigation.dart/home.dart';
import 'package:helphive_flutter/features/bottom_navigation.dart/profile.dart';


class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0; // Track the selected index
  // List of widgets to display for each tab
  final List<Widget> _widgetOptions = [
    // ignore: prefer_const_constructors
    const Home(),
    const Profile(),
  ];
  // Method to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth > 400 ? 28.0 : 24.0;

    return Scaffold(
      appBar: AppBar(
         title: const Text(
                'Flutter Version',
              ),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: iconSize,
              height: iconSize,
              child: Icon(Icons.home, size: iconSize),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: iconSize,
              height: iconSize,
              child: Icon(Icons.person, size: iconSize),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorDarkGray,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
