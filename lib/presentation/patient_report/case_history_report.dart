import 'package:flutter/material.dart';
import 'common_widgets.dart';

class CaseHistoryReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const CaseHistoryReport({Key? key, required this.data}) : super(key: key);

  List<String> formatMedicalHistory(Map<String, dynamic>? history) {
    if (history == null) return ["No significant medical history"];

    final items = <String>[];
    
    history.forEach((key, value) {
      if (value == true && key != 'other') {
        items.add(key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim());
      }
    });
    
    if (history.containsKey('other') && history['other'] != null && history['other'] != false) {
      items.add(history['other'].toString());
    }
    
    return items.isNotEmpty ? items : ["No significant medical history"];
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = data['basicInfo'] ?? {};
    final concerns = data['concerns'] ?? {};
    final medicalHistory = data['medicalHistory'] ?? {};
    final developmentalHistory = data['developmentalHistory'] ?? {};
    final languageDevelopment = data['languageDevelopment'] ?? {};
    final recommendations = data['recommendations'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information Section
        ReportSection(
          title: 'Basic Information',
          icon: const Icon(Icons.person, color: Colors.white),
          headerColor: Colors.teal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (basicInfo['caseName'] != null)
                              LabeledField(label: 'Name', value: basicInfo['caseName'] ?? 'N/A'),
                            if (basicInfo['registrationNo'] != null)
                              LabeledField(label: 'Registration No', value: basicInfo['registrationNo'] ?? 'N/A'),
                            if (basicInfo['date'] != null)
                              LabeledField(label: 'Date', value: basicInfo['date'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.teal.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (basicInfo['ageSexDOB'] != null)
                              LabeledField(label: 'Age/Sex/DOB', value: basicInfo['ageSexDOB'] ?? 'N/A'),
                            if (basicInfo['informant'] != null)
                              LabeledField(label: 'Informant', value: basicInfo['informant'] ?? 'N/A'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Parents' Concerns Section
        ReportSection(
          title: 'Parents\' Concerns',
          icon: const Icon(Icons.priority_high, color: Colors.white),
          headerColor: Colors.deepOrange,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...concerns.entries.where((entry) => 
                entry.value == true || (entry.key == 'other' && entry.value != null && entry.value is String)
              ).map((entry) {
                final label = entry.key == 'other' 
                  ? entry.value.toString() 
                  : entry.key.substring(0, 1).toUpperCase() + entry.key.substring(1);
                
                return StatusChip(
                  label: label,
                  activeColor: Colors.deepOrange,
                );
              }),
              if (concerns.entries.where((entry) => 
                entry.value == true || (entry.key == 'other' && entry.value != null && entry.value is String)
              ).isEmpty)
                const Text('No concerns reported'),
            ],
          ),
        ),

        // Medical History Section
        ReportSection(
          title: 'Medical History',
          icon: const Icon(Icons.medical_services, color: Colors.white),
          headerColor: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pre-natal
              ReportSubSection(
                title: 'Pre-natal',
                titleColor: Colors.blue,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: formatMedicalHistory(
                        medicalHistory['prenatal'] as Map<String, dynamic>?
                      ).map((item) => BulletPoint(text: item, bulletColor: Colors.blue)).toList(),
                    ),
                  ),
                ),
              ),
              
              // Peri-natal
              ReportSubSection(
                title: 'Peri-natal',
                titleColor: Colors.blue,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (medicalHistory['perinatal'] != null) ...[
                          LabeledField(
                            label: 'Delivery',
                            value: medicalHistory['perinatal']['delivery'] ?? 'N/A',
                          ),
                          LabeledField(
                            label: 'Place',
                            value: medicalHistory['perinatal']['deliveryPlace'] ?? 'N/A',
                          ),
                          LabeledField(
                            label: 'Type',
                            value: medicalHistory['perinatal']['deliveryType'] ?? 'N/A',
                          ),
                          LabeledField(
                            label: 'Birth Cry',
                            value: medicalHistory['perinatal']['birthCry'] ?? 'N/A',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              
              // Post-natal
              ReportSubSection(
                title: 'Post-natal',
                titleColor: Colors.blue,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.blue.shade100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: formatMedicalHistory(
                        medicalHistory['postnatal'] as Map<String, dynamic>?
                      ).map((item) => BulletPoint(text: item, bulletColor: Colors.blue)).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Development Section
        ReportSection(
          title: 'Development',
          icon: const Icon(Icons.child_care, color: Colors.white),
          headerColor: Colors.purple,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Developmental Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Developmental Status',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.purple.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledField(
                              label: 'Status',
                              value: developmentalHistory['status'] ?? 'N/A',
                            ),
                            const Divider(),
                            if (developmentalHistory['milestones'] != null) ...[
                              ...(developmentalHistory['milestones'] as Map<String, dynamic>).entries.map(
                                (entry) => LabeledField(
                                  label: entry.key.substring(0, 1).toUpperCase() + entry.key.substring(1),
                                  value: entry.value?.toString() ?? 'N/A',
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
              const SizedBox(width: 16),
              // Language Development
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Language Development',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.purple.shade100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledField(
                              label: 'Status',
                              value: languageDevelopment['status'] ?? 'N/A',
                            ),
                            const Divider(),
                            ...(languageDevelopment as Map<String, dynamic>)
                              .entries
                              .where((entry) => entry.key != 'status')
                              .map(
                                (entry) => LabeledField(
                                  label: entry.key.substring(0, 1).toUpperCase() + entry.key.substring(1),
                                  value: entry.value?.toString() ?? 'N/A',
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Recommendations Section
        ReportSection(
          title: 'Recommendations',
          icon: const Icon(Icons.recommend, color: Colors.white),
          headerColor: Colors.green,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...recommendations.entries.where((entry) => 
                entry.value == true || (entry.key == 'additional' && entry.value != null && entry.value is String)
              ).map((entry) {
                final label = entry.key == 'additional' 
                  ? entry.value.toString() 
                  : entry.key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
                
                return StatusChip(
                  label: label,
                  activeColor: Colors.green,
                );
              }),
              if (recommendations.entries.where((entry) => 
                entry.value == true || (entry.key == 'additional' && entry.value != null && entry.value is String)
              ).isEmpty)
                const Text('No recommendations provided'),
            ],
          ),
        ),
      ],
    );
  }
}