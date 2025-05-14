import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          'color': Colors.blue
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
          'color': Colors.blue
        };
      }
    }

    final Map<String, dynamic> diagnosisDetails = getDiagnosisDetails(results['diagnosis']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'ADHD Assessment Report (DSM-5 Criteria)',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Summary Section
        if (hasResults)
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildAlertBox(
                context,
                diagnosisDetails['icon'],
                diagnosisDetails['title'],
                diagnosisDetails['color'],
                results['diagnosis'],
                results['inattentionCount'],
                results['hyperactivityCount'],
              ),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.only(bottom: 24.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Colors.blue[300]!),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 16.0),
                const Text(
                  'No assessment results found.',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),

        // Present Symptoms Summary Section
        if (hasResults &&
            ((results['presentInattentionSymptoms'] != null &&
                    (results['presentInattentionSymptoms'] as List).isNotEmpty) ||
                (results['presentHyperactivitySymptoms'] != null &&
                    (results['presentHyperactivitySymptoms'] as List).isNotEmpty)))
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Present Symptoms Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  // Inattention Symptoms
                  if (results['presentInattentionSymptoms'] != null &&
                      (results['presentInattentionSymptoms'] as List).isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.psychology, size: 16, color: Colors.blue[700]),
                              const SizedBox(width: 8.0),
                              Text(
                                'Inattention',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          ...(results['presentInattentionSymptoms'] as List).map((symptom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(height: 1.5)),
                                  Expanded(
                                    child: Text(
                                      symptom,
                                      style: Theme.of(context).textTheme.bodyMedium,
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
                      (results['presentHyperactivitySymptoms'] as List).isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions_run, size: 16, color: Colors.green[700]),
                              const SizedBox(width: 8.0),
                              Text(
                                'Hyperactivity & Impulsivity',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          ...(results['presentHyperactivitySymptoms'] as List).map((symptom) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(height: 1.5)),
                                  Expanded(
                                    child: Text(
                                      symptom,
                                      style: Theme.of(context).textTheme.bodyMedium,
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
          ),

        // Additional Notes Section
        if (additionalNotes.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Clinical Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Card(
                    margin: EdgeInsets.zero,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        additionalNotes,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Disclaimer Footer
        Text(
          'Note: This assessment is based on DSM-5 criteria for ADHD. Professional clinical judgment should be used in conjunction with this screening tool for a formal diagnosis.',
          style: TextStyle(
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
              style: TextStyle(color: Colors.grey[600]),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: color),
      ),
      padding: const EdgeInsets.all(16.0),
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
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                Text(
                  diagnosis ?? 'No diagnosis available',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Inattention Symptoms Present:',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${inattentionCount ?? 'N/A'} / 9',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Hyperactivity/Impulsivity Symptoms Present:',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${hyperactivityCount ?? 'N/A'} / 9',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
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
