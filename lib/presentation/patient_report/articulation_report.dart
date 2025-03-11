import 'package:flutter/material.dart';
import 'common_widgets.dart';

class ArticulationReport extends StatelessWidget {
  final dynamic data;

  const ArticulationReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if data is null or not a list
    if (data == null || (data is! List && data is! List<dynamic>)) {
      return const Center(
        child: Text('No articulation data available'),
      );
    }

    final List<dynamic> changes = data as List<dynamic>;
    if (changes.isEmpty) {
      return const Center(
        child: Text('No articulation data available'),
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
        if (checkboxes['C'] == true) stats['correct'] = (stats['correct'] ?? 0) + 1;
        if (checkboxes['S'] == true) stats['substitutions'] = (stats['substitutions'] ?? 0) + 1;
        if (checkboxes['O'] == true) stats['omissions'] = (stats['omissions'] ?? 0) + 1;
        if (checkboxes['D'] == true) stats['distortions'] = (stats['distortions'] ?? 0) + 1;
        if (checkboxes['A'] == true) stats['additions'] = (stats['additions'] ?? 0) + 1;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Statistics
        ReportSection(
          title: 'Summary Statistics',
          icon: const Icon(Icons.bar_chart, color: Colors.white),
          headerColor: Colors.green,
          child: Column(
            children: [
              // Words Evaluated and Error Analysis in a grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Words Evaluated
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total Words Evaluated',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${stats['totalWords']}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Error Analysis
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error Analysis',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StatItem(
                            label: 'Correct',
                            value: stats['correct']!,
                            color: Colors.green,
                          ),
                          _StatItem(
                            label: 'Substitutions',
                            value: stats['substitutions']!,
                            color: Colors.red,
                          ),
                          _StatItem(
                            label: 'Omissions',
                            value: stats['omissions']!,
                            color: Colors.orange,
                          ),
                          _StatItem(
                            label: 'Distortions',
                            value: stats['distortions']!,
                            color: Colors.blue,
                          ),
                          _StatItem(
                            label: 'Additions',
                            value: stats['additions']!,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Phoneme Analysis Table
        ReportSection(
          title: 'Detailed Phoneme Analysis',
          icon: const Icon(Icons.details, color: Colors.white),
          headerColor: Colors.green,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.green.shade50),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phoneme',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Position',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Word',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Analysis',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List.generate(changes.length, (index) {
                  final change = changes[index] as Map<String, dynamic>;
                  return DataRow(
                    cells: [
                      DataCell(Text(change['category'] ?? 'N/A')),
                      DataCell(Text(change['phoneme'] ?? 'N/A')),
                      DataCell(Text(change['position'] ?? 'N/A')),
                      DataCell(Text(change['item'] ?? 'N/A')),
                      DataCell(_buildStatusChips(
                        change['checkboxes'] as Map<String, dynamic>?,
                        change['substitution'],
                      )),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChips(Map<String, dynamic>? checkboxes, String? substitution) {
    if (checkboxes == null) return const Text('N/A');

    final List<Widget> chips = [];

    checkboxes.forEach((key, value) {
      if (value == true) {
        String label = key;
        Color color;

        switch (key) {
          case 'C':
            color = Colors.green;
            break;
          case 'S':
            color = Colors.red;
            label = substitution != null ? 'S → $substitution' : 'S';
            break;
          case 'O':
            color = Colors.orange;
            break;
          case 'D':
            color = Colors.blue;
            break;
          case 'A':
            color = Colors.purple;
            break;
          default:
            color = Colors.grey;
        }

        chips.add(
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    });

    return Wrap(
      children: chips,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}