import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// A Flutter implementation of the ADHD Assessment Report
/// Converted from React/Material-UI to Flutter

class AdhdReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const AdhdReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data
    final Map<String, dynamic> results = data['results'] ?? {};
    final String additionalNotes = data['additional'] ?? '';

    // Check if results exist (diagnosis is defined)
    final bool hasResults = results.containsKey('diagnosis');

    // Helper to determine Alert severity and icon based on diagnosis
    Map<String, dynamic> getDiagnosisDetails(String? diagnosis) {
      if (diagnosis == null) {
        return {
          'severity': 'info',
          'icon': Icons.info_outline,
          'title': 'Assessment Incomplete or Unavailable',
          'color': Color(0xFF1cb0f6)
        };
      }

      if (diagnosis.contains("Insufficient symptoms")) {
        return {
          'severity': 'success',
          'icon': Icons.check_circle_outline,
          'title': 'Assessment Result',
          'color': Colors.green
        };
      } else if (diagnosis.contains("Attention Deficit") ||
          diagnosis.contains("Hyperactivity Disorder") ||
          diagnosis.contains("Combined")) {
        // Treat any ADHD presentation as needing attention/warning
        return {
          'severity': 'warning',
          'icon': Icons.error_outline,
          'title': 'Assessment Result',
          'color': Colors.orange
        };
      } else {
        // Default case
        return {
          'severity': 'info',
          'icon': Icons.info_outline,
          'title': 'Assessment Result',
          'color': Color(0xFF1cb0f6)
        };
      }
    }

    final Map<String, dynamic> diagnosisDetails =
        getDiagnosisDetails(results['diagnosis']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.psychology_outlined,
                color: Color(0xFF1cb0f6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'ADHD Assessment Report (DSM-5 Criteria)',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b4b4b),
                ),
              ),
            ],
          ),
        ),

        // Summary Section
        if (hasResults)
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
            child: _buildAlertBox(
              context,
              diagnosisDetails['icon'],
              diagnosisDetails['title'],
              diagnosisDetails['color'],
              results['diagnosis'],
              results['inattentionCount'],
              results['hyperactivityCount'],
            ),
          )
        else
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF1cb0f6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Color(0xFF1cb0f6).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF1cb0f6), size: 24),
                const SizedBox(width: 16.0),
                Text(
                  'No assessment results found.',
                  style: GoogleFonts.inter(
                    color: Color(0xFF4b4b4b),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

        // Present Symptoms Summary Section
        if (hasResults &&
            ((results['presentInattentionSymptoms'] != null &&
                    (results['presentInattentionSymptoms'] as List)
                        .isNotEmpty) ||
                (results['presentHyperactivitySymptoms'] != null &&
                    (results['presentHyperactivitySymptoms'] as List)
                        .isNotEmpty)))
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
                      Icons.list_alt,
                      color: Color(0xFF1cb0f6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Present Symptoms Summary',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b4b4b),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Inattention Symptoms
                if (results['presentInattentionSymptoms'] != null &&
                    (results['presentInattentionSymptoms'] as List).isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1cb0f6).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border:
                          Border.all(color: Color(0xFF1cb0f6).withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.psychology,
                                size: 16, color: Color(0xFF1cb0f6)),
                            const SizedBox(width: 8.0),
                            Text(
                              'Inattention',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1cb0f6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        ...(results['presentInattentionSymptoms'] as List)
                            .map((symptom) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: GoogleFonts.inter(
                                        height: 1.5, color: Color(0xFF4b4b4b))),
                                Expanded(
                                  child: Text(
                                    symptom,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Color(0xFF4b4b4b),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                // Hyperactivity/Impulsivity Symptoms
                if (results['presentHyperactivitySymptoms'] != null &&
                    (results['presentHyperactivitySymptoms'] as List)
                        .isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.green.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_run,
                                size: 16, color: Colors.green.shade700),
                            const SizedBox(width: 8.0),
                            Text(
                              'Hyperactivity & Impulsivity',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        ...(results['presentHyperactivitySymptoms'] as List)
                            .map((symptom) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: GoogleFonts.inter(
                                        height: 1.5, color: Color(0xFF4b4b4b))),
                                Expanded(
                                  child: Text(
                                    symptom,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Color(0xFF4b4b4b),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
              ],
            ),
          ),

        // Additional Notes Section
        if (additionalNotes.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
                      Icons.note_alt_outlined,
                      color: Color(0xFF1cb0f6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Additional Clinical Notes',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b4b4b),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    additionalNotes,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xFF4b4b4b),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Disclaimer Footer
        Text(
          'Note: This assessment is based on DSM-5 criteria for ADHD. Professional clinical judgment should be used in conjunction with this screening tool for a formal diagnosis.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),

        // Fallback if no data at all
        if (!hasResults && additionalNotes.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'No ADHD assessment data available for this report.',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  // Helper widget to build the alert box
  Widget _buildAlertBox(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    String? diagnosis,
    dynamic inattentionCount,
    dynamic hyperactivityCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withOpacity(0.3)),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4b4b4b),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  diagnosis ?? 'No diagnosis available',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4b4b4b),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Inattention Symptoms Present:',
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${inattentionCount ?? 'N/A'} / 9',
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Hyperactivity/Impulsivity Symptoms Present:',
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${hyperactivityCount ?? 'N/A'} / 9',
                  style: GoogleFonts.inter(
                    color: Colors.grey[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
