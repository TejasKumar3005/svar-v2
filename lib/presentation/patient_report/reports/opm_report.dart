import 'package:flutter/material.dart';

class OpmReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const OpmReport({Key? key, required this.data}) : super(key: key);

  String formatKey(String key) {
    return key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
  }

  // Get normal items from a section
  List<String> getNormalItems(Map<String, dynamic>? section) {
    if (section == null) return [];

    return section.entries
        .where((entry) {
          final value = entry.value;
          return value is Map<String, dynamic>
              ? (value['status'] == 'normal' || value['status'] == 'adequate')
              : (value == 'Normal' || value == 'Adequate');
        })
        .map((entry) => formatKey(entry.key))
        .toList();
  }

  // Get abnormal items from a section
  Map<String, dynamic> getAbnormalItems(Map<String, dynamic>? section) {
    if (section == null) return {};

    final result = <String, dynamic>{};
    section.forEach((key, value) {
      final status = value is Map<String, dynamic> ? value['status'] : value;
      if (status != 'normal' && status != 'adequate' && status != 'Normal' && status != 'Adequate') {
        result[key] = value is Map<String, dynamic> ? value['status'] : value;
      }
    });
    return result;
  }

  bool hasContent(Map<String, dynamic>? data) {
    if (data == null) return false;
    return data.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final structural = data['structural'] as Map<String, dynamic>? ?? {};
    
    final functions = {
      'Tongue': data['Tongue'] as Map<String, dynamic>? ?? {},
      'Lips': data['Lips'] as Map<String, dynamic>? ?? {},
      'Jaw': data['Jaw'] as Map<String, dynamic>? ?? {},
      'VP Closure': data['VP Closure'] as Map<String, dynamic>? ?? {},
      'Vegetative Skills': data['Vegetative Skills'] as Map<String, dynamic>? ?? {},
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Structural Examination Section
        if (hasContent(structural))
          _buildSection(
            title: 'Structural Examination',
            color: Colors.blue.shade700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Normal Findings
                if (structural.entries.any((entry) => 
                    entry.value is Map<String, dynamic> && entry.value['status'] == 'normal'))
                  _buildSubsection(
                    title: 'Normal Findings',
                    color: Colors.blue.shade700,
                    content: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        '${getNormalItems(structural).join(', ')} found to be normal.',
                        style: TextStyle(
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ),

                // Abnormal Findings
                if (structural.entries.any((entry) => 
                    entry.value is Map<String, dynamic> && entry.value['status'] != 'normal'))
                  _buildSubsection(
                    title: 'Abnormalities',
                    color: Colors.blue.shade700,
                    content: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: structural.entries
                            .where((entry) => 
                                entry.value is Map<String, dynamic> && entry.value['status'] != 'normal')
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: _buildLabelValueRow(
                                    formatKey(entry.key),
                                    (entry.value['status'] as String?)?.substring(0, 1).toUpperCase() ?? '' +
                                        ((entry.value['status'] as String?) ?? '').substring(1),
                                    Colors.blue.shade700,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Functions Section
        if (functions.values.any((section) => section.isNotEmpty))
          _buildSection(
            title: 'Functions',
            color: Colors.blue.shade700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: functions.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .map((sectionEntry) {
                    final sectionName = sectionEntry.key;
                    final sectionData = sectionEntry.value;
                    final normalItems = getNormalItems(sectionData);
                    final abnormalItems = getAbnormalItems(sectionData);

                    return _buildSubsection(
                      title: sectionName,
                      color: Colors.blue.shade700,
                      content: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (normalItems.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '${normalItems.join(', ')} found to be normal.',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ...abnormalItems.entries.map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: _buildLabelValueRow(
                                    formatKey(entry.key),
                                    entry.value.toString(),
                                    Colors.blue.shade700,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),

        // Remarks Section
        if (data['remarks'] != null)
          _buildSection(
            title: 'Additional Remarks',
            color: Colors.blue.shade700,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                data['remarks'].toString(),
                style: const TextStyle(
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
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
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        content,
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLabelValueRow(String label, String value, Color labelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: labelColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}