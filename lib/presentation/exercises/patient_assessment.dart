import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/widgets/buildBottomNavigationBar.dart';


class PatientAssessmentPage extends StatefulWidget {
  final String reportId;
  final String reportType;

  const PatientAssessmentPage({
    Key? key,
    required this.reportId,
    required this.reportType,
  }) : super(key: key);

  @override
  _PatientAssessmentPageState createState() => _PatientAssessmentPageState();

   static Widget builder(BuildContext context) {
    return const PatientAssessmentPage(
      reportId: 'reportId',
      reportType: 'case_history');
  }
}

class _PatientAssessmentPageState extends State<PatientAssessmentPage> {
 
  bool isLoading = true;
  Map<String, dynamic>? reportData;
  String errorMessage = '';

  int _currentIndex = 2; // Default to Today tab

  // This function handles index changes from the bottom navigation bar
  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Note: The navigation logic is handled inside the CustomBottomNavigationBar
  }


  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.reportId)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          reportData = docSnapshot.data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Report not found';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getReportTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black),
            onPressed: () {
              // Implement download functionality
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5ACD)),
              ),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _buildReportContent(),
       bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onIndexChanged: _onIndexChanged,
      ),
    );
  }

  String _getReportTitle() {
    switch (widget.reportType) {
      case 'case_history':
        return 'Case History Report';
      case 'articulation':
        return 'Articulation Assessment';
      case 'fluency':
        return 'Fluency Assessment';
      case 'language':
        return 'Language Assessment';
      case 'opm':
        return 'Oral Peripheral Mechanism';
      case 'prosody':
        return 'Prosody Assessment';
      case 'voice':
        return 'Voice Assessment';
      default:
        return 'Assessment Report';
    }
  }

  Widget _buildReportContent() {
    // Choose the appropriate report view based on report type
    switch (widget.reportType) {
      case 'case_history':
        return CaseHistoryReportView(data: reportData!);
      case 'articulation':
        return ArticulationReportView(data: reportData!);
      case 'fluency':
        return FluencyReportView(data: reportData!);
      case 'language':
        return LanguageReportView(data: reportData!);
      case 'opm':
        return OPMReportView(data: reportData!);
      case 'prosody':
        return ProsodyReportView(data: reportData!);
      case 'voice':
        return VoiceReportView(data: reportData!);
      default:
        return const Center(child: Text('Unknown report type'));
    }
  }
}

// Common widgets used across different report types
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;

  const SectionCard({
    Key? key,
    required this.title,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const InfoField({
    Key? key,
    required this.label,
    required this.value,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          Text(
            unit != null ? '$value $unit' : value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final bool isNormal;
  final bool outlined;

  const StatusChip({
    Key? key,
    required this.label,
    this.isNormal = false,
    this.outlined = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: outlined
              ? (isNormal ? Colors.green.shade700 : Theme.of(context).primaryColor)
              : Colors.white,
        ),
      ),
      backgroundColor: outlined
          ? Colors.transparent
          : (isNormal ? Colors.green.shade100 : Theme.of(context).primaryColor.withValues(alpha: 26)),
      side: BorderSide(
        color: isNormal ? Colors.green.shade300 : Theme.of(context).primaryColor.withValues(alpha: 128),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Implementation of the Case History Report View
class CaseHistoryReportView extends StatelessWidget {
  final Map<String, dynamic> data;

  const CaseHistoryReportView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final basicInfo = data['basicInfo'] ?? {};
    final concerns = data['concerns'] ?? {};
    final medicalHistory = data['medicalHistory'] ?? {};
    final developmentalHistory = data['developmentalHistory'] ?? {};
    final languageDevelopment = data['languageDevelopment'] ?? {};
    final recommendations = data['recommendations'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information
          SectionCard(
            title: 'Basic Information',
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        InfoField(label: 'Name', value: basicInfo['caseName'] ?? 'N/A'),
                        InfoField(label: 'Registration No', value: basicInfo['registrationNo'] ?? 'N/A'),
                        InfoField(label: 'Date', value: basicInfo['date'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        InfoField(label: 'Age/Sex/DOB', value: basicInfo['ageSexDOB'] ?? 'N/A'),
                        InfoField(label: 'Informant', value: basicInfo['informant'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Parents' Concerns
          SectionCard(
            title: 'Parents\' Concerns',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildConcernChips(concerns),
            ),
          ),

          // Medical History
          SectionCard(
            title: 'Medical History',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMedicalHistorySection(
                  'Pre-natal',
                  medicalHistory['prenatal'] ?? {},
                ),
                const SizedBox(height: 16),
                _buildMedicalHistorySection(
                  'Peri-natal',
                  medicalHistory['perinatal'] ?? {},
                  isPeriNatal: true,
                ),
                const SizedBox(height: 16),
                _buildMedicalHistorySection(
                  'Post-natal',
                  medicalHistory['postnatal'] ?? {},
                ),
              ],
            ),
          ),

          // Development
          SectionCard(
            title: 'Development',
            child: Column(
              children: [
                Text(
                  'Developmental Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoField(
                          label: 'Status',
                          value: developmentalHistory['status'] ?? 'N/A',
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        if (developmentalHistory['milestones'] != null) ...[
                          ...(developmentalHistory['milestones'] as Map<String, dynamic>)
                              .entries
                              .map((entry) => InfoField(
                                    label: _capitalizeFirstLetter(entry.key),
                                    value: entry.value ?? 'N/A',
                                  ))
                              .toList(),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Language Development',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoField(
                          label: 'Status',
                          value: languageDevelopment['status'] ?? 'N/A',
                        ),
                        const Divider(),
                        ...(languageDevelopment as Map<String, dynamic>)
                            .entries
                            .where((entry) => entry.key != 'status')
                            .map((entry) => InfoField(
                                  label: _capitalizeFirstLetter(entry.key),
                                  value: entry.value ?? 'N/A',
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recommendations
          SectionCard(
            title: 'Recommendations',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _buildRecommendationChips(recommendations),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConcernChips(Map<String, dynamic> concerns) {
    final List<Widget> chips = [];
    
    concerns.forEach((key, value) {
      if (value == true || (key == 'other' && value is String && value.isNotEmpty)) {
        chips.add(
          StatusChip(
            label: key == 'other' ? value : _capitalizeFirstLetter(key),
            outlined: true,
          ),
        );
      }
    });
    
    return chips;
  }

  Widget _buildMedicalHistorySection(String title, Map<String, dynamic> historyData, {bool isPeriNatal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isPeriNatal
                ? Column(
                    children: [
                      InfoField(label: 'Delivery', value: historyData['delivery'] ?? 'N/A'),
                      InfoField(label: 'Place', value: historyData['deliveryPlace'] ?? 'N/A'),
                      InfoField(label: 'Type', value: historyData['deliveryType'] ?? 'N/A'),
                      InfoField(label: 'Birth Cry', value: historyData['birthCry'] ?? 'N/A'),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _formatMedicalHistory(historyData)
                        .map((item) => BulletPoint(text: item))
                        .toList(),
                  ),
          ),
        ),
      ],
    );
  }

  List<String> _formatMedicalHistory(Map<String, dynamic> history) {
    if (history.isEmpty) return ["No significant medical history"];
    
    final items = <String>[];
    
    history.forEach((key, value) {
      if (value == true && key != 'other') {
        items.add(_formatKey(key));
      }
    });
    
    if (history['other'] != null && history['other'] is String && history['other'].isNotEmpty) {
      items.add(history['other']);
    }
    
    return items.isEmpty ? ["No significant medical history"] : items;
  }

  List<Widget> _buildRecommendationChips(Map<String, dynamic> recommendations) {
    final List<Widget> chips = [];
    
    recommendations.forEach((key, value) {
      if (value == true || (key == 'additional' && value is String && value.isNotEmpty)) {
        chips.add(
          StatusChip(
            label: key == 'additional' ? value : _formatKey(key),
            outlined: true,
          ),
        );
      }
    });
    
    return chips;
  }

  String _formatKey(String key) {
    return key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// Placeholder for other report views
// In a real implementation, you would create detailed views for each report type
class ArticulationReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const ArticulationReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on ArticulationEvaluation React component
          Text('Articulation Assessment Report', 
            style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('Report data would be displayed here'),
        ],
      ),
    );
  }
}

class FluencyReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const FluencyReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on FluencyReport React component
          Text('Fluency Assessment Report', 
            style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class LanguageReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const LanguageReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on LanguageAssessmentReport React component
          Text('Language Assessment Report', 
            style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class OPMReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const OPMReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on OPMReport React component
          Text('Oral Peripheral Mechanism Report', 
            style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class ProsodyReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const ProsodyReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on ProsodyReport React component
          Text('Prosody Assessment Report', 
            style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class VoiceReportView extends StatelessWidget {
  final Map<String, dynamic> data;
  
  const VoiceReportView({Key? key, required this.data}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Implement based on VoiceReport React component
          Text('Voice Assessment Report', 
            style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}


class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Fetch a specific report by ID and type
  Future<Map<String, dynamic>?> getReport(String reportId, String reportType) async {
    try {
      final docSnapshot = await _firestore
          .collection('reports')
          .doc(reportId)
          .get();
          
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    }
  }
  
  // Fetch all reports for a specific child
  Future<List<Map<String, dynamic>>> getChildReports(String childId) async {
    try {
      final querySnapshot = await _firestore
          .collection('reports')
          .where('childId', isEqualTo: childId)
          .orderBy('timestamp', descending: true)
          .get();
          
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print('Error fetching child reports: $e');
      return [];
    }
  }
  
  // Fetch recent reports for the current user's children
  Future<List<Map<String, dynamic>>> getRecentReports(String userId) async {
    try {
      // First get the user's children
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      
      if (userData == null || !userData.containsKey('children')) {
        return [];
      }
      
      List<String> childrenIds = List<String>.from(userData['children']);
      
      // Then fetch the most recent report for each child
      final List<Map<String, dynamic>> recentReports = [];
      
      for (String childId in childrenIds) {
        final querySnapshot = await _firestore
            .collection('reports')
            .where('childId', isEqualTo: childId)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
            
        if (querySnapshot.docs.isNotEmpty) {
          recentReports.add({
            'id': querySnapshot.docs.first.id,
            ...querySnapshot.docs.first.data(),
          });
        }
      }
      
      return recentReports;
    } catch (e) {
      print('Error fetching recent reports: $e');
      return [];
    }
  }
  
  // Save report feedback
  Future<bool> saveReportFeedback(String reportId, String feedback) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'feedback': feedback,
        'feedbackTimestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error saving feedback: $e');
      return false;
    }
  }
}




class ReportListPage extends StatefulWidget {
  final String childId;
  final String childName;

  const ReportListPage({
    Key? key,
    required this.childId,
    required this.childName,
  }) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  List<Map<String, dynamic>> reports = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchReports() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('childId', isEqualTo: widget.childId)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        reports = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading reports: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${widget.childName}\'s Reports',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Assessment Reports'),
            Tab(text: 'Therapy Sessions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsTab(),
          _buildTherapySessionsTab(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (reports.isEmpty) {
      return const Center(
        child: Text('No assessment reports found'),
      );
    }

    // Group reports by month
    final Map<String, List<Map<String, dynamic>>> groupedReports = {};
    
    for (var report in reports) {
      final timestamp = report['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final date = timestamp.toDate();
        final monthYear = DateFormat('MMMM yyyy').format(date);
        
        if (!groupedReports.containsKey(monthYear)) {
          groupedReports[monthYear] = [];
        }
        
        groupedReports[monthYear]!.add(report);
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedReports.length,
      itemBuilder: (context, index) {
        final monthYear = groupedReports.keys.elementAt(index);
        final monthReports = groupedReports[monthYear]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                monthYear,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...monthReports.map((report) => _buildReportCard(report)).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final timestamp = report['timestamp'] as Timestamp?;
    final date = timestamp != null 
        ? DateFormat('dd MMM, yyyy').format(timestamp.toDate())
        : 'No date';
    
    final reportType = report['reportType'] as String? ?? 'unknown';
    final reportTitle = _getReportTitle(reportType);
    
    // Get appropriate icon for the report type
    final icon = _getReportIcon(reportType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/report',
            arguments: {
              'reportId': report['id'],
              'reportType': reportType,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapySessionsTab() {
    // Placeholder for therapy sessions tab
    return const Center(
      child: Text('Therapy sessions will be displayed here'),
    );
  }

  String _getReportTitle(String reportType) {
    switch (reportType) {
      case 'case_history':
        return 'Case History Report';
      case 'articulation':
        return 'Articulation Assessment';
      case 'fluency':
        return 'Fluency Assessment';
      case 'language':
        return 'Language Assessment';
      case 'opm':
        return 'Oral Peripheral Mechanism';
      case 'prosody':
        return 'Prosody Assessment';
      case 'voice':
        return 'Voice Assessment';
      default:
        return 'Assessment Report';
    }
  }

  IconData _getReportIcon(String reportType) {
    switch (reportType) {
      case 'case_history':
        return Icons.history_edu;
      case 'articulation':
        return Icons.record_voice_over;
      case 'fluency':
        return Icons.speed;
      case 'language':
        return Icons.chat_bubble_outline;
      case 'opm':
        return Icons.face;
      case 'prosody':
        return Icons.music_note;
      case 'voice':
        return Icons.mic;
      default:
        return Icons.description;
    }
  }
}





class ChildProfilePage extends StatefulWidget {
  final String childId;

  const ChildProfilePage({
    Key? key,
    required this.childId,
  }) : super(key: key);

  @override
  _ChildProfilePageState createState() => _ChildProfilePageState();
}

class _ChildProfilePageState extends State<ChildProfilePage> {
  bool isLoading = true;
  Map<String, dynamic>? childData;
  List<Map<String, dynamic>> recentReports = [];
  List<Map<String, dynamic>> upcomingAppointments = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchChildData();
  }

  Future<void> _fetchChildData() async {
    try {
      // Fetch child information
      final childDoc = await FirebaseFirestore.instance
          .collection('children')
          .doc(widget.childId)
          .get();

      if (childDoc.exists) {
        setState(() {
          childData = childDoc.data() as Map<String, dynamic>;
        });

        // Fetch recent reports
        await _fetchRecentReports();

        // Fetch upcoming appointments
        await _fetchUpcomingAppointments();

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Child not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading child data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchRecentReports() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('childId', isEqualTo: widget.childId)
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      setState(() {
        recentReports = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
      });
    } catch (e) {
      print('Error loading recent reports: $e');
    }
  }

  Future<void> _fetchUpcomingAppointments() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('childId', isEqualTo: widget.childId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('appointmentDate')
          .limit(3)
          .get();

      setState(() {
        upcomingAppointments = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
      });
    } catch (e) {
      print('Error loading upcoming appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(),
                    SliverToBoxAdapter(
                      child: _buildContent(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildAppBar() {
    final childName = childData?['name'] ?? 'Child';
    final childAge = childData?['age'] ?? '';
    final childImage = childData?['photoUrl'];

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          childName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 179),
                  ],
                ),
              ),
            ),
            if (childImage != null)
              Positioned(
                right: 20,
                bottom: 60,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(childImage),
                ),
              ),
            Positioned(
              left: 20,
              bottom: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    childAge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            // Navigate to edit profile page
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 20),
          _buildReportsSection(),
          const SizedBox(height: 20),
          _buildAppointmentsSection(),
          const SizedBox(height: 20),
          _buildAssessmentsSection(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final dob = childData?['dateOfBirth'] != null
        ? (childData!['dateOfBirth'] as Timestamp).toDate()
        : null;
    final formattedDob = dob != null ? DateFormat('dd MMM yyyy').format(dob) : 'N/A';
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Date of Birth', formattedDob),
            _buildInfoRow('Gender', childData?['gender'] ?? 'N/A'),
            _buildInfoRow('Parent/Guardian', childData?['guardianName'] ?? 'N/A'),
            _buildInfoRow('Contact Number', childData?['contactNumber'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Reports',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all reports page
                Navigator.of(context).pushNamed(
                  '/reports',
                  arguments: {
                    'childId': widget.childId,
                    'childName': childData?['name'] ?? 'Child',
                  },
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        recentReports.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No reports available'),
                  ),
                ),
              )
            : Column(
                children: recentReports
                    .map((report) => _buildReportCard(report))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final timestamp = report['timestamp'] as Timestamp?;
    final date = timestamp != null 
        ? DateFormat('dd MMM yyyy').format(timestamp.toDate())
        : 'No date';
    
    final reportType = report['reportType'] as String? ?? 'unknown';
    final reportTitle = _getReportTitle(reportType);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to report details
          Navigator.of(context).pushNamed(
            '/report',
            arguments: {
              'reportId': report['id'],
              'reportType': reportType,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getReportIcon(reportType),
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Appointments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all appointments page
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        upcomingAppointments.isEmpty
            ? const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No upcoming appointments'),
                  ),
                ),
              )
            : Column(
                children: upcomingAppointments
                    .map((appointment) => _buildAppointmentCard(appointment))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final timestamp = appointment['appointmentDate'] as Timestamp?;
    final date = timestamp != null 
        ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate())
        : 'No date';
    
    final therapistName = appointment['therapistName'] as String? ?? 'N/A';
    final appointmentType = appointment['type'] as String? ?? 'Session';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointmentType,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'With $therapistName',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assessments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAssessmentCard(
                'Speech',
                'Articulation',
                Icons.record_voice_over,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAssessmentCard(
                'Language',
                'Development',
                Icons.chat_bubble_outline,
                Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAssessmentCard(
                'Fluency',
                'Stutter & Rhythm',
                Icons.speed,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAssessmentCard(
                'Voice',
                'Quality & Control',
                Icons.mic,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssessmentCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to specific assessment
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReportTitle(String reportType) {
    switch (reportType) {
      case 'case_history':
        return 'Case History Report';
      case 'articulation':
        return 'Articulation Assessment';
      case 'fluency':
        return 'Fluency Assessment';
      case 'language':
        return 'Language Assessment';
      case 'opm':
        return 'Oral Peripheral Mechanism';
      case 'prosody':
        return 'Prosody Assessment';
      case 'voice':
        return 'Voice Assessment';
      default:
        return 'Assessment Report';
    }
  }

  IconData _getReportIcon(String reportType) {
    switch (reportType) {
      case 'case_history':
        return Icons.history_edu;
      case 'articulation':
        return Icons.record_voice_over;
      case 'fluency':
        return Icons.speed;
      case 'language':
        return Icons.chat_bubble_outline;
      case 'opm':
        return Icons.face;
      case 'prosody':
        return Icons.music_note;
      case 'voice':
        return Icons.mic;
      default:
        return Icons.description;
    }
  }
}