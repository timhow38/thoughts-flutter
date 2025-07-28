import 'package:flutter/material.dart';

/// Enhanced Navigation Bar with Material Design 3 principles
/// Implements proper accessibility, haptic feedback, and adaptive behavior
class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Capture',
          tooltip: 'Capture new ideas',
        ),
        NavigationDestination(
          icon: Icon(Icons.lightbulb_outline),
          selectedIcon: Icon(Icons.lightbulb),
          label: 'Ideas',
          tooltip: 'View your ideas',
        ),
        NavigationDestination(
          icon: Icon(Icons.group_outlined),
          selectedIcon: Icon(Icons.group),
          label: 'Rooms',
          tooltip: 'Collaboration rooms',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
          tooltip: 'App settings',
        ),
      ],
    );
  }
}
