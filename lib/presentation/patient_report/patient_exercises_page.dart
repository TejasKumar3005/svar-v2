import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';

class PatientExercisesPage extends StatefulWidget {
  const PatientExercisesPage({Key? key}) : super(key: key);

  @override
  _PatientExercisesPageState createState() => _PatientExercisesPageState();

  static Widget builder(BuildContext context) {
    return const PatientExercisesPage();
  }
}

class _PatientExercisesPageState extends State<PatientExercisesPage>
    with SingleTickerProviderStateMixin {
  late String uid;
  bool isLoading = true;
  List<Map<String, dynamic>> allExercises =
      []; // All available exercises by date
  Set<String> expandedDates = {}; // Track which dates are expanded
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _fetchExerciseData().then((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchExerciseData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference patientRef =
          firestore.collection('patients').doc(uid);
      final DocumentSnapshot patientDoc = await patientRef.get();

      if (patientDoc.exists) {
        final data = patientDoc.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('exercises')) {
          if (data['exercises'] is Map<String, dynamic>) {
            final exerciseData = data['exercises'] as Map<String, dynamic>;
            final exercises = <Map<String, dynamic>>[];

            exerciseData.forEach((date, exerciseContent) {
              if (exerciseContent is List) {
                final filteredExercises = exerciseContent
                    .where((exercise) =>
                        exercise is Map &&
                        exercise.containsKey('performance') &&
                        (exercise['performance'] as List).isNotEmpty)
                    .toList();

                if (filteredExercises.isNotEmpty) {
                  exercises.add({
                    'date': date,
                    'exercises': filteredExercises,
                  });
                }
              }
            });

            // Sort dates in descending order (latest first)
            exercises.sort((a, b) => b['date'].compareTo(a['date']));

            setState(() {
              allExercises = exercises;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = 'No exercise data found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'No patient data found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading exercises: $e';
        isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);

        final date = DateTime(year, month, day);
        return DateFormat('MMMM d, yyyy').format(date);
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  void _toggleExpanded(String date) {
    setState(() {
      if (expandedDates.contains(date)) {
        expandedDates.remove(date);
      } else {
        expandedDates.clear();
        expandedDates.add(date);
      }
    });
  }

  Widget _buildExerciseDetails(Map<String, dynamic> exercise) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise['description'] ?? 'Unnamed Exercise',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (exercise['type'] != null)
                  _buildChip(
                    'Type: ${exercise['type']}',
                    AppTheme.primaryColor,
                  ),
                if (exercise['subtype'] != null)
                  _buildChip(
                    'Subtype: ${exercise['subtype']}',
                    AppTheme.basicInfoColor,
                  ),
              ],
            ),
            if (exercise['description'] != null) ...[
              const SizedBox(height: 12),
              Text(
                exercise['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            if (exercise['performance'] != null) ...[
              const SizedBox(height: 16),
              _buildPerformanceDetails(exercise),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPerformanceDetails(Map<String, dynamic> exercise) {
    if (exercise['performance'] == null || (exercise['performance'] as List).isEmpty) {
      return Text(
        'No performance data available',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...(exercise['performance'] as List).asMap().entries.map((entry) {
          final attemptIdx = entry.key;
          final attempt = entry.value;

          if (exercise['subtype'] == 'Pronunciation') {
            return Column(
              children: (attempt['result'] as List).asMap().entries.map((resultEntry) {
                final index = resultEntry.key;
                final resultItem = resultEntry.value;
                
                bool isCorrect = false;
                String feedback = '';

                if (resultItem is Map) {
                  feedback = resultItem.values.first.toString();
                  isCorrect = feedback.toLowerCase().contains('correctly');
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feedback,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                            ),
                            if (isCorrect)
                              Text(
                                'Great job!',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green.shade700,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.error,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            final isCorrect = attempt['correct_attempt'] as bool;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        '${attemptIdx + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCorrect ? 'Correctly completed' : 'Incorrectly completed',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                        Text(
                          'Time: ${attempt['time']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        if (isCorrect)
                          Text(
                            'Great job!',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.green.shade700,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.error,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ],
              ),
            );
          }
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 70,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchExerciseData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        color: AppTheme.primaryColor,
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Exercise History',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'View your completed exercises and performance history',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ...allExercises.map((dateExercises) {
                            final date = dateExercises['date'];
                            final exercises =
                                dateExercises['exercises'] as List;
                            final isExpanded = expandedDates.contains(date);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 0,
                              color: const Color(0xFFF5F8F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () => _toggleExpanded(date),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _formatDate(date),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                              AnimatedRotation(
                                                turns: isExpanded ? 0.5 : 0.0,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.easeInOutCubic,
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${exercises.length} exercise${exercises.length != 1 ? 's' : ''} completed',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: isExpanded
                                        ? Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: exercises
                                                  .map<Widget>((exercise) =>
                                                      _buildExerciseDetails(
                                                          exercise))
                                                  .toList(),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
