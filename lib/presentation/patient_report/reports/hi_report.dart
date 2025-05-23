import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A Flutter implementation of the Integrated Scale of Development Report
/// Converted from React/Material-UI to Flutter

// Define scale labels - matches the original React component's configuration
final Map<String, String> scaleLabels = {
  'listening': 'Listening (Audition)',
  'receptive': 'Receptive Language',
  'expressive': 'Expressive Language',
  'speech': 'Speech',
  'cognition': 'Cognition',
  'socialCommunication': 'Social Communication (Pragmatics)'
};

// Helper to format the score display
String formatScoreDisplay(dynamic scoreValue) {
  // Handle empty, null, or undefined scores
  if (scoreValue == null || scoreValue == '') {
    return 'N/A'; // Not Available / Not Assessed
  }

  // Convert to number if it's a string
  num? numScore;
  if (scoreValue is String) {
    numScore = num.tryParse(scoreValue);
  } else if (scoreValue is num) {
    numScore = scoreValue;
  }

  // Check if conversion failed or resulted in NaN
  if (numScore == null) {
    return 'Invalid'; // Indicates non-numeric input was saved
  }

  // Basic check for plausible age range
  if (numScore < 0) {
    return 'Invalid';
  }

  // Format valid number
  return '${numScore} months';
}

// Main widget for the Integrated Scale of Development Report
class HiReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const HiReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract remarks from data
    final String remarks = data['remarks'] ?? '';

    // Filter out remarks and any unexpected keys to get only scale data
    final Map<String, dynamic> scaleData = Map.fromEntries(data.entries.where(
        (entry) =>
            entry.key != 'remarks' && scaleLabels.containsKey(entry.key)));

    // Check if there is any actual scale data to display
    final bool hasScaleData =
        scaleData.values.any((value) => value != null && value != '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Developmental Levels Section
        if (hasScaleData)
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
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
                      Icons.timeline,
                      color: Color(0xFF1cb0f6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Developmental Levels',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b4b4b),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ...scaleLabels.entries.toList().asMap().entries.map((entry) {
                  final int index = entry.key;
                  final MapEntry<String, String> scaleEntry = entry.value;
                  final String key = scaleEntry.key;
                  final String label = scaleEntry.value;

                  final dynamic scoreValue = scaleData[key];
                  final String displayScore = formatScoreDisplay(scoreValue);

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                label,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4b4b4b),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 90.0,
                              child: Text(
                                displayScore,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1cb0f6),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add divider if not the last item
                      if (index < scaleLabels.length - 1)
                        Divider(height: 1, color: Colors.grey.shade200),
                    ],
                  );
                }).toList(),
              ],
            ),
          )
        else
          // Show message if no scale data, but remarks might still exist
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              'No developmental scale data recorded.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),

        // Remarks Section
        if (remarks.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
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
                      'Additional Remarks',
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
                    remarks,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xFF4b4b4b),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Fallback message if absolutely no data (neither scales nor remarks)
        if (!hasScaleData && remarks.isEmpty)
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              'No Integrated Scales data available for this report.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }
}
