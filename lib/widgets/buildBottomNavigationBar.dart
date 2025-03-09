// lib/widgets/custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart'; // Import your ProfilePage
import 'package:svar_new/presentation/home/home.dart';
import 'package:svar_new/presentation/exercises/patient_assessment.dart'; // Import your HomePage

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
          // First check if the widget is still mounted before updating state
          // This prevents the "setState() called after dispose()" error

          // Handle navigation based on the selected tab
          if (index == 4 && currentIndex != 4) {
            // Navigate to Profile screen when Profile tab is clicked
            Navigator.of(context)
                .pushReplacement(
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            )
                .then((_) {
              // Only update state if still mounted
              if (context.mounted) {
                onIndexChanged(index);
              }
            });
          } else if (index == 2 && currentIndex != 2) {
            // Navigate to Calendar screen (PatientAssessmentPage) when Calendar tab is clicked
            // Only navigate if we're not already on the Calendar tab
            Navigator.of(context)
                .pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const PatientAssessmentPage(
                      reportId: 'reportId', reportType: 'case_history')),
            )
                .then((_) {
              // Only update state if still mounted
              if (context.mounted) {
                onIndexChanged(index);
              }
            });
          } else if (index == 0 && currentIndex != 0) {
            // Navigate to HomePage when Today tab is clicked
            Navigator.of(context)
                .pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            )
                .then((_) {
              // Only update state if still mounted
              if (context.mounted) {
                onIndexChanged(index);
              }
            });
          } else {
            // For tabs without navigation or when already on the selected tab
            // Update the index directly
            onIndexChanged(index);
          }
          // Add navigation for other tabs as needed
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00A3A3),
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        elevation: 8,
        selectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12),
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
