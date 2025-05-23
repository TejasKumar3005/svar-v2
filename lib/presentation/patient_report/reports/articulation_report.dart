import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticulationReport extends StatelessWidget {
  final dynamic data;

  const ArticulationReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if data is null or not a list
    if (data == null) {
      return Container(
    
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          'No articulation data available',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    List<dynamic> changes = [];
    if (data is List) {
      changes = data;
    } else {
      changes = [data]; // Wrap single item in a list
    }

    if (changes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          'No articulation data available',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    // Calculate summary stats
    final Map<String, int> stats = {
      'totalWords': changes.length,
      'correct': 0,
      'substitutions': 0,
      'omissions': 0,
      'distortions': 0,
      'additions': 0,
    };

    for (final change in changes) {
      if (change is Map<String, dynamic> && change.containsKey('checkboxes')) {
        final checkboxes = change['checkboxes'] as Map<String, dynamic>;
        if (checkboxes['C'] == true)
          stats['correct'] = (stats['correct'] ?? 0) + 1;
        if (checkboxes['S'] == true)
          stats['substitutions'] = (stats['substitutions'] ?? 0) + 1;
        if (checkboxes['O'] == true)
          stats['omissions'] = (stats['omissions'] ?? 0) + 1;
        if (checkboxes['D'] == true)
          stats['distortions'] = (stats['distortions'] ?? 0) + 1;
        if (checkboxes['A'] == true)
          stats['additions'] = (stats['additions'] ?? 0) + 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Statistics
        Container(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Words Evaluated
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
              
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
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total Words Evaluated',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4b4b4b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${stats['totalWords']}',
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1cb0f6),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),
              // Error Analysis
              Container(
                height: 180,
                padding: const EdgeInsets.all(16),
              
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
                          Icons.bar_chart,
                          color: Color(0xFF1cb0f6),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Error Analysis',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4b4b4b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _buildStatItem(
                            label: 'Correct',
                            value: stats['correct']!,
                            color: Colors.green,
                          ),
                          _buildStatItem(
                            label: 'Substitutions',
                            value: stats['substitutions']!,
                            color: Colors.red,
                          ),
                          _buildStatItem(
                            label: 'Omissions',
                            value: stats['omissions']!,
                            color: Colors.orange,
                          ),
                          _buildStatItem(
                            label: 'Distortions',
                            value: stats['distortions']!,
                            color: Color(0xFF1cb0f6),
                          ),
                          _buildStatItem(
                            label: 'Additions',
                            value: stats['additions']!,
                            color: Colors.purple,
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

        const SizedBox(height: 24),

        // Detailed Analysis
        Container(
          padding: const EdgeInsets.all(16),
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
                    Icons.list_alt,
                    color: Color(0xFF1cb0f6),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Detailed Analysis',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4b4b4b),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Phoneme Analysis Table
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Header row
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF1cb0f6).withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Category',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1cb0f6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Phoneme',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1cb0f6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Errors',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1cb0f6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Data rows
                    ...changes.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final change = entry.value;

                      if (change is! Map<String, dynamic>) return Container();

                      final String category = change['category'] ?? 'Unknown';
                      final String phoneme = change['phoneme'] ?? 'Unknown';
                      final Map<String, dynamic>? checkboxes =
                          change['checkboxes'];

                      final List<String> errors = [];
                      if (checkboxes != null) {
                        if (checkboxes['S'] == true) errors.add('S');
                        if (checkboxes['O'] == true) errors.add('O');
                        if (checkboxes['D'] == true) errors.add('D');
                        if (checkboxes['A'] == true) errors.add('A');
                      }

                      return Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? Colors.white
                              : Colors.grey.shade50,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                category,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Color(0xFF4b4b4b),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                phoneme,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4b4b4b),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                errors.isEmpty ? 'None' : errors.join(', '),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: errors.isEmpty
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
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
      ],
    );
  }

  Widget _buildStatItem({
    required String label,
    required int value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Color(0xFF4b4b4b),
            ),
          ),
          Text(
            '$value',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisChips(
      Map<String, dynamic>? checkboxes, String? substitution) {
    if (checkboxes == null) return const Text('N/A');

    final List<Widget> chips = [];

    checkboxes.forEach((key, value) {
      if (value == true) {
        String label = key;
        Color color;
        Widget content;

        switch (key) {
          case 'C':
            color = Colors.green;
            content = Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
            break;
          case 'S':
            color = Colors.red;
            label = substitution != null ? 'S → $substitution' : 'S';
            content = Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
          case 'O':
            color = Colors.orange;
            content = Text(
              'O',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
          case 'D':
            color = Colors.blue;
            content = Text(
              'D',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
          case 'A':
            color = Colors.purple;
            content = Text(
              'A',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
            break;
          default:
            color = Colors.grey;
            content = Text(
              key,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            );
        }

        chips.add(content);
      }
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: chips,
    );
  }
}
