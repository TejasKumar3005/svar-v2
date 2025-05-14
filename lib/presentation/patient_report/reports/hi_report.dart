import 'package:flutter/material.dart';

/// A Flutter implementation of the Integrated Scale of Development Report
/// Converted from React/Material-UI to Flutter

// Define scale labels - matches the original React component's configuration
final Map<String, String> scaleLabels = {
  'listening': 'Listening (Audition)',
  'receptive': 'Receptive Language',
  'expressive': 'Expressive Language',
  'speech': 'Speech',
  'cognition': 'Cognition',
  'socialCommunication': 'Social Communication (Pragmatics)'
};

// Helper to format the score display
String formatScoreDisplay(dynamic scoreValue) {
  // Handle empty, null, or undefined scores
  if (scoreValue == null || scoreValue == '') {
    return 'N/A'; // Not Available / Not Assessed
  }
  
  // Convert to number if it's a string
  num? numScore;
  if (scoreValue is String) {
    numScore = num.tryParse(scoreValue);
  } else if (scoreValue is num) {
    numScore = scoreValue;
  }
  
  // Check if conversion failed or resulted in NaN
  if (numScore == null) {
    return 'Invalid'; // Indicates non-numeric input was saved
  }
  
  // Basic check for plausible age range
  if (numScore < 0) {
    return 'Invalid';
  }
  
  // Format valid number
  return '${numScore} months';
}
// Main widget for the Integrated Scale of Development Report
class HiReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const HiReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract remarks from data
    final String remarks = data['remarks'] ?? '';

    // Filter out remarks and any unexpected keys to get only scale data
    final Map<String, dynamic> scaleData = Map.fromEntries(
      data.entries.where((entry) => 
        entry.key != 'remarks' && scaleLabels.containsKey(entry.key)
      )
    );

    // Check if there is any actual scale data to display
    final bool hasScaleData = scaleData.values.any(
      (value) => value != null && value != ''
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Integrated Scale of Development Report',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Developmental Levels Section
        if (hasScaleData)
          Card(
            margin: const EdgeInsets.only(bottom: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developmental Levels',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  ...scaleLabels.entries.toList().asMap().entries.map((entry) {
                    final int index = entry.key;
                    final MapEntry<String, String> scaleEntry = entry.value;
                    final String key = scaleEntry.key;
                    final String label = scaleEntry.value;
                    
                    final dynamic scoreValue = scaleData[key];
                    final String displayScore = formatScoreDisplay(scoreValue);

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  label,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 90.0,
                                child: Text(
                                  displayScore,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Add divider if not the last item
                        if (index < scaleLabels.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          )
        else
          // Show message if no scale data, but remarks might still exist
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            child: Text(
              'No developmental scale data recorded.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

        // Remarks Section
        if (remarks.isNotEmpty)
          Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Remarks',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Card(
                    margin: EdgeInsets.zero,
                    color: Colors.grey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        remarks,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Fallback message if absolutely no data (neither scales nor remarks)
        if (!hasScaleData && remarks.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'No Integrated Scales data available for this report.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }
}
