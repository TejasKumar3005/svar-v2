import 'package:flutter/material.dart';
import 'common_widgets.dart';

class VoiceReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const VoiceReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Voice Parameters
        ReportSection(
          title: 'Basic Voice Parameters',
          icon: const Icon(Icons.mic, color: Colors.white),
          headerColor: Colors.blueGrey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Respiratory Pattern
                _VoiceParameter(
                  label: 'Respiratory Pattern',
                  value: data['respiratoryPattern']?['status'] ?? 'N/A',
                ),
                
                const SizedBox(height: 16),
                
                // Voice Quality
                _VoiceParameter(
                  label: 'Voice Quality',
                  value: data['voiceQuality']?['status'] ?? 'N/A',
                ),
                
                const SizedBox(height: 16),
                
                // Resonance
                _VoiceParameter(
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
                        .map((feature) => StatusChip(
                              label: feature.toString(),
                              activeColor: Colors.blueGrey,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Voice Measurements
        ReportSection(
          title: 'Voice Measurements',
          icon: const Icon(Icons.equalizer, color: Colors.white),
          headerColor: Colors.blueGrey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Maximum Phonation Time
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                ),
              ),
              const SizedBox(width: 16),
              // S/Z Ratio
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                        child: Text(
                          data['szRatio']?.toString() ?? '—',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // GRBAS Scale
        if (data['grbas'] != null)
          ReportSection(
            title: 'GRBASI Scale',
            icon: const Icon(Icons.assessment, color: Colors.white),
            headerColor: Colors.blueGrey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.spaceAround,
                    children: (data['grbas'] as Map<String, dynamic>)
                        .entries
                        .where((entry) => entry.key != 'range')
                        .map((entry) => SizedBox(
                              width: 80, // Fixed width for uniform appearance
                              child: Column(
                                children: [
                                  Text(
                                    entry.key.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueGrey.shade100,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      entry.value.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),

        // CAPE-V Summary
        if (data['capev'] != null)
          ReportSection(
            title: 'CAPE-V Assessment',
            icon: const Icon(Icons.list_alt, color: Colors.white),
            headerColor: Colors.blueGrey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
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
          ReportSection(
            title: 'Additional Remarks',
            icon: const Icon(Icons.comment, color: Colors.white),
            headerColor: Colors.blueGrey,
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

class _VoiceParameter extends StatelessWidget {
  final String label;
  final String value;

  const _VoiceParameter({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}