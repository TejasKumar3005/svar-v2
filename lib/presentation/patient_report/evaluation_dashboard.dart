import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'reports/articulation_report.dart';
import 'reports/case_history_report.dart';
import 'reports/fluency_report.dart';
import 'reports/language_report.dart';
import 'reports/opm_report.dart';
import 'reports/prosody_report.dart';
import 'reports/voice_report.dart';

class AssessmentType {
  final String id;
  final String label;
  final Color color;
  final IconData icon;

  const AssessmentType({
    required this.id,
    required this.label,
    required this.color,
    required this.icon,
  });
}

class EvaluationDashboard extends StatefulWidget {
  final Map<String, dynamic> reportData;

  const EvaluationDashboard({Key? key, required this.reportData})
      : super(key: key);

  @override
  State<EvaluationDashboard> createState() => _EvaluationDashboardState();
}

class _EvaluationDashboardState extends State<EvaluationDashboard> {
  final Map<String, AssessmentType> assessmentTypes = {
    'Case_history': AssessmentType(
      id: 'Case_history',
      label: 'Case History',
      color: Colors.teal,
      icon: Icons.assignment,
    ),
    'language': AssessmentType(
      id: 'language',
      label: 'Language',
      color: Colors.deepPurple,
      icon: Icons.chat_bubble,
    ),
    'articulation': AssessmentType(
      id: 'articulation',
      label: 'Articulation',
      color: Colors.green,
      icon: Icons.record_voice_over,
    ),
    'opm': AssessmentType(
      id: 'opm',
      label: 'OPM',
      color: Colors.blue,
      icon: Icons.face,
    ),
    'prosody': AssessmentType(
      id: 'prosody',
      label: 'Prosody',
      color: Colors.amber,
      icon: Icons.waves,
    ),
    'fluency': AssessmentType(
      id: 'fluency',
      label: 'Fluency',
      color: Colors.red,
      icon: Icons.show_chart,
    ),
    'capev': AssessmentType(
      id: 'capev',
      label: 'Voice',
      color: Colors.blueGrey,
      icon: Icons.mic,
    ),
  };

  int _selectedIndex = 0;

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  List<String> getAvailableTypes() {
    return widget.reportData.keys
        .where((key) => assessmentTypes.containsKey(key))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Default select the first available assessment type
    final types = getAvailableTypes();
    if (types.isNotEmpty) {
      _selectedIndex = 0;
    }
  }

  Widget _buildAssessmentTypeButton(String type, int index) {
    final isSelected = index == _selectedIndex;
    final assessmentType = assessmentTypes[type]!;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? assessmentType.color : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: assessmentType.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: isSelected
                ? assessmentType.color
                : Colors.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              assessmentType.icon,
              color: isSelected ? Colors.white : assessmentType.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              assessmentType.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableTypes = getAvailableTypes();

    if (availableTypes.isEmpty) {
      return const Center(
        child: Text('No assessment data found'),
      );
    }

    // Ensure selected index is valid
    if (_selectedIndex >= availableTypes.length) {
      _selectedIndex = 0;
    }

    final selectedType = availableTypes[_selectedIndex];
    final selectedData = widget.reportData[selectedType];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Assessment Type Selection
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableTypes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final type = availableTypes[index];
              return _buildAssessmentTypeButton(type, index);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Display selected assessment report
        Expanded(
          child: SingleChildScrollView(
            child: _buildReportForType(selectedType, selectedData),
          ),
        ),
      ],
    );
  }

  Widget _buildReportForType(String type, dynamic data) {
    switch (type) {
      case 'Case_history':
        return CaseHistoryReport(data: data[0] ?? {});
      case 'language':
        return LanguageReport(data: data[0] ?? {});
      case 'articulation':
        return ArticulationReport(data: data);
      case 'opm':
        return OpmReport(data: data[0] ?? {});
      case 'prosody':
        return ProsodyReport(data: data[0] ?? {});
      case 'fluency':
        return FluencyReport(data: data[0] ?? {});
      case 'capev':
        return VoiceReport(data: data[0] ?? {});
      default:
        return Center(
          child: Text('Unknown assessment type: $type'),
        );
    }
  }
}