import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Memory leak detection utility to help identify potential memory leaks
class MemoryLeakDetector {
  static final MemoryLeakDetector _instance = MemoryLeakDetector._internal();
  factory MemoryLeakDetector() => _instance;
  MemoryLeakDetector._internal();

  final Map<String, int> _widgetCounts = {};
  final Map<String, DateTime> _widgetCreationTimes = {};
  final Map<String, List<String>> _widgetStacks = {};
  Timer? _monitoringTimer;
  bool _isMonitoring = false;

  /// Start monitoring for memory leaks
  void startMonitoring({Duration interval = const Duration(seconds: 30)}) {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(interval, (_) {
      _checkForLeaks();
    });

    debugPrint('MemoryLeakDetector: Started monitoring');
  }

  /// Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    debugPrint('MemoryLeakDetector: Stopped monitoring');
  }

  /// Register widget creation
  void registerWidget(String widgetName, [String? stackTrace]) {
    _widgetCounts[widgetName] = (_widgetCounts[widgetName] ?? 0) + 1;
    _widgetCreationTimes[widgetName] = DateTime.now();

    if (stackTrace != null) {
      _widgetStacks[widgetName] = stackTrace.split('\n');
    }

    if (kDebugMode) {
      debugPrint(
          'MemoryLeakDetector: Registered $widgetName (count: ${_widgetCounts[widgetName]})');
    }
  }

  /// Register widget disposal
  void unregisterWidget(String widgetName) {
    if (_widgetCounts.containsKey(widgetName)) {
      _widgetCounts[widgetName] = _widgetCounts[widgetName]! - 1;

      if (_widgetCounts[widgetName]! <= 0) {
        _widgetCounts.remove(widgetName);
        _widgetCreationTimes.remove(widgetName);
        _widgetStacks.remove(widgetName);
      }

      if (kDebugMode) {
        debugPrint(
            'MemoryLeakDetector: Unregistered $widgetName (count: ${_widgetCounts[widgetName] ?? 0})');
      }
    }
  }

  /// Check for potential memory leaks
  void _checkForLeaks() {
    final now = DateTime.now();
    final potentialLeaks = <String>[];

    _widgetCounts.forEach((widgetName, count) {
      final creationTime = _widgetCreationTimes[widgetName];
      if (creationTime != null) {
        final age = now.difference(creationTime);

        // Consider it a potential leak if:
        // 1. Widget count is high (>5)
        // 2. Widget has been alive for more than 5 minutes
        if (count > 5 || age.inMinutes > 5) {
          potentialLeaks
              .add('$widgetName (count: $count, age: ${age.inMinutes}m)');
        }
      }
    });

    if (potentialLeaks.isNotEmpty) {
      debugPrint('MemoryLeakDetector: Potential leaks detected:');
      for (final leak in potentialLeaks) {
        debugPrint('  - $leak');
      }

      // Log to developer console for better visibility
      developer.log(
        'Potential memory leaks detected: ${potentialLeaks.join(', ')}',
        name: 'MemoryLeakDetector',
        level: 900, // Warning level
      );
    }
  }

  /// Get current widget statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalWidgets': _widgetCounts.length,
      'widgetCounts': Map.from(_widgetCounts),
      'oldestWidget': _getOldestWidget(),
      'isMonitoring': _isMonitoring,
    };
  }

  /// Get the oldest widget
  String? _getOldestWidget() {
    if (_widgetCreationTimes.isEmpty) return null;

    String? oldestWidget;
    DateTime? oldestTime;

    _widgetCreationTimes.forEach((widget, time) {
      if (oldestTime == null || time.isBefore(oldestTime!)) {
        oldestTime = time;
        oldestWidget = widget;
      }
    });

    return oldestWidget;
  }

  /// Force garbage collection (for testing purposes)
  void forceGarbageCollection() {
    if (kDebugMode) {
      debugPrint('MemoryLeakDetector: Forcing garbage collection');
      // Note: There's no direct way to force GC in Dart/Flutter
      // This is mainly for logging purposes
    }
  }

  /// Clear all tracking data
  void clearTracking() {
    _widgetCounts.clear();
    _widgetCreationTimes.clear();
    _widgetStacks.clear();
    debugPrint('MemoryLeakDetector: Cleared all tracking data');
  }

  /// Dispose the detector
  void dispose() {
    stopMonitoring();
    clearTracking();
  }
}

/// Mixin to automatically track widget lifecycle for memory leak detection
mixin MemoryLeakTrackingMixin<T extends StatefulWidget> on State<T> {
  final MemoryLeakDetector _detector = MemoryLeakDetector();
  late final String _widgetName;

  @override
  void initState() {
    super.initState();
    _widgetName = widget.runtimeType.toString();

    if (kDebugMode) {
      _detector.registerWidget(_widgetName, StackTrace.current.toString());
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      _detector.unregisterWidget(_widgetName);
    }
    super.dispose();
  }
}

/// Widget to display memory leak statistics (for debugging)
class MemoryLeakDebugWidget extends StatefulWidget {
  const MemoryLeakDebugWidget({Key? key}) : super(key: key);

  @override
  State<MemoryLeakDebugWidget> createState() => _MemoryLeakDebugWidgetState();
}

class _MemoryLeakDebugWidgetState extends State<MemoryLeakDebugWidget> {
  final MemoryLeakDetector _detector = MemoryLeakDetector();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return SizedBox.shrink();
    }

    final stats = _detector.getStatistics();
    final widgetCounts = stats['widgetCounts'] as Map<String, int>;

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Memory Leak Debug Info',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Total Widgets: ${stats['totalWidgets']}',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Monitoring: ${stats['isMonitoring']}',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          if (stats['oldestWidget'] != null)
            Text(
              'Oldest: ${stats['oldestWidget']}',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          SizedBox(height: 4),
          if (widgetCounts.isNotEmpty) ...[
            Text(
              'Widget Counts:',
              style: TextStyle(color: Colors.yellow, fontSize: 10),
            ),
            ...widgetCounts.entries.map((entry) => Text(
                  '  ${entry.key}: ${entry.value}',
                  style: TextStyle(
                    color: entry.value > 3 ? Colors.red : Colors.white,
                    fontSize: 9,
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

/// Performance monitoring utility
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _stopwatches = {};
  final Map<String, List<int>> _measurements = {};

  /// Start measuring performance for a specific operation
  void startMeasurement(String operationName) {
    _stopwatches[operationName] = Stopwatch()..start();
  }

  /// Stop measuring and record the result
  void stopMeasurement(String operationName) {
    final stopwatch = _stopwatches[operationName];
    if (stopwatch != null) {
      stopwatch.stop();
      final duration = stopwatch.elapsedMilliseconds;

      _measurements.putIfAbsent(operationName, () => []).add(duration);
      _stopwatches.remove(operationName);

      if (kDebugMode && duration > 100) {
        debugPrint('PerformanceMonitor: $operationName took ${duration}ms');
      }
    }
  }

  /// Get performance statistics for an operation
  Map<String, dynamic>? getStats(String operationName) {
    final measurements = _measurements[operationName];
    if (measurements == null || measurements.isEmpty) return null;

    final sorted = List<int>.from(measurements)..sort();
    final average = measurements.reduce((a, b) => a + b) / measurements.length;

    return {
      'count': measurements.length,
      'average': average.round(),
      'min': sorted.first,
      'max': sorted.last,
      'median': sorted[sorted.length ~/ 2],
    };
  }

  /// Clear all measurements
  void clearMeasurements() {
    _measurements.clear();
    _stopwatches.clear();
  }

  /// Get all performance statistics
  Map<String, Map<String, dynamic>> getAllStats() {
    final result = <String, Map<String, dynamic>>{};
    for (final operation in _measurements.keys) {
      final stats = getStats(operation);
      if (stats != null) {
        result[operation] = stats;
      }
    }
    return result;
  }
}

/// Mixin to automatically measure widget build performance
mixin PerformanceTrackingMixin<T extends StatefulWidget> on State<T> {
  final PerformanceMonitor _monitor = PerformanceMonitor();
  late final String _widgetName;

  @override
  void initState() {
    super.initState();
    _widgetName = widget.runtimeType.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _monitor.startMeasurement('${_widgetName}_build');
    }

    final result = buildWidget(context);

    if (kDebugMode) {
      _monitor.stopMeasurement('${_widgetName}_build');
    }

    return result;
  }

  /// Override this method instead of build()
  Widget buildWidget(BuildContext context);
}
