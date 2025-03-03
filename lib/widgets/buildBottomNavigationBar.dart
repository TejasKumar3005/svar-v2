// lib/widgets/custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Import your app routes

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  // Badge icon builder
  Widget _buildBadgeIcon(IconData icon, bool hasBadge) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (hasBadge)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 10,
                minHeight: 10,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Update the current index in the parent
          onIndexChanged(index);
          
          // Handle navigation based on the selected tab
          if (index == 4) {
            // Navigate to Profile screen when Profile tab is clicked
            Navigator.of(context).pushNamed(AppRoutes.userProfileScreen);
          } else if (index == 0) {
            // If Today tab is clicked and we're not already on the home screen
            if (currentIndex != 0) {
              // Navigate back to this screen (Home/Today screen)
              Navigator.of(context).pushNamed(AppRoutes.home);
            }
          }
          // Add navigation for other tabs as needed
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.wb_sunny, false),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.bar_chart, true),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.calendar_today, false),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.attach_money, false),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: _buildBadgeIcon(Icons.person, false),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}