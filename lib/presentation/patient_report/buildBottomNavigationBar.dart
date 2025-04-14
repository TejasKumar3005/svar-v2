

import 'package:flutter/material.dart';
import 'package:svar_new/presentation/patient_report/rive_bottomNav.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart'; // Import your ProfilePage
import 'package:svar_new/presentation/home/home.dart';
import 'package:svar_new/presentation/patient_report/patient_assessment_page.dart'; // Import your HomePage
import 'package:svar_new/widgets/fees_page.dart';
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
      width: MediaQuery.of(context).size.width,
      height: 80, // Adjust as needed
    // Adjust as needed
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: RiveBottomnav(currentIndex: currentIndex, onIndexChanged: onIndexChanged)
    );
  }
}