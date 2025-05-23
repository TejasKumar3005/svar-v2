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

  List<Map<String, dynamic>> _upcomingSessions = [];
  List<Map<String, dynamic>> get upcomingSessions => _upcomingSessions;
  Map<String,Map<String,dynamic>> _exercises = {};
  Map<String,Map<String,dynamic>> get exercises => _exercises;

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
      await fetchUpcomingSessions();
    } catch (e) {
      print('Error initializing streak data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add this method to the StreakProvider class
  Future<void> fetchUpcomingSessions() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
        // Get the time slots array
        List<dynamic> timeSlots = userData['timeSlots'] ?? [];
        
        // Get therapist name
        String therapistName = userData['therapistName'] ?? "No Therapist";
        
        // Parse time slots into readable format
        _upcomingSessions = [];
        
        for (String slot in timeSlots) {
          // Parse the time slot format: "S-7A-8A-17-3" means session from 7AM to 8AM on March 17
          List<String> parts = slot.split('-');
          
          if (parts.length >= 5) {
            // Extract time and date information
            String startTime = _formatTimeSlot(parts[1]);
            String endTime = _formatTimeSlot(parts[2]);
            
            // Get day and month
            int day = int.tryParse(parts[3]) ?? 1;
            int month = int.tryParse(parts[4]) ?? 1;
            int year = DateTime.now().year;
            
            // Create session date
            DateTime sessionDate = DateTime(year, month, day);
            
            // Only include future sessions
            if (sessionDate.isAfter(DateTime.now()) || 
                (sessionDate.day == DateTime.now().day && 
                 sessionDate.month == DateTime.now().month &&
                 sessionDate.year == DateTime.now().year)) {
              
              _upcomingSessions.add({
                'date': '${_getMonthName(month)} $day, $year',
                'timeRange': '$startTime - $endTime',
                'therapist': therapistName,
                'location': 'Virtual',  // Assuming virtual by default
              });
            }
          }
        }
        
        // Sort by date (closest first)
        _upcomingSessions.sort((a, b) {
          DateTime dateA = _parseDate(a['date']);
          DateTime dateB = _parseDate(b['date']);
          return dateA.compareTo(dateB);
        });
        
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching upcoming sessions: $e');
    }
  }
  
  // Helper method to parse date string
  DateTime _parseDate(String dateStr) {
    try {
      List<String> parts = dateStr.split(' ');
      String month = parts[0];
      int day = int.parse(parts[1].replaceAll(',', ''));
      int year = int.parse(parts[2]);
      
      return DateTime(year, _getMonthNumber(month), day);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  // Helper method to format time slot (convert 7A to 7:00 AM)
  String _formatTimeSlot(String timeSlot) {
    bool isAM = timeSlot.contains('A');
    String timeValue = timeSlot.replaceAll('A', '').replaceAll('P', '');
    
    if (timeValue.length == 1) {
      return '$timeValue:00 ${isAM ? 'AM' : 'PM'}';
    } else {
      return '${timeValue.substring(0, timeValue.length - 2)}:${timeValue.substring(timeValue.length - 2)} ${isAM ? 'AM' : 'PM'}';
    }
  }
  
  // Helper method to get month name
  String _getMonthName(int month) {
    List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  // Helper method to get month number from name
  int _getMonthNumber(String monthName) {
    Map<String, int> months = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12
    };
    return months[monthName] ?? 1;
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      print("uid is $uid");
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
        Map<String,Map<String,dynamic>> exes = {};
          for(var date in userData['exercises'].keys){
            exes[date] = {
              "total":userData['exercises'][date].length,
              "completed":userData['exercises'][date].where((exercise) => exercise['completedAt'] != null).length,

            };
          }
        _exercises = exes;

      print(_exercises);

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
      'mothersName': _motherName,
      'fathersName': _fatherName,
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
