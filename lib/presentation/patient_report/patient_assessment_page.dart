import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'complete_report_view.dart';


class PatientAssessmentPage extends StatefulWidget {
  const PatientAssessmentPage({Key? key}) : super(key: key);

  @override
  _PatientAssessmentPageState createState() => _PatientAssessmentPageState();

  static Widget builder(BuildContext context) {
    return const PatientAssessmentPage();
  }
}

class _PatientAssessmentPageState extends State<PatientAssessmentPage> with SingleTickerProviderStateMixin {
  late String uid;
  bool isLoading = true;
  Map<String, dynamic>? reportData; // Currently displayed report
  List<Map<String, dynamic>> allReports = []; // All available reports
  List<String> reportDates = []; // List of available dates for dropdown
  String selectedDate = ''; // Currently selected date
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentIndex = 2;


 

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
    _fetchReportData().then((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  Future<void> _fetchReportData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Connect to Firestore and fetch patient data
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference patientRef =
          firestore.collection('patients').doc(uid);
      final DocumentSnapshot patientDoc = await patientRef.get();
      
      if (patientDoc.exists) {
        final data = patientDoc.data() as Map<String, dynamic>?;

        // Check if 'assessment' field exists and is a map
        if (data != null && data.containsKey('assessment')) {
          // Check if it's a map of dates to assessments
          if (data['assessment'] is Map<String, dynamic>) {
            final assessmentData = data['assessment'] as Map<String, dynamic>;

            // Convert to list of reports with dates
            final reports = <Map<String, dynamic>>[];
            final dates = <String>[];

            assessmentData.forEach((date, reportContent) {
              if (reportContent is Map<String, dynamic>) {
                reports.add({
                  'date': date,
                  ...reportContent,
                });
                dates.add(date);
              }
            });

            // Sort dates in descending order (latest first)
            dates.sort((a, b) => b.compareTo(a));
            reports.sort((a, b) => b['date'].compareTo(a['date']));
            
            setState(() {
              allReports = reports;
              reportDates = dates;

              // Set default selected date to the most recent one
              if (dates.isNotEmpty) {
                selectedDate = dates.first;
                // Set the reportData to the report of selected date
                reportData = reports.firstWhere(
                    (report) => report['date'] == selectedDate,
                    orElse: () => {});
              }

              isLoading = false;
            });
          } else {
            // Handle case where assessment is a single report (not date-based)
            setState(() {
              reportData = data['assessment'] as Map<String, dynamic>? ?? {};
              allReports = [reportData!];
              reportDates = ['Current'];
              selectedDate = 'Current';
              isLoading = false;
            });
          }
        } else {
          setState(() {
            errorMessage = 'No assessment data found.';
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
        errorMessage = 'Error loading report: $e';
        isLoading = false;
      });
    }
  }

  void _onDateChanged(String? newDate) {
    if (newDate != null && newDate != selectedDate) {
      setState(() {
        selectedDate = newDate;
        reportData = allReports.firstWhere(
          (report) => report['date'] == selectedDate,
          orElse: () => {},
        );
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

    // This function handles index changes from the bottom navigation bar
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assessment Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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
                        onPressed: _fetchReportData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Report date selector
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12, 
                          vertical: 12
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Report Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.teal.shade200,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedDate,
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.teal.shade700,
                                    ),
                                    items: reportDates.map((date) {
                                      return DropdownMenuItem<String>(
                                        value: date,
                                        child: Text(_formatDate(date)),
                                      );
                                    }).toList(),
                                    onChanged: _onDateChanged,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Complete continuous report
                      Expanded(
                        child: reportData != null
                            ? CompleteReportView(reportData: reportData!)
                            : const Center(
                                child: Text('No report data available'),
                              ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
}

