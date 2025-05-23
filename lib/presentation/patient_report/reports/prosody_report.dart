import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Map.fromEntries(data.entries.where((entry) =>
        entry.value is Map<String, dynamic> &&
        entry.value['status'] == 'affected' &&
        entry.key != 'abnormalityDetails'));
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
          _buildSection(
            title: 'Normal Parameters',
            color: Color(0xFF1cb0f6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The following parameters were found to be normal:',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: normalParameters
                        .map((param) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Text(
                                param,
                                style: GoogleFonts.inter(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

        // Affected Parameters Section
        if (affectedParameters.isNotEmpty)
          _buildSection(
            title: 'Affected Parameters',
            color: Color(0xFF1cb0f6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
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
                                color: Color(0xFF1cb0f6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$paramName: ',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF4b4b4b),
                              ),
                            ),
                            Text(
                              paramData['status'] ?? 'N/A',
                              style: GoogleFonts.inter(
                                color: Color(0xFF1cb0f6),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (paramData['details'] != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                paramData['details'],
                                style: GoogleFonts.inter(
                                  color: Color(0xFF4b4b4b),
                                  fontSize: 14,
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
          _buildSection(
            title: 'Additional Details',
            color: Color(0xFF1cb0f6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                data['abnormalityDetails'],
                style: GoogleFonts.inter(
                  height: 1.5,
                  fontSize: 14,
                  color: Color(0xFF4b4b4b),
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
          child: Row(
            children: [
              Icon(
                Icons.volume_up_outlined,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b4b4b),
                ),
              ),
            ],
          ),
        ),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}
