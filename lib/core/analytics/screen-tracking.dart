import 'package:flutter/widgets.dart';

import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/playBgm.dart';

class ScreenTracking extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService _analyticsService;
  
  ScreenTracking(this._analyticsService);
   
List<String> screensWithoutMusic = [
      '/home',
    '/loading_screen',
    '/login',
      '/login_signup'
    '/register',
    "/auditory_screen",
    '/setting_screen',
    '/phonmes_list_screen',
    '/phonems_level_screen_one_screen',
    '/user_profile'
  ];
  
  Map<String, DateTime> _screenEntryTimes = {};
    void _handleMusicPlayback(PageRoute<dynamic> route) {
    PlayBgm _playBgm = PlayBgm();
    String currentRoute = route.settings.name ?? '';
    debugPrint("Current Route: ");
    debugPrint(currentRoute);
    debugPrint("Screens");
    if (screensWithoutMusic.contains(currentRoute)) {
      _playBgm.playMusic('Main_Interaction_Screen.mp3', "mp3", true);
    } else {
      _playBgm.stopMusic();
    }
  }
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    if (screenName != null) {
      var now = DateTime.now();
      _screenEntryTimes[screenName] = now;
      _analyticsService.logScreenView(screenName);
    }
  }

  void _logTimeSpent(String screenName, DateTime entryTime) {
    var now = DateTime.now();
    var timeSpent = now.difference(entryTime).inSeconds;
    _analyticsService.logEvent('time_spent', {
      'screen_name': screenName,
      'time_spent': timeSpent,
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      _handleMusicPlayback(route);
      _sendScreenView(route);
    }
    if (previousRoute is PageRoute) {
      var screenName = previousRoute.settings.name;
      if (screenName != null) {
        var entryTime = _screenEntryTimes[screenName];
        if (entryTime != null) {
          _logTimeSpent(screenName, entryTime);
        }
      }
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      var screenName = route.settings.name;
      if (screenName != null) {
        var entryTime = _screenEntryTimes[screenName];
        if (entryTime != null) {
          _logTimeSpent(screenName, entryTime);
        }
      }
    }
    if (previousRoute == null) {
      // Log app exit event
      _analyticsService.logEvent('app_exit', {
        'screen_name': route.settings.name,
      });
    } else if (previousRoute is PageRoute) {
      _handleMusicPlayback(previousRoute);
      _sendScreenView(previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
      _handleMusicPlayback(newRoute);
      _sendScreenView(newRoute);
    }
    if (oldRoute is PageRoute) {
      var screenName = oldRoute.settings.name;
      if (screenName != null) {
        var entryTime = _screenEntryTimes[screenName];
        if (entryTime != null) {
          _logTimeSpent(screenName, entryTime);
        }
      }
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
