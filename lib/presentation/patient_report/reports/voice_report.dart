import 'package:flutter/material.dart';

class VoiceReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const VoiceReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Voice Parameters
        _buildSection(
          title: 'Basic Voice Parameters',
          color: Colors.blueGrey.shade700,
          child: Container(
            width: double.infinity, // Full width container
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Respiratory Pattern
                _buildVoiceParameter(
                  label: 'Respiratory Pattern',
                  value: data['respiratoryPattern']?['status'] ?? 'N/A',
                ),
                
                const SizedBox(height: 16),
                
                // Voice Quality
                _buildVoiceParameter(
                  label: 'Voice Quality',
                  value: data['voiceQuality']?['status'] ?? 'N/A',
                ),
                
                const SizedBox(height: 16),
                
                // Resonance
                _buildVoiceParameter(
                  label: 'Resonance',
                  value: data['resonance']?['status'] ?? 'N/A',
                ),
                
                // Additional Features
                if (data['additionalVoiceFeatures'] != null &&
                    data['additionalVoiceFeatures']['status'] is List &&
                    (data['additionalVoiceFeatures']['status'] as List).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Additional Features:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (data['additionalVoiceFeatures']['status'] as List)
                        .map((feature) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.blueGrey.shade200),
                              ),
                              child: Text(
                                feature.toString(),
                                style: TextStyle(
                                  color: Colors.blueGrey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Voice Measurements
        _buildSection(
          title: 'Voice Measurements',
          color: Colors.blueGrey.shade700,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // For smaller screens, use column layout
              if (constraints.maxWidth < 500) {
                return Column(
                  children: [
                    _buildMaxPhonationTime(),
                    const SizedBox(height: 16),
                    _buildSZRatio(),
                  ],
                );
              } else {
                // For larger screens, use row layout
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Maximum Phonation Time
                    Expanded(
                      flex: 3,
                      child: _buildMaxPhonationTime(),
                    ),
                    const SizedBox(width: 16),
                    // S/Z Ratio
                    Expanded(
                      flex: 2,
                      child: _buildSZRatio(),
                    ),
                  ],
                );
              }
            },
          ),
        ),

        // GRBAS Scale
        if (data['grbas'] != null)
          _buildSection(
            title: 'GRBASI Scale',
            color: Colors.blueGrey.shade700,
            child: Container(
              width: double.infinity, // Full width
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Wrap(
                spacing: 20, // Increased spacing
                runSpacing: 20, // Increased spacing
                alignment: WrapAlignment.spaceAround,
                children: (data['grbas'] as Map<String, dynamic>)
                    .entries
                    .where((entry) => entry.key != 'range')
                    .map((entry) => SizedBox(
                          width: 95, // Increased width for uniformity
                          child: Column(
                            children: [
                              Text(
                                entry.key.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 50, // Slightly larger circles
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueGrey.shade100,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  entry.value.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // Larger font
                                    color: Colors.blueGrey.shade800,
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

        // CAPE-V Summary
        if (data['capev'] != null)
          _buildSection(
            title: 'CAPE-V Assessment',
            color: Colors.blueGrey.shade700,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: (data['capev'] as Map<String, dynamic>)
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

        // Remarks Section
        if (data['remarks'] != null)
          _buildSection(
            title: 'Additional Remarks',
            color: Colors.blueGrey.shade700,
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

  // Extracted Maximum Phonation Time widget for better organization
  Widget _buildMaxPhonationTime() {
    return Container(
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
          Text(
            'Maximum Phonation Time (seconds)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          if (data['maximumPhonationTime'] != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: (data['maximumPhonationTime'] as Map<String, dynamic>)
                  .entries
                  .map((entry) => Column(
                        children: [
                          Text(
                            '/${entry.key}/',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.value?.toString() ?? '—',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            )
          else
            const Center(
              child: Text('No data available'),
            ),
        ],
      ),
    );
  }

  // Extracted S/Z Ratio widget for better organization and improved display
  Widget _buildSZRatio() {
    return Container(
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
          Text(
            's/z Ratio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                // Format the output to make it cleaner
                data['szRatio'] != null && data['szRatio'] is num
                    ? data['szRatio'].toString()
                    : data['szRatio']?.toString().replaceAll('{status:', '').replaceAll('}', '') ?? '—',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
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

Widget _buildVoiceParameter({
  required String label,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
}