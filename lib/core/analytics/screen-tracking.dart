
import 'package:flutter/widgets.dart';

import 'package:svar_new/core/analytics/analytics.dart';

class ScreenTracking extends RouteObserver<PageRoute<dynamic>> {
  final AnalyticsService _analyticsService;

  ScreenTracking(this._analyticsService);

  Map<String, DateTime> _screenEntryTimes = {};

  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    print(screenName);
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
      _sendScreenView(previousRoute);
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute) {
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
