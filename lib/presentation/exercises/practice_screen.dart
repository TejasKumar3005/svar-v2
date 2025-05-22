import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/home/provider/streak_provider.dart';
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {

  @override
  void initState() {
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<StreakProvider>(
            builder: (context, streakProvider, child) {
              return Column(
                children: [
                  // Top section with fox and greeting
                  Container(
                    padding: EdgeInsets.all(20).copyWith(bottom: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1cb0f6), // Exact blue color from image
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                        
                          children: [
                                                  
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/img_mascot.png',
                                  height: 220,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        'Hey ${streakProvider.getPatientDetails()["fathersName"]}!',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                       Text(
                                        'Ready to help\n ${streakProvider.patientName} today?',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${streakProvider.streakCount} day streak',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            // Start button
                            
                          ],
                        ),
                        Positioned(
                        top: 170,
                      
                        left: 0,
                        right: 0,
                          child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFff9600),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                      child: Column(
                                        children: [
                                           Text(
                                            'Start Talking with ${streakProvider.patientName}!',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.timer_outlined,
                                                  color: Colors.white, size: 16),
                                              const SizedBox(width: 4),
                                              const Text(
                                                '10 min',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(Icons.star,
                                                  color: Colors.white, size: 16),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Earn 10 XP',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
              
                  const SizedBox(height: 24),
                        
                  // Progress section
                  Container(
                    margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFafafaf)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2196F3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '2/4',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Text(
                                      'Sessions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Today's Practice:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      '20 mins',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                               Text(
                                  '${streakProvider.streakCount} days in a row!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                          
                      ],
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildStreakSection(),
              ),
                      
                              
                        // Focus Sound button
                      
                        const SizedBox(height: 16),
                              
                        
                      
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildUpcomingSessions(),
                        ),
      
                        SizedBox(height: 50),
                ],
              );
            }
          ),
        ),
      ),
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

        return Container(
          
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFafafaf)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
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
                      'Your Weekly Streak',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Color(0xFF4b4b4b),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          '${streakProvider.streakCount} days',
                          style: GoogleFonts.inter(
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
                    bool isPast = index < today;
                
          
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
                                ? Colors.teal.shade600
                                : isToday
                                    ? Colors.purple
                                    : isPast
                                        ? Colors.red
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
                                    : isPast
                                        ? Icon(Icons.close,
                                            color: Colors.white, size: 20)
                                        : Container(),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
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
          return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFafafaf)),
          
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
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
                Center(
                  child: Text(
                    'No upcoming sessions scheduled',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Display all upcoming sessions
        return Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xFFafafaf)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Padding(
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
          ),
        );
      },
    );
  }


}

