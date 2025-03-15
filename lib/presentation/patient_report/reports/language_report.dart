import 'package:flutter/material.dart';

class LanguageReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const LanguageReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nonVerbal = data['nonVerbal'] ?? {};
    final verbal = data['verbal'] ?? {};
    final communication = data['communication'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Non-Verbal Communication Section
        _buildSection(
          title: 'Non-Verbal Communication',
          color: Colors.purple.shade700,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expression
              Expanded(
                child: _buildSubsection(
                  title: 'Expression',
                  color: Colors.purple.shade700,
                  items: _getActiveItems(nonVerbal['expression'] as Map<String, dynamic>?),
                ),
              ),
              const SizedBox(width: 16),
              // Reception
              Expanded(
                child: _buildSubsection(
                  title: 'Reception',
                  color: Colors.purple.shade700,
                  items: _getActiveItems(nonVerbal['reception'] as Map<String, dynamic>?),
                ),
              ),
            ],
          ),
        ),

        // Verbal Communication Section
        _buildSection(
          title: 'Verbal Communication',
          color: Colors.purple.shade700,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expression
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expression',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (verbal['expression'] != null) ...[
                        _buildLabeledField(
                          'Level',
                          verbal['expression']['level'] == 'none'
                              ? 'No verbal expression'
                              : verbal['expression']['level'].replaceAllMapped(
                                  RegExp(r'([A-Z])'),
                                  (match) => ' ${match.group(0)}',
                                ).trim(),
                        ),
                        if (verbal['expression']['details'] != null) ...[
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Details',
                            verbal['expression']['details'],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Reception
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reception',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (verbal['reception'] != null) ...[
                        if (verbal['reception']['simpleCommands'] == true)
                          _buildBulletPoint(
                            'Understands simple commands',
                            Colors.purple.shade700,
                          ),
                        if (verbal['reception']['questions'] == true)
                          _buildBulletPoint(
                            'Responds to questions',
                            Colors.purple.shade700,
                          ),
                        if (verbal['reception']['details'] != null) ...[
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Details',
                            verbal['reception']['details'],
                          ),
                        ],
                        if (verbal['reception']['simpleCommands'] != true &&
                            verbal['reception']['questions'] != true &&
                            verbal['reception']['details'] == null)
                          Text(
                            'No reception details provided',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Communication Content Section (if available)
        if (communication['details'] != null)
          _buildSection(
            title: 'Communication Content',
            color: Colors.purple.shade700,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                communication['details'],
                style: const TextStyle(
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<String> _getActiveItems(Map<String, dynamic>? obj) {
    if (obj == null) return [];
    
    return obj.entries
      .where((entry) => entry.value == true)
      .map((entry) => entry.key.replaceAllMapped(
        RegExp(r'([A-Z])'), 
        (match) => ' ${match.group(0)}'
      ).trim())
      .toList();
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSubsection({
    required String title,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          if (items.isNotEmpty)
            ...items.map((item) => _buildBulletPoint(item, color))
          else
            Text(
              'No data available',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: Colors.purple.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}