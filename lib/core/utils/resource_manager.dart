import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:rive/rive.dart';

/// Comprehensive resource manager to prevent memory leaks and manage app resources
class ResourceManager {
  static final ResourceManager _instance = ResourceManager._internal();
  factory ResourceManager() => _instance;
  ResourceManager._internal();

  final Set<Timer> _activeTimers = {};
  final Set<StreamSubscription> _activeSubscriptions = {};
  final Set<AudioPlayer> _audioPlayers = {};
  final Set<VideoPlayerController> _videoControllers = {};
  final Set<CameraController> _cameraControllers = {};
  final Set<StateMachineController> _riveControllers = {};
  final Set<OverlayEntry> _overlayEntries = {};

  /// Register a timer for automatic cleanup
  void registerTimer(Timer timer) {
    _activeTimers.add(timer);
  }

  /// Register a stream subscription for automatic cleanup
  void registerSubscription(StreamSubscription subscription) {
    _activeSubscriptions.add(subscription);
  }

  /// Register an audio player for automatic cleanup
  void registerAudioPlayer(AudioPlayer player) {
    _audioPlayers.add(player);
  }

  /// Register a video controller for automatic cleanup
  void registerVideoController(VideoPlayerController controller) {
    _videoControllers.add(controller);
  }

  /// Register a camera controller for automatic cleanup
  void registerCameraController(CameraController controller) {
    _cameraControllers.add(controller);
  }

  /// Register a Rive controller for automatic cleanup
  void registerRiveController(StateMachineController controller) {
    _riveControllers.add(controller);
  }

  /// Register an overlay entry for automatic cleanup
  void registerOverlayEntry(OverlayEntry entry) {
    _overlayEntries.add(entry);
  }

  /// Unregister and dispose a timer
  void disposeTimer(Timer timer) {
    if (_activeTimers.contains(timer)) {
      timer.cancel();
      _activeTimers.remove(timer);
    }
  }

  /// Unregister and dispose a subscription
  void disposeSubscription(StreamSubscription subscription) {
    if (_activeSubscriptions.contains(subscription)) {
      subscription.cancel();
      _activeSubscriptions.remove(subscription);
    }
  }

  /// Unregister and dispose an audio player
  void disposeAudioPlayer(AudioPlayer player) {
    if (_audioPlayers.contains(player)) {
      player.dispose();
      _audioPlayers.remove(player);
    }
  }

  /// Unregister and dispose a video controller
  void disposeVideoController(VideoPlayerController controller) {
    if (_videoControllers.contains(controller)) {
      controller.dispose();
      _videoControllers.remove(controller);
    }
  }

  /// Unregister and dispose a camera controller
  void disposeCameraController(CameraController controller) {
    if (_cameraControllers.contains(controller)) {
      controller.dispose();
      _cameraControllers.remove(controller);
    }
  }

  /// Unregister and dispose a Rive controller
  void disposeRiveController(StateMachineController controller) {
    if (_riveControllers.contains(controller)) {
      controller.dispose();
      _riveControllers.remove(controller);
    }
  }

  /// Unregister and remove an overlay entry
  void disposeOverlayEntry(OverlayEntry entry) {
    if (_overlayEntries.contains(entry)) {
      entry.remove();
      _overlayEntries.remove(entry);
    }
  }

  /// Dispose all registered resources (emergency cleanup)
  void disposeAll() {
    // Cancel all timers
    for (final timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();

    // Cancel all subscriptions
    for (final subscription in _activeSubscriptions) {
      subscription.cancel();
    }
    _activeSubscriptions.clear();

    // Dispose all audio players
    for (final player in _audioPlayers) {
      try {
        player.dispose();
      } catch (e) {
        debugPrint('Error disposing audio player: $e');
      }
    }
    _audioPlayers.clear();

    // Dispose all video controllers
    for (final controller in _videoControllers) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing video controller: $e');
      }
    }
    _videoControllers.clear();

    // Dispose all camera controllers
    for (final controller in _cameraControllers) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing camera controller: $e');
      }
    }
    _cameraControllers.clear();

    // Dispose all Rive controllers
    for (final controller in _riveControllers) {
      try {
        controller.dispose();
      } catch (e) {
        debugPrint('Error disposing Rive controller: $e');
      }
    }
    _riveControllers.clear();

    // Remove all overlay entries
    for (final entry in _overlayEntries) {
      try {
        entry.remove();
      } catch (e) {
        debugPrint('Error removing overlay entry: $e');
      }
    }
    _overlayEntries.clear();
  }

  /// Get resource usage statistics
  Map<String, int> getResourceStats() {
    return {
      'timers': _activeTimers.length,
      'subscriptions': _activeSubscriptions.length,
      'audioPlayers': _audioPlayers.length,
      'videoControllers': _videoControllers.length,
      'cameraControllers': _cameraControllers.length,
      'riveControllers': _riveControllers.length,
      'overlayEntries': _overlayEntries.length,
    };
  }

  /// Check for potential memory leaks
  bool hasMemoryLeaks() {
    final stats = getResourceStats();
    final totalResources = stats.values.reduce((a, b) => a + b);

    // Consider it a potential leak if there are more than 10 active resources
    return totalResources > 10;
  }

  /// Log current resource usage
  void logResourceUsage() {
    final stats = getResourceStats();
    debugPrint('Resource Manager Stats: $stats');

    if (hasMemoryLeaks()) {
      debugPrint('WARNING: Potential memory leaks detected!');
    }
  }
}

/// Mixin to automatically manage resources in StatefulWidgets
mixin ResourceManagerMixin<T extends StatefulWidget> on State<T> {
  final ResourceManager _resourceManager = ResourceManager();
  final List<Timer> _widgetTimers = [];
  final List<StreamSubscription> _widgetSubscriptions = [];
  final List<AudioPlayer> _widgetAudioPlayers = [];
  final List<VideoPlayerController> _widgetVideoControllers = [];
  final List<CameraController> _widgetCameraControllers = [];
  final List<StateMachineController> _widgetRiveControllers = [];
  final List<OverlayEntry> _widgetOverlayEntries = [];

  /// Register a timer for this widget
  void registerTimer(Timer timer) {
    _widgetTimers.add(timer);
    _resourceManager.registerTimer(timer);
  }

  /// Register a subscription for this widget
  void registerSubscription(StreamSubscription subscription) {
    _widgetSubscriptions.add(subscription);
    _resourceManager.registerSubscription(subscription);
  }

  /// Register an audio player for this widget
  void registerAudioPlayer(AudioPlayer player) {
    _widgetAudioPlayers.add(player);
    _resourceManager.registerAudioPlayer(player);
  }

  /// Register a video controller for this widget
  void registerVideoController(VideoPlayerController controller) {
    _widgetVideoControllers.add(controller);
    _resourceManager.registerVideoController(controller);
  }

  /// Register a camera controller for this widget
  void registerCameraController(CameraController controller) {
    _widgetCameraControllers.add(controller);
    _resourceManager.registerCameraController(controller);
  }

  /// Register a Rive controller for this widget
  void registerRiveController(StateMachineController controller) {
    _widgetRiveControllers.add(controller);
    _resourceManager.registerRiveController(controller);
  }

  /// Register an overlay entry for this widget
  void registerOverlayEntry(OverlayEntry entry) {
    _widgetOverlayEntries.add(entry);
    _resourceManager.registerOverlayEntry(entry);
  }

  /// Dispose all resources registered by this widget
  void disposeWidgetResources() {
    // Dispose timers
    for (final timer in _widgetTimers) {
      _resourceManager.disposeTimer(timer);
    }
    _widgetTimers.clear();

    // Dispose subscriptions
    for (final subscription in _widgetSubscriptions) {
      _resourceManager.disposeSubscription(subscription);
    }
    _widgetSubscriptions.clear();

    // Dispose audio players
    for (final player in _widgetAudioPlayers) {
      _resourceManager.disposeAudioPlayer(player);
    }
    _widgetAudioPlayers.clear();

    // Dispose video controllers
    for (final controller in _widgetVideoControllers) {
      _resourceManager.disposeVideoController(controller);
    }
    _widgetVideoControllers.clear();

    // Dispose camera controllers
    for (final controller in _widgetCameraControllers) {
      _resourceManager.disposeCameraController(controller);
    }
    _widgetCameraControllers.clear();

    // Dispose Rive controllers
    for (final controller in _widgetRiveControllers) {
      _resourceManager.disposeRiveController(controller);
    }
    _widgetRiveControllers.clear();

    // Dispose overlay entries
    for (final entry in _widgetOverlayEntries) {
      _resourceManager.disposeOverlayEntry(entry);
    }
    _widgetOverlayEntries.clear();
  }

  @override
  void dispose() {
    disposeWidgetResources();
    super.dispose();
  }
}

/// Enhanced lifecycle manager for better state preservation
class LifecycleManager with WidgetsBindingObserver {
  static final LifecycleManager _instance = LifecycleManager._internal();
  factory LifecycleManager() => _instance;
  LifecycleManager._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final Map<String, dynamic> _savedStates = {};
  final List<VoidCallback> _pauseCallbacks = [];
  final List<VoidCallback> _resumeCallbacks = [];

  /// Save state with a key
  void saveState(String key, dynamic value) {
    _savedStates[key] = value;
  }

  /// Retrieve saved state
  T? getState<T>(String key) {
    return _savedStates[key] as T?;
  }

  /// Clear saved state
  void clearState(String key) {
    _savedStates.remove(key);
  }

  /// Register callback for app pause
  void registerPauseCallback(VoidCallback callback) {
    _pauseCallbacks.add(callback);
  }

  /// Register callback for app resume
  void registerResumeCallback(VoidCallback callback) {
    _resumeCallbacks.add(callback);
  }

  /// Remove pause callback
  void removePauseCallback(VoidCallback callback) {
    _pauseCallbacks.remove(callback);
  }

  /// Remove resume callback
  void removeResumeCallback(VoidCallback callback) {
    _resumeCallbacks.remove(callback);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        for (final callback in _pauseCallbacks) {
          try {
            callback();
          } catch (e) {
            debugPrint('Error in pause callback: $e');
          }
        }
        break;
      case AppLifecycleState.resumed:
        for (final callback in _resumeCallbacks) {
          try {
            callback();
          } catch (e) {
            debugPrint('Error in resume callback: $e');
          }
        }
        break;
      default:
        break;
    }
  }

  /// Dispose the lifecycle manager
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _savedStates.clear();
    _pauseCallbacks.clear();
    _resumeCallbacks.clear();
  }
}
