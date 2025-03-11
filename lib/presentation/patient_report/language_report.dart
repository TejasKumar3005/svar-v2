import 'package:flutter/material.dart';
import 'common_widgets.dart';

class LanguageReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const LanguageReport({Key? key, required this.data}) : super(key: key);

  List<String> getActiveItems(Map<String, dynamic>? obj) {
    if (obj == null) return [];
    
    return obj.entries
      .where((entry) => entry.value == true)
      .map((entry) => entry.key.replaceAllMapped(
        RegExp(r'([A-Z])'), 
        (match) => ' ${match.group(0)}'
      ).trim())
      .toList();
  }

  @override
  Widget build(BuildContext context) {
    final nonVerbal = data['nonVerbal'] ?? {};
    final verbal = data['verbal'] ?? {};
    final communication = data['communication'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Non-Verbal Communication Section
        ReportSection(
          title: 'Non-Verbal Communication',
          icon: const Icon(Icons.gesture, color: Colors.white),
          headerColor: Colors.deepPurple,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expression
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expression',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (getActiveItems(nonVerbal['expression'] as Map<String, dynamic>?).isNotEmpty)
                        ...getActiveItems(nonVerbal['expression'] as Map<String, dynamic>?)
                            .map((item) => BulletPoint(
                                  text: item,
                                  bulletColor: Colors.deepPurple,
                                ))
                            .toList()
                      else
                        Text(
                          'No expressions noted',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        ),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reception',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (getActiveItems(nonVerbal['reception'] as Map<String, dynamic>?).isNotEmpty)
                        ...getActiveItems(nonVerbal['reception'] as Map<String, dynamic>?)
                            .map((item) => BulletPoint(
                                  text: item,
                                  bulletColor: Colors.deepPurple,
                                ))
                            .toList()
                      else
                        Text(
                          'No reception noted',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Verbal Communication Section
        ReportSection(
          title: 'Verbal Communication',
          icon: const Icon(Icons.record_voice_over, color: Colors.white),
          headerColor: Colors.deepPurple,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expression
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expression',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (verbal['expression'] != null) ...[
                        LabeledField(
                          label: 'Level',
                          value: verbal['expression']['level'] == 'none'
                              ? 'No verbal expression'
                              : verbal['expression']['level'].replaceAllMapped(
                                  RegExp(r'([A-Z])'),
                                  (match) => ' ${match.group(0)}',
                                ).trim(),
                        ),
                        if (verbal['expression']['details'] != null) ...[
                          const SizedBox(height: 12),
                          LabeledField(
                            label: 'Details',
                            value: verbal['expression']['details'],
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reception',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (verbal['reception'] != null) ...[
                        if (verbal['reception']['simpleCommands'] == true)
                          BulletPoint(
                            text: 'Understands simple commands',
                            bulletColor: Colors.deepPurple,
                          ),
                        if (verbal['reception']['questions'] == true)
                          BulletPoint(
                            text: 'Responds to questions',
                            bulletColor: Colors.deepPurple,
                          ),
                        if (verbal['reception']['details'] != null) ...[
                          const SizedBox(height: 12),
                          LabeledField(
                            label: 'Details',
                            value: verbal['reception']['details'],
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
          ReportSection(
            title: 'Communication Content',
            icon: const Icon(Icons.chat, color: Colors.white),
            headerColor: Colors.deepPurple,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
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
}