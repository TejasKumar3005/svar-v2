import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IsaaReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const IsaaReport({Key? key, required this.data}) : super(key: key);

  // Define sections and score options
  static const Map<String, List<String>> sections = {
    'I. SOCIAL RELATIONSHIP AND RECIPROCITY': [
      'Has poor eye contact',
      'Lacks social smile',
      'Remains aloof',
      'Does not reach out to others',
      'Unable to relate to people',
      'Unable to respond to social/environmental cues',
      'Engages in solitary and repetitive play activities',
      'Unable to take turns in social interaction',
      'Does not maintain peer relationships'
    ],
    'II. EMOTIONAL RESPONSIVENESS': [
      'Shows inappropriate emotional response',
      'Shows exaggerated emotions',
      'Engages in self-stimulating emotions',
      'Lacks fear of danger',
      'Excited or agitated for no apparent reason'
    ],
    'III. SPEECH-LANGUAGE AND COMMUNICATION': [
      'Acquired speech and lost it',
      'Has difficulty in using non-verbal language or gestures to communicate',
      'Engages in stereotyped and repetitive use of language',
      'Engages in echolalic speech',
      'Produces infantile squeals/unusual noises',
      'Unable to initiate or sustain conversation with others',
      'Uses jargon or meaningless words',
      'Uses pronoun reversals',
      'Unable to grasp pragmatics of communication (real meaning)'
    ],
    'IV. BEHAVIOUR PATTERNS': [
      'Engages in stereotyped and repetitive motor mannerisms',
      'Shows attachment to inanimate objects',
      'Shows hyperactivity/restlessness',
      'Exhibits aggressive behavior',
      'Throws temper tantrums',
      'Engages in self-injurious behavior',
      'Insists on sameness'
    ],
    'V. SENSORY ASPECTS': [
      'Unusually sensitive to sensory stimuli',
      'Stares into space for long periods of time',
      'Has difficulty in tracking objects',
      'Has unusual vision',
      'Insensitive to pain',
      'Responds to objects/people unusually by smelling, touching or tasting'
    ],
    'VI. COGNITIVE COMPONENT': [
      'Inconsistent attention and concentration',
      'Shows delay in responding',
      'Has unusual memory of some kind',
      'Has \'savant\' ability'
    ]
  };

  static const List<Map<String, dynamic>> scoreOptions = [
    {'label': 'Rarely', 'subLabel': 'Upto 20%', 'score': 1},
    {'label': 'Sometimes', 'subLabel': '21-40%', 'score': 2},
    {'label': 'Frequently', 'subLabel': '41-60%', 'score': 3},
    {'label': 'Mostly', 'subLabel': '61-80%', 'score': 4},
    {'label': 'Always', 'subLabel': '81-100%', 'score': 5}
  ];

  // Helper function to get the label for a score
  String getScoreLabel(int score) {
    final option = scoreOptions.firstWhere(
      (opt) => opt['score'] == score,
      orElse: () => {'label': 'N/A', 'score': 0},
    );
    return '${option['label']} ($score)';
  }

  // Helper function to calculate total score and severity
  Map<String, dynamic> calculateIsa(Map<String, dynamic>? scores) {
    if (scores == null) {
      return {'totalScore': 0, 'severity': 'N/A'};
    }

    final totalScore = scores.values
        .map((score) => score is int ? score : 0)
        .fold(0, (sum, score) => sum + score);

    String severity = 'N/A';
    if (totalScore < 70) {
      severity = 'No Autism';
    } else if (totalScore <= 106) {
      severity = 'Mild Autism';
    } else if (totalScore <= 153) {
      severity = 'Moderate Autism';
    } else {
      severity = 'Severe Autism';
    }

    return {'totalScore': totalScore, 'severity': severity};
  }

  @override
  Widget build(BuildContext context) {
    // Use provided scores, or default to empty map
    final Map<String, dynamic> scores = data['scores'] ?? {};
    final String remarks = data['remarks'] ?? '';

    // Calculate total score and severity if not provided in data
    final Map<String, dynamic> result =
        data['totalScore'] != null && data['severity'] != null
            ? {'totalScore': data['totalScore'], 'severity': data['severity']}
            : calculateIsa(scores);

    final int totalScore = result['totalScore'];
    final String severity = result['severity'];
    final bool hasScores = scores.isNotEmpty;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
          
            // Summary Card
            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              padding: const EdgeInsets.all(8.0),
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
                        'Summary',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4b4b4b),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Classification Table
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade100,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Classification',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'No Autism',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Mild Autism',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Moderate Autism',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Severe Autism',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table Data Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Score Range',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  '< 70',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  '70 - 106',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  '107 - 153',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  '> 153',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Results Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total Score: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: hasScores ? '$totalScore' : 'N/A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.indigo.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Classification: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: hasScores ? severity : 'N/A',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.indigo.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Detailed Scores Section
            if (hasScores)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed Scores',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...sections.entries.map((entry) {
                        final sectionTitle = entry.key;
                        final items = entry.value;

                        // Filter items in this section that actually have a score recorded
                        final scoredItemsInSection = items
                            .where((item) => scores[item] != null)
                            .toList();

                        // Only render the section if there are scored items in it
                        if (scoredItemsInSection.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Text(
                                sectionTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...scoredItemsInSection.map((item) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(item),
                                      ),
                                      Text(
                                        getScoreLabel(scores[item]),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.indigo.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

            // Remarks Section
            if (remarks.isNotEmpty)
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Remarks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          remarks,
                          style: const TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // No Data Available Message
            if (!hasScores && remarks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No ISAA data available for this report.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
