import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FluencyReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const FluencyReport({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rate of Speech Section
        if (data.containsKey('Rate of Speech'))
          _buildRateOfSpeechSection(data['Rate of Speech']),

        // Disfluencies Section
        if (data.containsKey('Disfluencies'))
          _buildDisfluenciesSection(data['Disfluencies']),

        // Speech Assessment Section
        _buildSpeechAssessmentSection(),

        // Secondary Behaviors Section
        if (data.containsKey('Secondary Behaviors'))
          _buildSecondaryBehaviorsSection(data['Secondary Behaviors']),

        // Average Duration Section (if available)
        if (data.containsKey('Average Duration'))
          _buildAverageDurationSection(data['Average Duration']),

        // Remarks Section (if available)
        if (data.containsKey('remarks')) _buildRemarksSection(data['remarks']),
      ],
    );
  }

  Widget _buildRateOfSpeechSection(Map<String, dynamic> rateData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Rate of Speech'),
        Row(
          children: [
            _buildMetricCard(
              'Perceptual Judgment',
              rateData['Perceptual Judgment']?.toString() ?? 'N/A',
            ),
            const SizedBox(width: 12),
            _buildMetricCard(
              'Words Per Minute',
              rateData['Words Per Minute']?.toString() ?? 'N/A',
              unit: 'WPM',
            ),
            const SizedBox(width: 12),
            _buildMetricCard(
              'Syllables Per Minute',
              rateData['Syllables Per Minute']?.toString() ?? 'N/A',
              unit: 'SPM',
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDisfluenciesSection(Map<String, dynamic> disfluencyData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Disfluencies'),
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
              _buildInfoRow('Status', disfluencyData['Status'] ?? 'N/A'),
              if (disfluencyData.containsKey('Types') &&
                  disfluencyData['Types'] is Map) ...[
                const SizedBox(height: 12),
                Text(
                  'Present Types:',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4b4b4b),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (disfluencyData['Types'] as Map<String, dynamic>)
                      .entries
                      .where((entry) => entry.value == true)
                      .map((entry) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF1cb0f6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Color(0xFF1cb0f6)),
                            ),
                            child: Text(
                              entry.key,
                              style: GoogleFonts.inter(
                                color: Color(0xFF1cb0f6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSpeechAssessmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Speech Assessment'),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if we should use column or row layout
            final useColumnLayout = constraints.maxWidth < 500;

            if (useColumnLayout) {
              // Column layout for small screens - each card takes full width
              return Column(
                children: [
                  _buildAwarenessCard(useFullWidth: true),
                  const SizedBox(height: 16),
                  _buildDysfluenciesCard(useFullWidth: true, maxHeight: 150),
                ],
              );
            } else {
              // Row layout for larger screens - cards side by side
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildAwarenessCard(useFullWidth: false),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDysfluenciesCard(
                        useFullWidth: false, maxHeight: null),
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAwarenessCard({required bool useFullWidth}) {
    return Container(
      width: useFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Awareness',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4b4b4b),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['Awareness'] ?? 'N/A',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: data['Awareness'] == 'Present'
                  ? Colors.green
                  : Color(0xFF1cb0f6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDysfluenciesCard(
      {required bool useFullWidth, double? maxHeight}) {
    return Container(
      width: useFullWidth ? double.infinity : null,
      constraints:
          maxHeight != null ? BoxConstraints(maxHeight: maxHeight) : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Dysfluencies Percentage',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4b4b4b),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildPercentageRow('Reading', data['Reading'] ?? '0'),
          _buildPercentageRow(
              'Spontaneous Speech', data['Spontaneous Speech'] ?? '0'),
          _buildPercentageRow(
              'Picture Description', data['Picture Description'] ?? '0'),
        ],
      ),
    );
  }

  Widget _buildSecondaryBehaviorsSection(Map<String, dynamic> behaviorsData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Secondary Behaviors'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: behaviorsData.entries.map((entry) {
              final int value = int.tryParse(entry.value.toString()) ?? 0;
              return _buildScaleIndicator(entry.key, value);
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAverageDurationSection(dynamic duration) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Average Duration'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Check if the available width is less than a threshold
              if (constraints.maxWidth < 450) {
                // Use a column layout for smaller screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Average Duration of Three Longest Stuttering Events',
                      style: GoogleFonts.inter(
                        color: Color(0xFF4b4b4b),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          duration.toString(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF1cb0f6),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'seconds',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Use row layout for larger screens with modified text
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Limit the label width to prevent overflow
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Average Duration of Three Longest Stuttering Events',
                        style: GoogleFonts.inter(
                          color: Color(0xFF4b4b4b),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                    ),
                    // Add some spacing
                    const SizedBox(width: 16),
                    // Keep the value from being compressed
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            duration.toString(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1cb0f6),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'seconds',
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRemarksSection(dynamic remarks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Additional Remarks'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            remarks.toString(),
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF4b4b4b),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.assessment_outlined,
            color: Color(0xFF1cb0f6),
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
    );
  }

  Widget _buildMetricCard(String label, String value, {String? unit}) {
    return Expanded(
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
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1cb0f6),
                  ),
                ),
                if (unit != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Color(0xFF4b4b4b),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4b4b4b),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4b4b4b),
                  fontSize: 13,
                ),
              ),
              Text(
                ' %',
                style: GoogleFonts.inter(
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

  Widget _buildScaleIndicator(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Color(0xFF4b4b4b),
              fontSize: 14,
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
                      ? Color(0xFF1cb0f6).withOpacity(0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: index <= value
                        ? Color(0xFF1cb0f6)
                        : Colors.grey.shade300,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  index.toString(),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: index <= value
                        ? Color(0xFF1cb0f6)
                        : Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
