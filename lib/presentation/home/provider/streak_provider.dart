import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StreakProvider extends ChangeNotifier {
  int _streakCount = 0;
  String _patientName = "";
  String _therapistName = "";
  Map<int, bool> _weeklyStreak = {};
  bool _isLoading = true;

  // Additional user data fields
  String _patientEmail = "";
  String _patientPhone = "";
  String _patientProfileImage = "";
  String _therapistEmail = "";
  String _therapistPhone = "";
  String _therapistProfileImage = "";
  String _motherName = "";
  String _fatherName = "";
  String _address = "";
  String _age = "" ; 

  // Getters for all properties
  int get streakCount => _streakCount;
  String get patientName => _patientName;
  String get therapistName => _therapistName;
  Map<int, bool> get weeklyStreak => _weeklyStreak;
  bool get isLoading => _isLoading;
  String get patientEmail => _patientEmail;
  String get patientPhone => _patientPhone;
  String get patientProfileImage => _patientProfileImage;
  String get therapistEmail => _therapistEmail;
  String get therapistPhone => _therapistPhone;
  String get therapistProfileImage => _therapistProfileImage;
  String get motherName => _motherName;
  String get fatherName => _fatherName;
  String get address => _address;
  String get age => _age;  
  // Initialize the streak data
  Future<void> initializeStreakData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _fetchUserData();
      await _calculateStreak();
    } catch (e) {
      print('Error initializing streak data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _patientName = userData['name'] ?? "no Name";
        _patientEmail = userData['email'] ?? " no  Email";
        _patientPhone = userData['parentPhone'] ?? " no phone number";
        _patientProfileImage = userData['profileImage'] ?? " no profile image";
        
        _motherName = userData['mothersName']?? "no name";
        _fatherName = userData['fathersName']?? "no name";
        _address = userData['address']?? " no address";
        _age = userData['age']?? " no age"; 

        print(userData['age']);

        // Get therapist information if available
        if (userData['therapist'] != null && userData['therapist'].isNotEmpty) {
          String therapistId = userData['therapist'][0];
          await _fetchTherapistData(therapistId);
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Fetch therapist data
  Future<void> _fetchTherapistData(String therapistId) async {
    try {
      DocumentSnapshot therapistDoc = await FirebaseFirestore.instance
          .collection('therapists')
          .doc(therapistId)
          .get();

      if (therapistDoc.exists) {
        Map<String, dynamic> therapistData =
            therapistDoc.data() as Map<String, dynamic>;
        _therapistName = therapistData['name'] ?? "";
        _therapistEmail = therapistData['email'] ?? "";
        _therapistPhone = therapistData['phone'] ?? "";
        _therapistProfileImage = therapistData['profileImage'] ?? "";
      }
    } catch (e) {
      print('Error fetching therapist data: $e');
    }
  }

  // Calculate streak based on exercise completion
  Future<void> _calculateStreak() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> exercises = userData['exercises'] ?? {};

        // Initialize weekly streak map (0 = Monday, 6 = Sunday)
        _weeklyStreak = {};
        for (int i = 0; i < 7; i++) {
          _weeklyStreak[i] = false;
        }

        // Get current date and calculate dates for the current week
        DateTime now = DateTime.now();
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

        // Calculate streak count
        int streak = 0;
        DateTime currentDate = now;
        bool streakBroken = false;

        // Check up to 30 days back for continuous streak
        for (int i = 0; i < 30 && !streakBroken; i++) {
          String dateKey = DateFormat('yyyy-MM-dd').format(currentDate);
          bool hasCompletedExercise = false;

          // Check if there are exercises for this date
          if (exercises.containsKey(dateKey)) {
            List<dynamic> dailyExercises = exercises[dateKey];

            // Check if any exercise was completed
            for (var exercise in dailyExercises) {
              if (exercise is Map && exercise['completedAt'] != null) {
                hasCompletedExercise = true;
                break;
              }
            }
          }

          // Update streak count
          if (hasCompletedExercise || currentDate.isAfter(now)) {
            // Count today and future dates as part of streak
            if (currentDate.difference(now).inDays <= 0) {
              streak++;
            }

            // Update weekly streak map for current week
            int daysSinceStartOfWeek =
                currentDate.difference(startOfWeek).inDays;
            if (daysSinceStartOfWeek >= 0 && daysSinceStartOfWeek < 7) {
              _weeklyStreak[currentDate.weekday - 1] = hasCompletedExercise;
            }
          } else {
            // Break streak if a day was missed
            streakBroken = true;
          }

          // Move to previous day
          currentDate = currentDate.subtract(Duration(days: 1));
        }

        _streakCount = streak;
      }
    } catch (e) {
      print('Error calculating streak: $e');
    }
  }

  // Get user details as a map
  Map<String, dynamic> getPatientDetails() {
    return {
      'name': _patientName,
      'email': _patientEmail,
      'phone': _patientPhone,
      'profileImage': _patientProfileImage,
      'motherName': _motherName,
      'fatherName': _fatherName,
      'address': _address,
      'age': _age,
    };
  }

  // Get therapist details as a map
  Map<String, dynamic> getTherapistDetails() {
    return {
      'name': _therapistName,
      'email': _therapistEmail,
      'phone': _therapistPhone,
      'profileImage': _therapistProfileImage,
    };
  }

  // Manually update streak (e.g., after exercise completion)
  Future<void> updateStreak() async {
    await _calculateStreak();
    notifyListeners();
  }
}
