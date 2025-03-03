import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:flutter/services.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;
  final BuildContext context;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.context,
  }) : super(key: key);

  // Helper method to build badge icons
  Widget _buildBadgeIcon(IconData icon, bool hasBadge) {
    if (!hasBadge) {
      return Icon(icon);
    }
    
    return Stack(
      children: [
        Icon(icon),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void _handleNavigation(int index) {
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
        onTap: _handleNavigation,
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
