import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';

class CompleteReportView extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const CompleteReportView({Key? key, required this.reportData}) : super(key: key);

  String formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Check if a map or object has any non-empty values
  bool hasNonEmptyValues(dynamic obj) {
    if (obj == null) return false;
    if (obj is Map) {
      for (var value in obj.values) {
        if (value != null && value.toString().isNotEmpty && value != false) {
          return true;
        }
      }
      return false;
    }
    return obj.toString().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // Date from the report data
    final String reportDate = reportData.containsKey('date') ? reportData['date'] : '';
    
    // Extract patient name from case history if available
    String patientName = '';
    if (reportData.containsKey('Case_history') && 
        reportData['Case_history'] != null && 
        reportData['Case_history'].isNotEmpty &&
        reportData['Case_history'][0] != null &&
        reportData['Case_history'][0]['basicInfo'] != null &&
        reportData['Case_history'][0]['basicInfo']['caseName'] != null) {
      patientName = reportData['Case_history'][0]['basicInfo']['caseName'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Report header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Text(
                  'Comprehensive Assessment Report',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (patientName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Patient: $patientName',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (reportDate.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    formatDate(reportDate),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Basic Information Section
        if (reportData.containsKey('Case_history') && 
            reportData['Case_history'] != null && 
            reportData['Case_history'].isNotEmpty &&
            reportData['Case_history'][0] != null &&
            reportData['Case_history'][0]['basicInfo'] != null) 
          _buildBasicInfoSection(reportData['Case_history'][0]['basicInfo']),

        // Parents' Concerns Section
        if (reportData.containsKey('Case_history') && 
            reportData['Case_history'] != null && 
            reportData['Case_history'].isNotEmpty &&
            reportData['Case_history'][0] != null &&
            reportData['Case_history'][0]['concerns'] != null) 
          _buildConcernsSection(reportData['Case_history'][0]['concerns']),

        // Medical History Section
        if (reportData.containsKey('Case_history') && 
            reportData['Case_history'] != null && 
            reportData['Case_history'].isNotEmpty &&
            reportData['Case_history'][0] != null &&
            reportData['Case_history'][0]['medicalHistory'] != null) 
          _buildMedicalHistorySection(reportData['Case_history'][0]['medicalHistory']),

        // Development Section
        if (reportData.containsKey('Case_history') && 
            reportData['Case_history'] != null && 
            reportData['Case_history'].isNotEmpty &&
            reportData['Case_history'][0] != null &&
            (hasNonEmptyValues(reportData['Case_history'][0]['developmentalHistory']) || 
             hasNonEmptyValues(reportData['Case_history'][0]['languageDevelopment']))) 
          _buildDevelopmentSection(
            reportData['Case_history'][0]['developmentalHistory'],
            reportData['Case_history'][0]['languageDevelopment'],
          ),

        // Recommendations Section
        if (reportData.containsKey('Case_history') && 
            reportData['Case_history'] != null && 
            reportData['Case_history'].isNotEmpty &&
            reportData['Case_history'][0] != null &&
            reportData['Case_history'][0]['recommendations'] != null) 
          _buildRecommendationsSection(reportData['Case_history'][0]['recommendations']),

        // End of Report
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'End of Report',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Generated on ${DateTime.now().toString().substring(0, 10)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(Map<String, dynamic> basicInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Basic Information',
          icon: Icons.person,
          color: AppTheme.basicInfoColor,
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (basicInfo['caseName'] != null && basicInfo['caseName'].toString().isNotEmpty)
                _buildLabelValuePair('Name', basicInfo['caseName']),
              if (basicInfo['registrationNo'] != null && basicInfo['registrationNo'].toString().isNotEmpty)
                _buildLabelValuePair('Registration No', basicInfo['registrationNo']),
              if (basicInfo['date'] != null && basicInfo['date'].toString().isNotEmpty)
                _buildLabelValuePair('Date', basicInfo['date']),
              if (basicInfo['ageSexDOB'] != null && basicInfo['ageSexDOB'].toString().isNotEmpty)
                _buildLabelValuePair('Age/Sex/DOB', basicInfo['ageSexDOB']),
              if (basicInfo['informant'] != null && basicInfo['informant'].toString().isNotEmpty)
                _buildLabelValuePair('Informant', basicInfo['informant']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConcernsSection(Map<String, dynamic> concerns) {
    // Get active concerns
    List<String> activeConcerns = [];
    
    concerns.forEach((key, value) {
      if ((value == true) || (key == 'other' && value != null && value is String && value.isNotEmpty)) {
        activeConcerns.add(key == 'other' ? value : key);
      }
    });

    if (activeConcerns.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Parents\' Concerns',
          icon: Icons.warning,
          color: AppTheme.concernsColor,
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: activeConcerns.map((concern) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.concernsColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  concern.substring(0, 1).toUpperCase() + concern.substring(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalHistorySection(Map<String, dynamic> medicalHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Medical History',
          icon: Icons.medical_services,
          color: AppTheme.medicalHistoryColor,
        ),
        
        // Subsections
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (medicalHistory['prenatal'] != null)
                _buildMedicalSubsection('Pre-natal', medicalHistory['prenatal']),
              
              if (medicalHistory['perinatal'] != null)
                _buildMedicalSubsection('Peri-natal', medicalHistory['perinatal']),
              
              if (medicalHistory['postnatal'] != null)
                _buildMedicalSubsection('Post-natal', medicalHistory['postnatal']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDevelopmentSection(Map<String, dynamic>? developmentalHistory, Map<String, dynamic>? languageDevelopment) {
    if ((developmentalHistory == null || !hasNonEmptyValues(developmentalHistory)) && 
        (languageDevelopment == null || !hasNonEmptyValues(languageDevelopment))) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Development',
          icon: Icons.child_care,
          color: AppTheme.developmentColor,
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column - Developmental Status
              if (developmentalHistory != null && hasNonEmptyValues(developmentalHistory))
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          'Developmental Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.developmentColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildDevelopmentalStatusItems(developmentalHistory),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(width: 12),
              
              // Right column - Language Development
              if (languageDevelopment != null && hasNonEmptyValues(languageDevelopment))
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          'Language Development',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.developmentColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildLanguageDevelopmentItems(languageDevelopment),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDevelopmentalStatusItems(Map<String, dynamic> developmentalHistory) {
    List<Widget> items = [];
    
    if (developmentalHistory['status'] != null && developmentalHistory['status'].toString().isNotEmpty) {
      items.add(_buildLabelValuePair('Status', developmentalHistory['status']));
    }
    
    if (developmentalHistory['milestones'] != null) {
      final milestones = developmentalHistory['milestones'] as Map<String, dynamic>;
      
      milestones.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          String label = key;
          if (key == 'neckControl') label = 'NeckControl';
          else label = key.substring(0, 1).toUpperCase() + key.substring(1);
          items.add(_buildLabelValuePair(label, value.toString()));
        }
      });
    }
    
    return items;
  }

  List<Widget> _buildLanguageDevelopmentItems(Map<String, dynamic> languageDevelopment) {
    List<Widget> items = [];
    
    languageDevelopment.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        String label = key.substring(0, 1).toUpperCase() + key.substring(1);
        if (key == 'firstWord') label = 'FirstWord';
        items.add(_buildLabelValuePair(label, value.toString()));
      }
    });
    
    return items;
  }

  Widget _buildRecommendationsSection(Map<String, dynamic> recommendations) {
    // Get active recommendations
    List<String> activeRecommendations = [];
    
    recommendations.forEach((key, value) {
      if ((value == true) || (key == 'additional' && value != null && value is String && value.isNotEmpty)) {
        String text = key == 'additional' 
          ? value 
          : key.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
        
        activeRecommendations.add(text);
      }
    });

    if (activeRecommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Recommendations',
          icon: Icons.recommend,
          color: AppTheme.recommendationsColor,
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: activeRecommendations.map((rec) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.recommendationsColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  rec.substring(0, 1).toUpperCase() + rec.substring(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalSubsection(String title, dynamic data) {
    if (!hasNonEmptyValues(data)) return const SizedBox.shrink();
    
    List<Widget> items = [];
    
    if (data is Map<String, dynamic>) {
      data.forEach((key, value) {
        if (value != null && (value == true || value.toString().isNotEmpty)) {
          String label = key.substring(0, 1).toUpperCase() + key.substring(1);
          
          if (key == 'deliveryPlace') label = 'DeliveryPlace';
          else if (key == 'deliveryType') label = 'DeliveryType';
          else if (key == 'birthAsphyxia') label = 'BirthAsphyxia';
          
          items.add(_buildLabelValuePair(
            label, 
            value is bool ? 'Yes' : value.toString()
          ));
        }
      });
    }
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.medicalHistoryColor,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValuePair(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: AppTheme.labelColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}