import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/patient_report/patient_assessment_page.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/widgets/fees_page.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'provider/main_interaction_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:svar_new/presentation/home/provider/streak_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainInteractionProvider(),
      child: HomeScreen(),
    );
  }
}

// HomeScreenState   State<HomeScreen>

class HomeScreenState extends State<HomeScreen> {
  // Remove the constant constructor as it's not needed in a State class
  // State objects are created by the framework, not directly instantiated

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speech Therapy App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily:
            'Nunito', // Rounded friendly sans-serif font similar to Duolingo
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
          headlineMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          bodyLarge: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _currentIndex = 0; // Default to Today tab

  // This function handles index changes from the bottom navigation bar
  void _onIndexChanged(int index) {
    print("Index changed to: $index");

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentIndex = index;
      });
    });

    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
  }

  late TabController _tabController;

  // Achievement badges
  final List<Map<String, dynamic>> _achievements = [
    {'icon': Icons.emoji_events, 'color': Colors.amber},
    {'icon': Icons.star, 'color': Colors.purpleAccent},
    {'icon': Icons.favorite, 'color': Colors.redAccent},
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    print("HomeScreenState initState called");
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Register as an observer to detect app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize streak provider data
      Provider.of<StreakProvider>(context, listen: false)
          .initializeStreakData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only request focus if the widget is mounted and the focus node is not disposed

    return Scaffold(
      backgroundColor: const Color(0xFFF9F2EF),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              // Setting bottom to a value that allows space for the active part of the navigation bar

              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          _buildStreakSection(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.teal.shade400,
                                    Colors.teal.shade700
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  print("hello");
                                  await NavigatorService.pushNamed(
                                      AppRoutes.exercisesScreen);
                                  print("/////////////////////////////n");
                                  // Don't call initState() directly
                                  // Instead, refresh data if the widget is still mounted
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  minimumSize: Size(double.infinity, 60),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.yellow,
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Continue Today\'s Exercise',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.yellow,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _buildUpcomingSessions(),
                          _buildProgressSnapshot(),
                        ],
                      ),
                    ),
                  ),

                  PatientAssessmentPage(),
                  FeesPage(), // Placeholder for the third tab
                  UserProfileScreen(),
                  SizedBox(
                    height: 20,
                    width: 30,
                  )
                ][_currentIndex],
              )),
          Positioned(
          
            bottom: 0,
        
            child: CustomBottomNavigationBar(
              currentIndex: _currentIndex,
              onIndexChanged: _onIndexChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        // Get greeting based on time of day
        final hour = DateTime.now().hour;
        String greeting = 'Good Evening';
        if (hour < 12) {
          greeting = 'Good Morning';
        } else if (hour < 17) {
          greeting = 'Good Afternoon';
        }

        // Get motivational message based on streak count
        String motivationalMessage = 'Keep going with your exercises!';
        if (streakProvider.streakCount >= 7) {
          motivationalMessage =
              'Amazing consistency! You\'re making great progress!';
        } else if (streakProvider.streakCount >= 3) {
          motivationalMessage = 'You\'re building a great habit! Keep it up!';
        } else if (streakProvider.streakCount >= 1) {
          motivationalMessage = 'Great start! Let\'s keep the momentum going!';
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '👋',
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            "${streakProvider.patientName}'s streak: ${streakProvider.streakCount} days!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.local_fire_department,
                              color: Colors.orange),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        motivationalMessage,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreakSection() {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        // If the data is still loading, show a loading indicator
        if (streakProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the weekday names
        final _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

        // Get today's weekday (0 = Monday, 6 = Sunday)
        final today = DateTime.now().weekday - 1;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Weekly Streak',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        '${streakProvider.streakCount} days',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  // Get completion status from the provider
                  bool isCompleted =
                      streakProvider.weeklyStreak[index] ?? false;
                  bool isToday = index == today;

                  return Column(
                    children: [
                      Text(
                        _weekdays[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? Colors.green
                              : isToday
                                  ? Colors.purple
                                  : Colors.transparent,
                          border: Border.all(
                            color: isCompleted || isToday
                                ? Colors.transparent
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 20)
                              : isToday
                                  ? Icon(Icons.play_arrow,
                                      color: Colors.white, size: 20)
                                  : null,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  // Now, update the _buildUpcomingSessions method in the HomePage class
  Widget _buildUpcomingSessions() {
    return Consumer<StreakProvider>(
      builder: (context, streakProvider, child) {
        // Show loading indicator while fetching data
        if (streakProvider.isLoading) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }

        // If no upcoming sessions, show a message
        if (streakProvider.upcomingSessions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No upcoming sessions scheduled',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Display all upcoming sessions
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Sessions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ...streakProvider.upcomingSessions.map((session) {
                // Get therapist initials for avatar
                String therapistInitials = session['therapist']
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join('')
                    .toUpperCase();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Session',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  session['location'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            session['date'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            session['timeRange'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.redAccent.shade100,
                                child: Text(
                                  therapistInitials,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                session['therapist'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(color: Colors.teal),
                                ),
                                child: Text('DETAILS'),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('RESCHEDULE'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSnapshot() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Snapshot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 16,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: _achievements.map((achievement) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: achievement['color'].withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              achievement['icon'],
                              color: achievement['color'],
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bar_chart,
                      size: 16,
                      color: Colors.teal,
                    ),
                    label: Text(
                      'View Full Report',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
