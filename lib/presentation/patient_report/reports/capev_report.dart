import 'package:flutter/material.dart';
import 'dart:math' as math; // For math.max

// Define parameters structure (should ideally be shared/imported)
const List<Map<String, dynamic>> parametersConfig = [
  {'key': 'overallSeverity', 'label': 'Overall Severity'},
  {'key': 'roughness', 'label': 'Roughness'},
  {'key': 'breathiness', 'label': 'Breathiness'},
  {'key': 'strain', 'label': 'Strain'},
  {'key': 'pitch', 'label': 'Pitch', 'hasAbnormality': true},
  {'key': 'loudness', 'label': 'Loudness', 'hasAbnormality': true},
  // Default label if custom label not provided in data.customLabels
  {'key': 'additional1', 'label': 'Additional Parameter 1', 'isCustom': true},
  {'key': 'additional2', 'label': 'Additional Parameter 2', 'isCustom': true},
];

const Map<String, String> consistencyMap = {
  'C': 'Consistent',
  'I': 'Intermittent',
};

// Helper to format score display
String _formatScore(dynamic score) {
  if (score == null || score.toString().isEmpty) {
    return 'N/A';
  }
  final numScore = double.tryParse(score.toString());
  if (numScore == null) {
    return 'N/A';
  }
  return '${numScore.round()}/100';
}

// Helper to get the display label for a parameter
String _getParameterLabel(Map<String, dynamic> paramConfig, Map<String, dynamic>? customLabels) {
  if (paramConfig['isCustom'] == true &&
      customLabels != null &&
      customLabels[paramConfig['key']] != null &&
      (customLabels[paramConfig['key']] as String).isNotEmpty) {
    return customLabels[paramConfig['key']] as String;
  }
  return paramConfig['label'] as String;
}

class CapeVReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const CapeVReport({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ratings = data; // data itself contains parameter keys directly
    final customLabels = data['customLabels'] as Map<String, dynamic>? ?? {};
    final remarks = data['remarks'] as String? ?? '';

    final bool hasRatingData = parametersConfig.any((p) {
      final paramKey = p['key'] as String;
      final paramData = ratings[paramKey] as Map<String, dynamic>?;
      return paramData != null &&
          paramData['score'] != null &&
          paramData['score'].toString().isNotEmpty;
    });

    final overallSeverityData = ratings['overallSeverity'] as Map<String, dynamic>?;
    double overallSeverityScoreValue = 0;
    if (overallSeverityData?['score'] != null && overallSeverityData!['score'].toString().isNotEmpty) {
      overallSeverityScoreValue = double.tryParse(overallSeverityData['score'].toString()) ?? 0.0;
    }


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAPE-V Assessment Report',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Summary (Optional - showing Overall Severity)
          if (overallSeverityData != null && overallSeverityData['score'] != null && overallSeverityData['score'].toString().isNotEmpty)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Overall Severity:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(_formatScore(overallSeverityData['score'])),
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                          side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(consistencyMap[overallSeverityData['consistency']] ?? 'N/A'),
                           backgroundColor: Colors.grey[200],
                           labelStyle: TextStyle(color: Colors.grey[700]),
                           side: BorderSide(color: Colors.grey[400]!),
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (overallSeverityScoreValue > 0)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: math.max(0.0, math.min(1.0, overallSeverityScoreValue / 100.0)), // Ensure value is between 0.0 and 1.0
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // Detailed Parameters Section
          if (hasRatingData)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Parameters',
                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: parametersConfig.length,
                      itemBuilder: (context, index) {
                        final paramConfig = parametersConfig[index];
                        final paramKey = paramConfig['key'] as String;
                        final paramData = ratings[paramKey] as Map<String, dynamic>?;
                        final displayLabel = _getParameterLabel(paramConfig, customLabels);

                        // Skip rendering if it's a custom parameter with no custom label AND no score data
                        if (paramConfig['isCustom'] == true &&
                            (customLabels[paramKey] == null || customLabels[paramKey]!.isEmpty) &&
                            (paramData == null || paramData['score'] == null || paramData['score'].toString().isEmpty)) {
                          return const SizedBox.shrink();
                        }
                        // Also skip if regular param has no data at all
                        if (paramConfig['isCustom'] != true && paramData == null) {
                           return const SizedBox.shrink();
                        }
                        // Further refinement: only render if there's something to show (label exists or data exists)
                        if (displayLabel.isEmpty && (paramData == null || paramData['score'] == null || paramData['score'].toString().isEmpty)) {
                          return const SizedBox.shrink();
                        }


                        double scoreValue = 0;
                         bool hasValidScore = false;
                        if (paramData?['score'] != null && paramData!['score'].toString().isNotEmpty) {
                          final parsedScore = double.tryParse(paramData['score'].toString());
                          if(parsedScore != null) {
                            scoreValue = parsedScore;
                            hasValidScore = true;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: LayoutBuilder( // For responsive layout
                            builder: (context, constraints) {
                              bool isSmallScreen = constraints.maxWidth < 600; // Breakpoint

                              if (isSmallScreen) {
                                // Column layout for small screens
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildParameterLabelAbnormality(context, displayLabel, paramConfig, paramData),
                                    const SizedBox(height: 8),
                                    _buildScoreVisualization(context, hasValidScore, scoreValue, paramData),
                                    const SizedBox(height: 8),
                                    _buildConsistencyChip(context, paramData),
                                  ],
                                );
                              } else {
                                // Row layout for larger screens
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3, // Approx 30%
                                      child: _buildParameterLabelAbnormality(context, displayLabel, paramConfig, paramData),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 5, // Approx 50% (45% + room for score text)
                                      child: _buildScoreVisualization(context, hasValidScore, scoreValue, paramData),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2, // Approx 20%
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: _buildConsistencyChip(context, paramData),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        // Add divider only if the next item is likely to be rendered
                        final nextParamConfig = (index + 1 < parametersConfig.length) ? parametersConfig[index+1] : null;
                        if (nextParamConfig != null) {
                           final nextParamKey = nextParamConfig['key'] as String;
                           final nextParamData = ratings[nextParamKey] as Map<String, dynamic>?;
                           final nextDisplayLabel = _getParameterLabel(nextParamConfig, customLabels);
                           if (nextParamConfig['isCustom'] == true &&
                            (customLabels[nextParamKey] == null || customLabels[nextParamKey]!.isEmpty) &&
                            (nextParamData == null || nextParamData['score'] == null || nextParamData['score'].toString().isEmpty)) {
                                return const SizedBox.shrink();
                            }
                            if (nextParamConfig['isCustom'] != true && nextParamData == null) {
                                return const SizedBox.shrink();
                            }
                            if (nextDisplayLabel.isEmpty && (nextParamData == null || nextParamData['score'] == null || nextParamData['score'].toString().isEmpty)) {
                                return const SizedBox.shrink();
                            }
                           return const Divider(height: 1, thickness: 1);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),

          // Remarks Section
          if (remarks.isNotEmpty)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Remarks',
                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600
                          ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: Colors.grey[300]!)
                      ),
                      child: Text(
                        remarks,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Fallback if no data at all
          if (!hasRatingData && remarks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  'No CAPE-V data available for this report.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParameterLabelAbnormality(BuildContext context, String displayLabel, Map<String, dynamic> paramConfig, Map<String, dynamic>? paramData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (displayLabel.isNotEmpty)
          Text(
            displayLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        if (paramConfig['hasAbnormality'] == true &&
            paramData?['abnormality'] != null &&
            (paramData!['abnormality'] as String).isNotEmpty) ...[
              if(displayLabel.isNotEmpty) const SizedBox(height: 2),
              Text(
                'Abnormality: ${paramData['abnormality']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
              ),
        ]
      ],
    );
  }

  Widget _buildScoreVisualization(BuildContext context, bool hasValidScore, double scoreValue, Map<String, dynamic>? paramData) {
    return Row(
      children: [
        Expanded(
          child: hasValidScore
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: math.max(0.0, math.min(1.0, scoreValue / 100.0)),
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                  ),
                )
              : Text(
                  'No score',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 55, // minWidth for score text
          child: Text(
            _formatScore(paramData?['score']),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildConsistencyChip(BuildContext context, Map<String, dynamic>? paramData) {
    return Chip(
      label: Text(consistencyMap[paramData?['consistency']] ?? 'N/A'),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 12),
      side: BorderSide(color: Colors.grey[400]!),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}


