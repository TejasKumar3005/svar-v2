import 'package:flutter/material.dart';

class ArticulationReport extends StatelessWidget {
  final dynamic data;

  const ArticulationReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if data is null or not a list
    if (data == null) {
      return const Center(
        child: Text('No articulation data available'),
      );
    }

    List<dynamic> changes = [];
    if (data is List) {
      changes = data;
    } else {
      changes = [data]; // Wrap single item in a list
    }
    
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
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Words Evaluated - Fixed to exactly 1/2 width
              Expanded(
                flex: 1, // Equal flex to ensure both cards have same width
                child: Container(
                  height: 220, // Increased height to prevent overflow
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 8), // Margin for spacing
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Words Evaluated',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
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
              // Error Analysis - Fixed to exactly 1/2 width
              Expanded(
                flex: 1, // Equal flex for equal width
                child: Container(
                  height: 220, // Increased height to match and prevent overflow
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(left: 8), // Margin for spacing
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error Analysis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        color: Colors.blue,
                      ),
                      _buildStatItem(
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
        ),
        
        const SizedBox(height: 24),
        
        // Detailed Analysis
        Text(
          'Detailed Analysis',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(height: 12),
        
        // Phoneme Analysis Table
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Phoneme',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Position',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Word',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Analysis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Data rows
              ...List.generate(changes.length, (index) {
                final change = changes[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(change['category'] ?? 'N/A'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(change['phoneme'] ?? 'N/A'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(change['position'] ?? 'N/A'),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(change['item'] ?? 'N/A'),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildAnalysisChips(
                          change['checkboxes'] as Map<String, dynamic>?,
                          change['substitution'],
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: color,
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

  Widget _buildAnalysisChips(Map<String, dynamic>? checkboxes, String? substitution) {
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