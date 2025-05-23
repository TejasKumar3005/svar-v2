import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CaseHistoryReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const CaseHistoryReport({Key? key, required this.data}) : super(key: key);

  List<String> formatMedicalHistory(Map<String, dynamic>? history) {
    if (history == null) return ["No significant medical history"];

    final items = <String>[];

    history.forEach((key, value) {
      if (value == true && key != 'other') {
        items.add(key
            .replaceAllMapped(
                RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
            .trim());
      }
    });

    if (history.containsKey('other') &&
        history['other'] != null &&
        history['other'] != false) {
      items.add(history['other'].toString());
    }

    return items.isNotEmpty ? items : ["No significant medical history"];
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = data['basicInfo'] ?? {};
    final concerns = data['concerns'] ?? {};
    final medicalHistory = data['medicalHistory'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        _buildSection(
          title: 'Basic Information',
          color: Color(0xFF1cb0f6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
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
                      if (basicInfo['caseName'] != null &&
                          basicInfo['caseName'].toString().isNotEmpty)
                        _buildLabeledField('Name', basicInfo['caseName']),
                      if (basicInfo['registrationNo'] != null &&
                          basicInfo['registrationNo'].toString().isNotEmpty)
                        _buildLabeledField(
                            'Registration No', basicInfo['registrationNo']),
                      if (basicInfo['date'] != null &&
                          basicInfo['date'].toString().isNotEmpty)
                        _buildLabeledField('Date', basicInfo['date']),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right column
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
                      if (basicInfo['ageSexDOB'] != null &&
                          basicInfo['ageSexDOB'].toString().isNotEmpty)
                        _buildLabeledField(
                            'Age/Sex/DOB', basicInfo['ageSexDOB']),
                      if (basicInfo['informant'] != null &&
                          basicInfo['informant'].toString().isNotEmpty)
                        _buildLabeledField('Informant', basicInfo['informant']),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Parents' Concerns Section
        if (_hasNonEmptyValues(concerns))
          _buildSection(
            title: 'Parents\' Concerns',
            color: Color(0xFF1cb0f6),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._getConcerns(concerns).map((concern) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF1cb0f6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Color(0xFF1cb0f6)),
                      ),
                      child: Text(
                        concern,
                        style: GoogleFonts.inter(
                          color: Color(0xFF1cb0f6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
              ],
            ),
          ),

        // Medical History Section
        if (_hasNonEmptyValues(medicalHistory))
          _buildSection(
            title: 'Medical History',
            color: Color(0xFF1cb0f6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pre-natal
                if (medicalHistory.containsKey('prenatal') &&
                    _hasNonEmptyValues(medicalHistory['prenatal']))
                  _buildMedicalSubsection(
                      'Pre-natal', medicalHistory['prenatal']),

                // Peri-natal
                if (medicalHistory.containsKey('perinatal') &&
                    _hasNonEmptyValues(medicalHistory['perinatal']))
                  _buildMedicalSubsection(
                      'Peri-natal', medicalHistory['perinatal']),

                // Post-natal
                if (medicalHistory.containsKey('postnatal') &&
                    _hasNonEmptyValues(medicalHistory['postnatal']))
                  _buildMedicalSubsection(
                      'Post-natal', medicalHistory['postnatal']),
              ],
            ),
          ),
      ],
    );
  }

  List<String> _getConcerns(Map<String, dynamic> concerns) {
    final List<String> result = [];
    concerns.forEach((key, value) {
      if (value == true ||
          (key == 'other' && value != null && value.toString().isNotEmpty)) {
        result.add(key.substring(0, 1).toUpperCase() + key.substring(1));
      }
    });
    return result;
  }

  bool _hasNonEmptyValues(Map<String, dynamic>? data) {
    if (data == null) return false;
    for (final entry in data.entries) {
      if (entry.value == true ||
          (entry.value != null && entry.value.toString().isNotEmpty)) {
        return true;
      }
    }
    return false;
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
                Icons.info_outline,
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

  Widget _buildMedicalSubsection(String title, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1cb0f6),
            ),
          ),
        ),
        Container(
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
              for (final entry in data.entries)
                if (entry.value == true ||
                    (entry.value != null && entry.value.toString().isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildLabeledField(
                      _formatKey(entry.key),
                      entry.value is bool
                          ? (entry.value ? 'Yes' : 'No')
                          : entry.value.toString(),
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatKey(String key) {
    // Handle special keys
    if (key == 'deliveryPlace') return 'Place';
    if (key == 'deliveryType') return 'Type';
    if (key == 'birthCry') return 'Birth Cry';
    if (key == 'birthAsphyxia') return 'Birth Asphyxia';
    if (key == 'delivery') return 'Delivery';

    // Regular formatting
    return key.substring(0, 1).toUpperCase() + key.substring(1);
  }

  Widget _buildLabeledField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: GoogleFonts.inter(
                color: Color(0xFF1cb0f6),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.inter(
                color: Color(0xFF4b4b4b),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
