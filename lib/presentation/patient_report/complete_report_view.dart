import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'articulation_report.dart';
import 'case_history_report.dart';
import 'fluency_report.dart';
import 'language_report.dart';
import 'opm_report.dart';
import 'prosody_report.dart';
import 'voice_report.dart';


class CompleteReportView extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const CompleteReportView({Key? key, required this.reportData}) : super(key: key);

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Date from the report data
    final String reportDate = reportData.containsKey('date') ? reportData['date'] : '';
    
    // Extract patient name from case history if available
    String patientName = '';
    if (reportData.containsKey('Case_history') && 
        reportData['Case_history'] != null && 
        reportData['Case_history'].isNotEmpty &&
        reportData['Case_history'][0] != null &&
        reportData['Case_history'][0]['basicInfo'] != null &&
        reportData['Case_history'][0]['basicInfo']['caseName'] != null) {
      patientName = reportData['Case_history'][0]['basicInfo']['caseName'];
    }
    
    // Order of sections to display (if available)
    final List<String> sectionOrder = [
      'Case_history',
      'language',
      'articulation',
      'opm',
      'prosody',
      'fluency',
      'capev',
    ];

    // Get the available sections from the report data
    final availableSections = sectionOrder.where((section) => 
      reportData.containsKey(section) && reportData[section] != null
    ).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Comprehensive Assessment Report',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (patientName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Patient: $patientName',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (reportDate.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      formatDate(reportDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Report sections
          Expanded(
            child: availableSections.isEmpty
                ? const Center(
                    child: Text('No assessment data available for this date'),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Case History Section
                        if (reportData.containsKey('Case_history') && reportData['Case_history'] != null) ...[
                          _buildSectionHeader(context, 'Case History', Icons.assignment),
                          CaseHistoryReport(data: reportData['Case_history'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Language Assessment Section
                        if (reportData.containsKey('language') && reportData['language'] != null) ...[
                          _buildSectionHeader(context, 'Language Assessment', Icons.chat_bubble),
                          LanguageReport(data: reportData['language'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Articulation Assessment Section
                        if (reportData.containsKey('articulation') && reportData['articulation'] != null) ...[
                          _buildSectionHeader(context, 'Articulation Assessment', Icons.record_voice_over),
                          ArticulationReport(data: reportData['articulation']),
                          const SizedBox(height: 24),
                        ],

                        // OPM Assessment Section
                        if (reportData.containsKey('opm') && reportData['opm'] != null) ...[
                          _buildSectionHeader(context, 'Oral Peripheral Mechanism', Icons.face),
                          OpmReport(data: reportData['opm'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Prosody Assessment Section
                        if (reportData.containsKey('prosody') && reportData['prosody'] != null) ...[
                          _buildSectionHeader(context, 'Prosody Assessment', Icons.waves),
                          ProsodyReport(data: reportData['prosody'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Fluency Assessment Section
                        if (reportData.containsKey('fluency') && reportData['fluency'] != null) ...[
                          _buildSectionHeader(context, 'Fluency Assessment', Icons.show_chart),
                          FluencyReport(data: reportData['fluency'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Voice Assessment Section
                        if (reportData.containsKey('capev') && reportData['capev'] != null) ...[
                          _buildSectionHeader(context, 'Voice Assessment', Icons.mic),
                          VoiceReport(data: reportData['capev'][0] ?? {}),
                          const SizedBox(height: 24),
                        ],

                        // Footer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'End of Report',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This report was generated on ${DateTime.now().toString().substring(0, 10)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}