import 'package:svar_new/presentation/patient_report/buildBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/presentation/patient_report/reports/adhd_report.dart';
import 'package:svar_new/presentation/patient_report/reports/capev_report.dart';
import 'package:svar_new/presentation/patient_report/reports/cars_report.dart';
import 'package:svar_new/presentation/patient_report/reports/hi_report.dart';
import 'package:svar_new/presentation/patient_report/reports/isaa_report.dart';
import 'package:svar_new/presentation/patient_report/reports/mchat_report.dart';
import 'package:svar_new/presentation/patient_report/reports/voiceAi_report.dart';
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

  // Define report types with their colors - matching user profile theme
  final Map<String, Color> reportTypes = {
    'articulation': Color(0xFF1cb0f6),
    'language': Color(0xFF1cb0f6),
    'fluency': Color(0xFF1cb0f6),
    'prosody': Color(0xFF1cb0f6),
    'voice': Color(0xFF1cb0f6),
    'opm': Color(0xFF1cb0f6),
    'case_history': Color(0xFF1cb0f6),
    'isaa': Color(0xFF1cb0f6),
    'mchat': Color(0xFF1cb0f6),
    'cars': Color(0xFF1cb0f6),
    'hi': Color(0xFF1cb0f6),
    'adhd': Color(0xFF1cb0f6),
    'voice_analysis': Color(0xFF1cb0f6),
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
    } catch (e) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1cb0f6),
                ),
              )
            : errorMessage.isNotEmpty
                ? _buildErrorState()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildHeader(),
                          _buildReportsList(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
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
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _fetchReportData,
            icon: const Icon(Icons.refresh),
            label: Text(
              'Retry',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1cb0f6),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Color(0xFF1cb0f6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Evaluation Reports',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View and manage patient evaluation reports',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Reports by Date',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4b4b4b),
            ),
          ),
          const SizedBox(height: 16),
          ...allReports.map((report) => _buildDateReport(report)),
        ],
      ),
    );
  }

  Widget _buildDateReport(Map<String, dynamic> report) {
    final date = report['date'];
    final content = report['content'] as Map<String, dynamic>;
    final reportTypes = report['reportTypes'] as List<dynamic>;
    final bool isExpanded = expandedDates.contains(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header with dropdown arrow
          InkWell(
            onTap: () => _toggleExpanded(date),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(date),
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF1cb0f6),
                          size: 28,
                        ),
                      )
                    ],
                  ),
                  if (reportTypes.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: reportTypes.map<Widget>((type) {
                        String displayName = _getDisplayName(type);

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF1cb0f6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFF1cb0f6),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            displayName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Color(0xFF1cb0f6),
                              fontWeight: FontWeight.w600,
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

          // Expanded content with animation
          AnimatedSize(
            duration: Duration(milliseconds: content.keys.length * 100),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              child: isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: _buildExpandedContent(date, content),
                    )
                  : const SizedBox(height: 0),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayName(String type) {
    switch (type.toLowerCase()) {
      case 'case_history':
        return 'Case History';
      case 'opm-functions':
      case 'opm':
        return 'OPM';
      case 'voice_analysis':
        return 'Voice Analysis';
      case 'articulation':
        return 'Articulation';
      case 'language':
        return 'Language';
      case 'fluency':
        return 'Fluency';
      case 'prosody':
        return 'Prosody';
      case 'voice':
        return 'Voice';
      case 'capev':
        return 'CAPE-V';
      case 'isaa':
        return 'ISAA';
      case 'mchat':
        return 'M-CHAT';
      case 'cars':
        return 'CARS';
      case 'hi':
        return 'HI Assessment';
      case 'adhd':
        return 'ADHD';
      default:
        return type.toUpperCase();
    }
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
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show Articulation report if available
          if (content.containsKey('articulation') ||
              content.containsKey('Articulation'))
            _buildReportSection('Articulation Evaluation',
                () => _buildArticulationReport(content)),

          // Show Case History report if available
          if (content.containsKey('Case_history'))
            _buildReportSection('Case History Report',
                () => _buildCaseHistoryReport(content['Case_history'])),

          // Show OPM report if available
          if (content.containsKey('opm') || content.containsKey('OPM'))
            _buildReportSection(
                'OPM Assessment', () => _buildOPMReport(content)),

          // Show Prosody report if available
          if (content.containsKey('prosody') || content.containsKey('Prosody'))
            _buildReportSection(
                'Prosody Assessment', () => _buildProsodyReport(content)),

          if (content.containsKey("isaa"))
            _buildReportSection(
                'ISAA Assessment', () => _buildIsaaReport(content)),

          if (content.containsKey("mchat"))
            _buildReportSection(
                'M-CHAT Assessment', () => _buildMchatReport(content)),

          if (content.containsKey("cars"))
            _buildReportSection(
                'CARS Assessment', () => _buildCarsReport(content)),

          if (content.containsKey("hi"))
            _buildReportSection('HI Assessment', () => _buildHiReport(content)),

          if (content.containsKey("adhd"))
            _buildReportSection(
                'ADHD Assessment', () => _buildAdhdReport(content)),

          if (content.containsKey("voice_analysis"))
            _buildReportSection(
                'Voice Analysis', () => _buildVoiceAiReport(content)),

          // Show Language report if available
          if (content.containsKey('language') ||
              content.containsKey('Language'))
            _buildReportSection(
                'Language Assessment', () => _buildLanguageReport(content)),
        ],
      ),
    );
  }

  Widget _buildReportSection(String title, Widget Function() reportBuilder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assessment_outlined,
                color: Color(0xFF1cb0f6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b4b4b),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          reportBuilder(),
        ],
      ),
    );
  }

  Widget _buildArticulationReport(Map<String, dynamic> content) {
    final data = content['articulation'] ?? content['Articulation'];
    return ArticulationReport(data: data);
  }

  Widget _buildVoiceAiReport(Map<String, dynamic> content) {
    final data = content['voice_analysis'] ?? content['Voice_analysis'];
    return VoiceAnalysisReport(reportData: data is List ? data[0] : {});
  }

  Widget _buildCapevReport(Map<String, dynamic> content) {
    final data = content['capev'] ?? content['capev'];
    return CapeVReport(data: data is List ? data[0] : {});
  }

  Widget _buildCaseHistoryReport(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();
    return CaseHistoryReport(data: data[0]);
  }

  Widget _buildFluencyReport(Map<String, dynamic> content) {
    final data = content['fluency'] ?? content['Fluency'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return FluencyReport(data: data is List ? data[0] : {});
  }

  Widget _buildIsaaReport(Map<String, dynamic> content) {
    final data = content['isaa'] ?? content['Isaa'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return IsaaReport(data: data is List ? data[0] : {});
  }

  Widget _buildMchatReport(Map<String, dynamic> content) {
    final data = content['mchat'] ?? content['Mchat'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return MchatReport(data: data is List ? data[0] : {});
  }

  Widget _buildCarsReport(Map<String, dynamic> content) {
    final data = content['cars'] ?? content['Cars'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return CarsReport(data: data is List ? data[0] : {});
  }

  Widget _buildHiReport(Map<String, dynamic> content) {
    final data = content['hi'] ?? content['hi'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return HiReport(data: data is List ? data[0] : {});
  }

  Widget _buildAdhdReport(Map<String, dynamic> content) {
    final data = content['hi'] ?? content['hi'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return AdhdReport(data: data is List ? data[0] : {});
  }

  Widget _buildOPMReport(Map<String, dynamic> content) {
    final data = content['opm'] ?? content['OPM'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return OpmReport(data: data is List ? data[0] : {});
  }

  Widget _buildProsodyReport(Map<String, dynamic> content) {
    final data = content['prosody'] ?? content['Prosody'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return ProsodyReport(data: data is List ? data[0] : {});
  }

  Widget _buildVoiceReport(Map<String, dynamic> content) {
    final data = content['voice'] ?? content['Voice'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return VoiceReport(data: data is List ? data[0] : {});
  }

  Widget _buildLanguageReport(Map<String, dynamic> content) {
    final data = content['language'] ?? content['Language'];
    if (data == null || (data is List && data.isEmpty))
      return const SizedBox.shrink();
    return LanguageReport(data: data is List ? data[0] : {});
  }
}
