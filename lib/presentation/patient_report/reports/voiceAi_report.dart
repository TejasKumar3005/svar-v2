import 'dart:convert'; // For base64Decode
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting (add to pubspec.yaml: intl: ^0.19.0 or latest)

// Helper to format numbers (can be moved to a common utils file)
String _formatNumericValue(dynamic value, {int decimals = 2, String unit = ''}) {
  if (value == null || value.toString().isEmpty) return 'N/A';
  final num number = (value is String) ? (double.tryParse(value) ?? double.nan) : (value as num);
  if (number.isNaN) return 'N/A';
  String formatted = number.toStringAsFixed(decimals);
  return unit.isNotEmpty ? '$formatted $unit' : formatted;
}

// Metric groups definition (should match your analyzer's output/config)
const List<Map<String, dynamic>> reportMetricGroups = [
  {'title': 'Fundamental Frequency', 'metrics': ['meanF0', 'stdevF0', 'medianF0' , 'minF0' , 'maxF0'] , 'unit' :['Hz' ,  'Hz',  'Hz', 'Hz', 'Hz'] },
  {'title': 'Voice Quality', 'metrics': ['hnr', 'cpps'] , 'unit' :[ "dB" ,  "dB"] },
  {'title': 'Jitter Measurements', 'metrics': ['localJitter'] , 'unit' : ['%'] },
  {'title': 'Shimmer Measurements', 'metrics': ['localShimmer'] , 'unit' : ["%"] },
  {'title' : 'Miscellaneous Value' , 'metrics' : ['amplitudeModulation' , 'frequencyModulation' , 'soft phonetion index'] , 'unit' : ["" , '' , '']},
  {'title' : 'Voice Break Analysis' , 'metrics' : ['unvoiced_fraction' , 'Number of voice break' , 'degree of voice break'] , 'unit' : ["%" , '' , "%"]}
];


class VoiceAnalysisReport extends StatelessWidget {
  final Map<String, dynamic> reportData; // This is the primary input

  const VoiceAnalysisReport({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final analysisResultsContainer = reportData['results'] as Map<String, dynamic>?;
    final metricsData = analysisResultsContainer?['result'] as Map<String, dynamic>?;
    final notes = reportData['notes'] as String? ?? '';
    final timestampStr = reportData['timestamp'] as String?;
    final clipStartTime = reportData['clipStartTime'] as num?;
    final clipEndTime = reportData['clipEndTime'] as num?;
    final originalAudioDuration = reportData['originalAudioDuration'] as num?;

    final spectrogramBase64 = analysisResultsContainer?['spectrogram'] as String?;
    final multibandCepstrumBase64 = analysisResultsContainer?['multiband_cepstrum'] as String?;

    String formattedTimestamp = 'N/A';
    if (timestampStr != null) {
      try {
        final dateTime = DateTime.parse(timestampStr).toLocal();
        formattedTimestamp = DateFormat('MMM d, yyyy HH:mm').format(dateTime); // Slightly shorter format
      } catch (e) {
        formattedTimestamp = timestampStr; // Fallback
      }
    }

    if (metricsData == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No voice analysis data available for this report.',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      );
    }

    // Determine clipping information for display
    final bool isEffectivelyClipped = metricsData['isClipped'] as bool? ?? (clipStartTime != null && clipEndTime != null);
    final num? analysisSegmentDuration = metricsData['analysisDuration'] as num?;

    final num? actualClipStart = metricsData['_clipStartTimeUsed'] as num? ?? clipStartTime;
    final num? actualClipEnd = metricsData['_clipEndTimeUsed'] as num? ?? clipEndTime;


    String clippingInfoDisplay;
    if (isEffectivelyClipped) {
      String clipRange = (actualClipStart != null && actualClipEnd != null)
        ? '${_formatNumericValue(actualClipStart, decimals: 2)}s - ${_formatNumericValue(actualClipEnd, decimals: 2)}s'
        : 'Yes';
      clippingInfoDisplay = 'Clipped: $clipRange';
      if (analysisSegmentDuration != null) {
          clippingInfoDisplay += ' (Analyzed: ${_formatNumericValue(analysisSegmentDuration, decimals: 2)}s)';
      }
    } else {
      clippingInfoDisplay = 'Full';
      if (analysisSegmentDuration != null) {
         clippingInfoDisplay += ' (Analyzed: ${_formatNumericValue(analysisSegmentDuration, decimals: 2)}s)';
      } else if (originalAudioDuration != null) {
         clippingInfoDisplay += ' (Original Duration: ${_formatNumericValue(originalAudioDuration, decimals: 2)}s)';
      }
    }


    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Voice Analysis Report',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue[800]),
          ),
          const SizedBox(height: 6),
          Text('Analysis Date: $formattedTimestamp', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
          const SizedBox(height: 20),

          _buildSectionCard(
            context,
            title: 'Analysis Overview',
            titleColor: Colors.blue[700],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Voice ID:', metricsData['voiceID']?.toString() ?? 'N/A'),
                _buildInfoRow(context, 'Clipping:', clippingInfoDisplay),
                if (!isEffectivelyClipped && originalAudioDuration != null && analysisSegmentDuration == null)
                   _buildInfoRow(context, 'Original Duration:', _formatNumericValue(originalAudioDuration, decimals:2, unit:"s")),
              ],
            )
          ),
          const SizedBox(height: 24),

          Text(
            'Acoustic Measurements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[800]),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 700 ? 2 : 1,
              childAspectRatio: MediaQuery.of(context).size.width > 700 ? 2.8 : 3.5, // Adjusted aspect ratio
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: reportMetricGroups.length,
            itemBuilder: (context, index) {
              final group = reportMetricGroups[index];
              return Card(
                elevation: 2,
                shadowColor: Colors.blue[100],
                 shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue[200]!),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[700]),
                      ),
                      Divider(height: 16, thickness: 0.8, color: Colors.blue[200]),
                      Expanded(
                        child: ListView( // Changed from Column to ListView for potential scrolling within card if many metrics
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: (group['metrics'] as List<String>).asMap().entries.map((entry) {
                            final metricKey = entry.value;
                            final unitIndex = entry.key;
                            final unitsList = group['unit'] as List<String>;
                            final unit = unitsList.length > unitIndex ? unitsList[unitIndex] : '';
                            final value = metricsData[metricKey];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$metricKey:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87)),
                                  Text(
                                    _formatNumericValue(value, unit: unit),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          if (spectrogramBase64 != null || multibandCepstrumBase64 != null) ...[
            Text(
              'Visualizations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[800]),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                bool useHorizontalLayout = constraints.maxWidth > 650;
                return Flex(
                  direction: useHorizontalLayout ? Axis.horizontal : Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: useHorizontalLayout ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                  children: [
                    if (spectrogramBase64 != null)
                      _buildVisualizationWidget(context, 'Frequency Domain Spectrogram', spectrogramBase64, useHorizontalLayout),
                    if (spectrogramBase64 != null && multibandCepstrumBase64 != null && useHorizontalLayout)
                       const SizedBox(width: 16),
                    if (multibandCepstrumBase64 != null)
                      _buildVisualizationWidget(context, 'MultiBand Cepstrum', multibandCepstrumBase64, useHorizontalLayout),
                  ],
                );
              }
            ),
            const SizedBox(height: 24),
          ],

          if (notes.isNotEmpty) ...[
             Text(
              'Clinical Notes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[800]),
            ),
            const SizedBox(height: 12),
            _buildSectionCard(
              context,
              child: Text(notes, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4, color: Colors.grey[800])),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue[50],
              borderColor: Colors.blue[200]
            ),
            const SizedBox(height: 24),
          ],

          Center(
            child: Text(
              'This report displays acoustic parameters from voice analysis. Results should be interpreted by qualified professionals.',
               style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey[600]),
               textAlign: TextAlign.center,
            ),
          ),
           const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey[700])),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, {String? title, required Widget child, EdgeInsets? padding, Color? color, Color? titleColor, Color? borderColor}) {
    return Card(
      elevation: title == null ? 1 : 2, // Less elevation for simple note card
      color: color ?? Colors.white,
      shadowColor: Colors.blue[100],
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor ?? Colors.blue[200]!),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: titleColor ?? Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
              ),
              Divider(height: 16, thickness: 0.8, color: titleColor?.withOpacity(0.3) ?? Theme.of(context).primaryColor.withOpacity(0.3)),
            ],
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizationWidget(BuildContext context, String title, String base64Image, bool isHorizontalLayout) {
    final cardContent = Card(
      elevation: 2,
      shadowColor: Colors.blue[100],
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue[200]!),
          borderRadius: BorderRadius.circular(12.0),
        ),
      margin: EdgeInsets.only(bottom: isHorizontalLayout ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.blue[700]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12,0,12,12),
            child: ClipRRect( // Clip the image itself for rounded corners if desired
              borderRadius: BorderRadius.circular(6.0),
              child: Image.memory(
                base64Decode(base64Image),
                fit: BoxFit.contain, // Use contain to see the whole image
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return AspectRatio(
                    aspectRatio: 16/9,
                    child: Container(
                      color: Colors.grey[200],
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_outlined, color: Colors.grey[500], size: 40),
                          const SizedBox(height: 4),
                          Text("Image Error", style: TextStyle(color: Colors.grey[600], fontSize: 12))
                        ],
                      ))
                    )
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    // If horizontal, wrap with Expanded. If vertical, it takes its own space.
    return isHorizontalLayout ? Expanded(child: cardContent) : cardContent;
  }
}