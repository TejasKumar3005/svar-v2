import 'package:flutter/material.dart';
import 'common_widgets.dart';

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
        if (structural.isNotEmpty)
          ReportSection(
            title: 'Structural Examination',
            icon: const Icon(Icons.biotech, color: Colors.white),
            headerColor: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Normal Findings
                if (structural.entries.any((entry) => 
                    entry.value is Map<String, dynamic> && entry.value['status'] == 'normal'))
                  ReportSubSection(
                    title: 'Normal Findings',
                    titleColor: Colors.blue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
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
                  ReportSubSection(
                    title: 'Abnormalities',
                    titleColor: Colors.blue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: structural.entries
                            .where((entry) => 
                                entry.value is Map<String, dynamic> && entry.value['status'] != 'normal')
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${formatKey(entry.key)}: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          (entry.value['status'] as String?)?.substring(0, 1).toUpperCase() ?? '' +
((entry.value['status'] as String?)?.substring(1) ?? '').toString(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
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
          ReportSection(
            title: 'Functions',
            icon: const Icon(Icons.accessibility_new, color: Colors.white),
            headerColor: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: functions.entries
                  .where((entry) => entry.value.isNotEmpty)
                  .map((sectionEntry) {
                    final sectionName = sectionEntry.key;
                    final sectionData = sectionEntry.value;
                    final normalItems = getNormalItems(sectionData);
                    final abnormalItems = getAbnormalItems(sectionData);

                    return ReportSubSection(
                      title: sectionName,
                      titleColor: Colors.blue,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${formatKey(entry.key)}: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          entry.value.toString(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
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
          ReportSection(
            title: 'Additional Remarks',
            icon: const Icon(Icons.comment, color: Colors.white),
            headerColor: Colors.blue,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
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
}