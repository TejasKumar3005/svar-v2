import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A Flutter implementation of the CARS-2 (Childhood Autism Rating Scale) report
/// Converted from React/Material-UI to Flutter

// Define categories - matches the original React component's data
final List<Map<String, dynamic>> categories = [
  {"id": 1, "title": "Social-Emotional Understanding", "median": 2.5},
  {
    "id": 2,
    "title": "Emotional Expression and Regulation of Emotions",
    "median": 2.5
  },
  {"id": 3, "title": "Relating to People", "median": 2.5},
  {"id": 4, "title": "Body Use", "median": 2.0},
  {"id": 5, "title": "Object Use in Play", "median": 2.0},
  {
    "id": 6,
    "title": "Adaptation to Change/Restricted Interests",
    "median": 2.5
  },
  {"id": 7, "title": "Visual Response", "median": 2.0},
  {"id": 8, "title": "Listening Response", "median": 2.0},
  {"id": 9, "title": "Taste, Smell, and Touch Response and Use", "median": 2.0},
  {"id": 10, "title": "Fear or Anxiety", "median": 2.0},
  {"id": 11, "title": "Verbal Communication", "median": 2.5},
  {"id": 12, "title": "Nonverbal Communication", "median": 2.0},
  {"id": 13, "title": "Thinking/Cognitive Integration Skills", "median": 2.0},
  {
    "id": 14,
    "title": "Level and Consistency of Intellectual Response",
    "median": 2.0
  },
  {"id": 15, "title": "General Impressions", "median": 2.5}
];

// Helper function to get severity details
Map<String, dynamic> getSeverityDetails(String group) {
  switch (group) {
    case 'minimal':
      return {
        'text': 'Minimal-to-No Symptoms of Autism Spectrum Disorder',
        'range': '(15-27.5)',
        'color': Colors.green,
      };
    case 'mild':
      return {
        'text': 'Mild-to-Moderate Symptoms of Autism Spectrum Disorder',
        'range': '(28-33.5)',
        'color': Colors.orange,
      };
    case 'severe':
      return {
        'text': 'Severe Symptoms of Autism Spectrum Disorder',
        'range': '(34+)',
        'color': Colors.red,
      };
    default:
      return {
        'text': 'Not Classified',
        'range': '',
        'color': Colors.grey,
      };
  }
}

class CarsReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const CarsReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data or use defaults
    final Map<String, dynamic> ratings = data['ratings'] ?? {};
    final double? totalRawScore = data['totalRawScore'] is num
        ? (data['totalRawScore'] as num).toDouble()
        : null;
    final String severityGroup = data['severityGroup'] ?? '';
    final String remarks = data['remarks'] ?? '';

    // Check if there's enough data to display a meaningful report
    final bool hasData = ratings.isNotEmpty && totalRawScore != null;

    // Get severity details
    final Map<String, dynamic> severityDetails =
        getSeverityDetails(severityGroup);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.assessment_outlined,
                color: Color(0xFF1cb0f6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Category Ratings Report (CARS-2)',
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
        if (hasData)
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
                      Icons.summarize_outlined,
                      color: Color(0xFF1cb0f6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Assessment Summary',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b4b4b),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 600) {
                      // Wide layout (similar to sm breakpoint)
                      return Row(
                        children: [
                          Expanded(
                            child: _buildTotalScoreSection(
                                context, totalRawScore!),
                          ),
                          Expanded(
                            child:
                                _buildSeveritySection(context, severityDetails),
                          ),
                        ],
                      );
                    } else {
                      // Narrow layout
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTotalScoreSection(context, totalRawScore!),
                          const SizedBox(height: 16.0),
                          _buildSeveritySection(context, severityDetails),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),

        // Detailed Ratings Section
        if (hasData)
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
                      'Detailed Category Ratings',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4b4b4b),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ...categories.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, dynamic> category = entry.value;
                  final dynamic ratingValue = ratings[category['title']];
                  final String displayRating = ratingValue is num
                      ? ratingValue.toStringAsFixed(1)
                      : 'N/A';

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${category['id']}. ${category['title']}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4b4b4b),
                                    ),
                                  ),
                                  Text(
                                    'Median = ${(category['median'] as double).toStringAsFixed(1)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 60.0,
                              child: Text(
                                displayRating,
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
                      if (index < categories.length - 1)
                        Divider(height: 1, color: Colors.grey.shade200),
                    ],
                  );
                }).toList(),
              ],
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

        // Fallback if no data
        if (!hasData && remarks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'No CARS-2 data available for this report.',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  // Helper widget for total score section
  Widget _buildTotalScoreSection(BuildContext context, double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Raw Score:',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4b4b4b),
            fontSize: 14,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              score.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
                color: Color(0xFF1cb0f6),
              ),
            ),
          ],
        ),
        Text(
          '(SEM = 0.73)',
          style: GoogleFonts.inter(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Helper widget for severity section
  Widget _buildSeveritySection(
      BuildContext context, Map<String, dynamic> severityDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity Group:',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4b4b4b),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: severityDetails['color'].withOpacity(0.1),
            border:
                Border.all(color: severityDetails['color'].withOpacity(0.5)),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            '${severityDetails['text']} ${severityDetails['range']}',
            style: GoogleFonts.inter(
              color: severityDetails['color'],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
