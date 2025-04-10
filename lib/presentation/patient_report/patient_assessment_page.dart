import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'reports/articulation_report.dart';
import 'reports/case_history_report.dart';
import 'reports/fluency_report.dart';
import 'reports/language_report.dart';
import 'reports/opm_report.dart';
import 'reports/prosody_report.dart';
import 'reports/voice_report.dart';

class PatientAssessmentPage extends StatefulWidget {
  const PatientAssessmentPage({Key? key}) : super(key: key);

  @override
  _PatientAssessmentPageState createState() => _PatientAssessmentPageState();

  static Widget builder(BuildContext context) {
    return const PatientAssessmentPage();
  }
}

class _PatientAssessmentPageState extends State<PatientAssessmentPage>
    with SingleTickerProviderStateMixin {
  late String uid;
  bool isLoading = true;
  List<Map<String, dynamic>> allReports = []; // All available reports by date
  Set<String> expandedDates = {}; // Track which dates are expanded
  String errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentIndex = 2;

  // Define report types with their colors
  final Map<String, Color> reportTypes = {
    'articulation': Colors.green.shade700,
    'Articulation': Colors.green.shade700,
    'language': Colors.purple.shade700,
    'Language': Colors.purple.shade700,
    'fluency': Colors.red.shade700,
    'Fluency': Colors.red.shade700,
    'opm': AppTheme.primaryDarkColor,
    'OPM': AppTheme.primaryDarkColor,
    'opm-functions': AppTheme.primaryDarkColor,
    'prosody': Colors.orange.shade700,
    'Prosody': Colors.orange.shade700,
    'voice': Colors.blueGrey.shade700,
    'Voice': Colors.blueGrey.shade700,
    'case_history': Colors.blue.shade700,
    'Case_history': Colors.blue.shade700,
    'Case History': Colors.blue.shade700,
    'capev': Colors.blueGrey.shade700,
    'isaa': Colors.grey.shade600,
  };

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

            // Convert to list of reports by date
            final reports = <Map<String, dynamic>>[];

            assessmentData.forEach((date, reportContent) {
              if (reportContent is Map<String, dynamic>) {
                reports.add({
                  'date': date,
                  'content': reportContent,
                  'reportTypes': reportContent.keys.toList()
                });
              }
            });

            // Sort dates in descending order (latest first)
            reports.sort((a, b) => b['date'].compareTo(a['date']));

            setState(() {
              allReports = reports;
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = 'Assessment data format is not as expected.';
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

 String _formatDate(String dateString) {
  try {
      // Handle dates in format "yyyy-M-d"
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        
        final date = DateTime(year, month, day);
        return DateFormat('MMMM d, yyyy').format(date);
      }
      return dateString;
    }  catch (e) {
    print("errrrrrrr ${e}");
    
    // Try an alternative parsing approach if standard parsing fails
    
    
    return dateString;
  }
}

  void _toggleExpanded(String date) {
    setState(() {
      // If this date is already expanded, close it
      if (expandedDates.contains(date)) {
        expandedDates.remove(date);
      } else {
        // Close any other expanded dates and open this one
        expandedDates.clear();
        expandedDates.add(date);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
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
                                          Icons.assessment,
                                          color: AppTheme.primaryColor,
                                          size: 28,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Evaluation Reports',
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
                                      'View and manage patient evaluation reports organized by date',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Reports by date (accordion style)
                            ...allReports
                                .map((report) => _buildDateReport(report)),
                          ],
                        ),
                      ),
                    ),
                  ),
      );
    
  
  }

  Widget _buildDateReport(Map<String, dynamic> report) {
    final date = report['date'];
    final content = report['content'] as Map<String, dynamic>;
    final reportTypes = report['reportTypes'] as List<dynamic>;
    final bool isExpanded = expandedDates.contains(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: const Color(0xFFF5F8F7), // Very light mint/teal background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header with dropdown arrow
          InkWell(
            onTap: () => _toggleExpanded(date),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppTheme.primaryColor,
                        ),
                      )
                    ],
                  ),
                  if (reportTypes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reportTypes.map<Widget>((type) {
                        String displayName = type;
                        Color borderColor;

                        if (type == 'Case_history') {
                          displayName = 'Case History';
                          borderColor = Colors.blue;
                        } else if (type == 'opm-functions') {
                          displayName = 'OPM';
                          borderColor = AppTheme.primaryColor;
                        } else if (type == 'articulation') {
                          borderColor = Colors.green;
                        } else if (type == 'language') {
                          borderColor = Colors.purple;
                        } else if (type == 'fluency') {
                          borderColor = Colors.red;
                        } else if (type == 'prosody') {
                          borderColor = Colors.orange;
                        } else if (type == 'voice' || type == 'capev') {
                          borderColor = Colors.blueGrey;
                        } else if (type == 'opm') {
                          borderColor = AppTheme.primaryColor;
                          displayName = 'opm';
                        } else if (type == 'OPM') {
                          borderColor = AppTheme.primaryColor;
                        } else {
                          borderColor = Colors.grey;
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: borderColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 14,
                              color: borderColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Expanded content with animation proportional to content size
          AnimatedSize(
            duration: Duration(milliseconds: content.keys.length * 100),
            curve: Curves.easeInCubic,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: isExpanded
                  ? _buildExpandedContent(date, content)
                  : const SizedBox(height: 0),
            ),
          ),
        ],
      ),
    );
  }

  Duration _calculateDuration(Widget content) {
    // Base duration for small content
    const baseDuration = Duration(milliseconds: 300);

    // You can use a multiplier based on your content complexity
    // Option 1: If you can estimate content size from your data model
    final contentSize = content.toString().length; // Simple approximation
    final multiplier = (contentSize / 100).clamp(1.0, 2.0);

    // Option 2: If you're using a BuildContext
    // This would need to be in a method with BuildContext available
    // final RenderBox box = context.findRenderObject() as RenderBox;
    // final size = box.size;
    // final multiplier = math.min(2.0, math.max(1.0, size.height / 200));
     print("this is the duration");
     print(Duration(
        milliseconds: (baseDuration.inMilliseconds * multiplier).round()));
    return Duration(
        milliseconds: (baseDuration.inMilliseconds * multiplier).round());
  }

  Widget _buildExpandedContent(String date, Map<String, dynamic> content) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show Articulation report if available
          if (content.containsKey('articulation') ||
              content.containsKey('Articulation'))
            _buildArticulationReport(content),

          // Show Case History report if available
          if (content.containsKey('Case_history'))
            _buildCaseHistoryReport(content['Case_history']),

          // Show Fluency report if available
          if (content.containsKey('fluency') || content.containsKey('Fluency'))
            _buildFluencyReport(content),

          // Show OPM report if available
          if (content.containsKey('opm') || content.containsKey('OPM'))
            _buildOPMReport(content),

          // Show Prosody report if available
          if (content.containsKey('prosody') || content.containsKey('Prosody'))
            _buildProsodyReport(content),

          // Show Voice report if available
          if (content.containsKey('voice') || content.containsKey('Voice'))
            _buildVoiceReport(content),

          // Show Language report if available
          if (content.containsKey('language') ||
              content.containsKey('Language'))
            _buildLanguageReport(content),
        ],
      ),
    );
  }

  Widget _buildArticulationReport(Map<String, dynamic> content) {
    final data = content['articulation'] ?? content['Articulation'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Articulation Evaluation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ArticulationReport(data: data),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildCaseHistoryReport(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Case History Report',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        CaseHistoryReport(data: data[0]),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildFluencyReport(Map<String, dynamic> content) {
    final data = content['fluency'] ?? content['Fluency'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fluency Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        FluencyReport(data: data is List ? data[0] : {}),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildOPMReport(Map<String, dynamic> content) {
    final data = content['opm'] ?? content['OPM'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'OPM Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        OpmReport(data: data is List ? data[0] : {}),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildProsodyReport(Map<String, dynamic> content) {
    final data = content['prosody'] ?? content['Prosody'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prosody Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ProsodyReport(data: data is List ? data[0] : {}),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildVoiceReport(Map<String, dynamic> content) {
    final data = content['voice'] ?? content['Voice'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        VoiceReport(data: data is List ? data[0] : {}),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildLanguageReport(Map<String, dynamic> content) {
    final data = content['language'] ?? content['Language'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        LanguageReport(data: data is List ? data[0] : {}),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }
}
