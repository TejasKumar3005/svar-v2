import 'package:flutter/material.dart';
import 'common_widgets.dart';

class ProsodyReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProsodyReport({Key? key, required this.data}) : super(key: key);

  // Get normal parameters
  List<String> getNormalParameters() {
    return data.entries
        .where((entry) => 
            entry.value is Map<String, dynamic> && 
            entry.value['status'] == 'normal' && 
            entry.key != 'abnormalityDetails')
        .map((entry) => entry.key)
        .toList();
  }

  // Get affected parameters
  Map<String, dynamic> getAffectedParameters() {
    return Map.fromEntries(
      data.entries.where((entry) => 
          entry.value is Map<String, dynamic> && 
          entry.value['status'] == 'affected' && 
          entry.key != 'abnormalityDetails')
    );
  }

  @override
  Widget build(BuildContext context) {
    final normalParameters = getNormalParameters();
    final affectedParameters = getAffectedParameters();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Normal Parameters Section
        if (normalParameters.isNotEmpty)
          ReportSection(
            title: 'Normal Parameters',
            icon: const Icon(Icons.check_circle, color: Colors.white),
            headerColor: Colors.amber.shade800,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The following parameters were found to be normal:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: normalParameters.map((param) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        param,
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

        // Affected Parameters Section
        if (affectedParameters.isNotEmpty)
          ReportSection(
            title: 'Affected Parameters',
            icon: const Icon(Icons.warning, color: Colors.white),
            headerColor: Colors.amber.shade800,
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
                children: affectedParameters.entries.map((entry) {
                  final paramName = entry.key;
                  final paramData = entry.value as Map<String, dynamic>;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.amber.shade700,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$paramName: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              paramData['status'] ?? 'N/A',
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (paramData['details'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                paramData['details'],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

        // Additional Details Section
        if (data['abnormalityDetails'] != null)
          ReportSection(
            title: 'Additional Details',
            icon: const Icon(Icons.description, color: Colors.white),
            headerColor: Colors.amber.shade800,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                data['abnormalityDetails'],
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