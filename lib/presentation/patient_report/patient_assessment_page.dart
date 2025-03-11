

import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/presentation/patient_report/app_theme.dart';
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

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Report date selector
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: 16
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppTheme.basicInfoColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Report Date:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showDateSelectionBottomSheet(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedDate.isNotEmpty ? selectedDate : 'Select Date',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.grey.shade700,
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Complete continuous report
                        reportData != null
                            ? CompleteReportView(reportData: reportData!)
                            : const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Center(
                                  child: Text(
                                    'No report data available',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }
  
  void _showDateSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Select Report Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: reportDates.length,
                  itemBuilder: (context, index) {
                    final date = reportDates[index];
                    final isSelected = date == selectedDate;
                    
                    return ListTile(
                      title: Text(_formatDate(date)),
                      tileColor: isSelected ? Colors.purple.withOpacity(0.1) : null,
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.purple) : null,
                      onTap: () {
                        _onDateChanged(date);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
