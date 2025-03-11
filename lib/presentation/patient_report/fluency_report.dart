import 'package:flutter/material.dart';
import 'common_widgets.dart';

class FluencyReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const FluencyReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rate of Speech Section
        ReportSection(
          title: 'Rate of Speech',
          icon: const Icon(Icons.speed, color: Colors.white),
          headerColor: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MetricCard(
                    label: 'Perceptual Judgment',
                    value: data['Rate of Speech']?['Perceptual Judgment']?.toString() ?? 'N/A',
                    backgroundColor: Colors.red.shade50,
                    valueColor: Colors.red.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    label: 'Words Per Minute',
                    value: data['Rate of Speech']?['Words Per Minute']?.toString() ?? 'N/A',
                    unit: 'WPM',
                    backgroundColor: Colors.red.shade50,
                    valueColor: Colors.red.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricCard(
                    label: 'Syllables Per Minute',
                    value: data['Rate of Speech']?['Syllables Per Minute']?.toString() ?? 'N/A',
                    unit: 'SPM',
                    backgroundColor: Colors.red.shade50,
                    valueColor: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Disfluencies Section
        ReportSection(
          title: 'Disfluencies',
          icon: const Icon(Icons.timeline, color: Colors.white),
          headerColor: Colors.red,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledField(
                  label: 'Status',
                  value: data['Disfluencies']?['Status'] ?? 'N/A',
                ),
                if (data['Disfluencies']?['Types'] != null &&
                    (data['Disfluencies']['Types'] as Map<String, dynamic>).isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Present Types:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...(data['Disfluencies']['Types'] as Map<String, dynamic>)
                          .entries
                          .where((entry) => entry.value == true)
                          .map((entry) => StatusChip(
                                label: entry.key,
                                activeColor: Colors.red,
                              )),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),

        // Speech Assessment Section
        ReportSection(
          title: 'Speech Assessment',
          icon: const Icon(Icons.psychology, color: Colors.white),
          headerColor: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Awareness
              Expanded(
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
                        'Awareness',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data['Awareness'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: data['Awareness'] == 'Present'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Dysfluencies Percentage
              Expanded(
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
                        'Dysfluencies Percentage',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _PercentageRow(
                        label: 'Reading',
                        value: data['Reading'] ?? '0',
                        unit: '%',
                      ),
                      _PercentageRow(
                        label: 'Spontaneous Speech',
                        value: data['Spontaneous Speech'] ?? '0',
                        unit: '%',
                      ),
                      _PercentageRow(
                        label: 'Picture Description',
                        value: data['Picture Description'] ?? '0',
                        unit: '%',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Secondary Behaviors Section
        ReportSection(
          title: 'Secondary Behaviors',
          icon: const Icon(Icons.note, color: Colors.white),
          headerColor: Colors.red,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ...(data['Secondary Behaviors'] as Map<String, dynamic>? ?? {})
                    .entries
                    .map((entry) => _ScaleIndicator(
                          label: entry.key,
                          value: int.tryParse(entry.value.toString()) ?? 0,
                        )),
              ],
            ),
          ),
        ),

        // Average Duration Section (if available)
        if (data['Average Duration'] != null)
          ReportSection(
            title: 'Average Duration',
            icon: const Icon(Icons.timer, color: Colors.white),
            headerColor: Colors.red,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Average Duration of Three Longest Stuttering Events',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        data['Average Duration'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'seconds',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        // Remarks Section (if available)
        if (data['remarks'] != null)
          ReportSection(
            title: 'Additional Remarks',
            icon: const Icon(Icons.comment, color: Colors.white),
            headerColor: Colors.red,
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
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PercentageRow extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const _PercentageRow({
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit != null)
                Text(
                  ' $unit',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScaleIndicator extends StatelessWidget {
  final String label;
  final int value;

  const _ScaleIndicator({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Row(
          children: List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: index <= value
                      ? Colors.red.shade50
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: index <= value
                        ? Colors.red.shade300
                        : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  index.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: index <= value
                        ? Colors.red.shade700
                        : Colors.grey.shade400,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}