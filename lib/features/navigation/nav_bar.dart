import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline, size: 24),
          selectedIcon: Icon(Icons.add_circle, size: 24),
          label: 'Capture',
        ),
        NavigationDestination(
          icon: Icon(Icons.lightbulb_outline, size: 24),
          selectedIcon: Icon(Icons.lightbulb, size: 24),
          label: 'Ideas',
        ),
        NavigationDestination(
          icon: Icon(Icons.group, size: 24),
          selectedIcon: Icon(Icons.group, size: 24),
          label: 'Rooms',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined, size: 24),
          selectedIcon: Icon(Icons.settings, size: 24),
          label: 'Settings',
        ),
      ],
    );
  }
}
