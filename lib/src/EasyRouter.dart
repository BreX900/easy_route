import 'dart:async';

import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as mt;


typedef WidgetRoute WidgetRouteBuilder(BuildContext context);

/// First Screen please reference EsyRouter.HOME
/// Complete Material App with 'onGenerateRoute' and 'navigatorObservers'
class EasyRouter {
  EasyRouter._();

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: EasyRouter.onGenerateRoute((context) => HomeScreen()),
  static RouteFactory onGenerateRouteBuilder(WidgetRouteBuilder builder, String initialRoute,
      {bool maintainState: true}) {
    assert(builder != null);
    assert(initialRoute != null);
    assert(maintainState != null);
    return (RouteSettings settings) {
      if (settings.name == initialRoute) {
        return mt.MaterialPageRoute(builder: builder,
            settings: settings, maintainState: maintainState);
      }

      return cp.CupertinoPageRoute(builder: (context) => settings.arguments,
        settings: settings, maintainState: maintainState,);
    };
  }

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: EasyRouter.onGenerateRoute(HomeScreen()),
  static RouteFactory onGenerateRoute(WidgetRoute home, {bool maintainState: true}) {
    return (RouteSettings settings) {
      if (settings.name == home.route) {
        return mt.MaterialPageRoute(builder: (_) => home, settings: settings);
      }

      return cp.CupertinoPageRoute(builder: (context) => settings.arguments, settings: settings,);
    };
  }

  //static final Path _path = Path(path: '');

  /// Open new Screen
  static Future<dynamic> push(BuildContext context, WidgetRoute screen) async {
    return Navigator.pushNamed(context, screen.route, arguments: screen,);
  }

  /// Close last screen
  static bool pop(BuildContext context) {
     return Navigator.pop(context);
  }

  /// Close last screen in safe Mode
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Close all the screens up to the routeName
  static Future<dynamic> popUntil(BuildContext context, String routeName) async {
    return Navigator.popUntil(context, ModalRoute.withName(routeName),);
  }

  /// Close all the screens up to the routeName/screen.route and push screen
  static Future<Object> pushNamedAndRemoveUntil(BuildContext context, WidgetRoute screen, {String routeName}) async {
    return Navigator.pushNamedAndRemoveUntil(context, screen.route, ModalRoute.withName(routeName??screen.route), arguments: screen,);
  }

  /// Replace current screen with a destroy animation for current screen
  static Future<Object> pushReplacement(BuildContext context, WidgetRoute screen) async {
    return Navigator.pushReplacementNamed(context, screen.route, arguments: screen,);
  }

  /// Replace current screen with swipe animation for current screen
  static Future<dynamic> popAndPush(BuildContext context, WidgetRoute screen) async {
    return Navigator.popAndPushNamed(context, screen.route, arguments: screen,);
  }


  /*static Lock _lockSwipeBack = Lock();
  /// Opens a new screen in safe mode
  static Future openScreen(BuildContext context, Widget screen, {isMaterial: false, isDrawerOpen: false}) async {
    return _lockSwipeBack.synchronized(() async {
      final navigator = Navigator.of(context);
      if (isDrawerOpen) navigator.pop();
      final PageRoute pageRoute = isMaterial ?
      mt.MaterialPageRoute(builder: (_) => screen) :
      cp.CupertinoPageRoute(builder: (_) => screen);

      await SwipeBackObserver.promise?.future;

      return await navigator.push(pageRoute);
    });
  }*/
}

/// Example:
/// static const ROUTE = 'home';
/// String get route => ROUTE;
abstract class WidgetRoute implements Widget {
  String get route;
}


/// Add it to MaterialApp
/// navigatorObservers: <NavigatorObserver>[ SwipeBackObserver(), ],
class SwipeBackObserver extends NavigatorObserver {
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    //EasyRouter._path.setPath(route.settings.name);
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    //EasyRouter._path.removeLast();
  }

  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) { print('didRemove'); }

  void didReplace({ Route<dynamic> newRoute, Route<dynamic> oldRoute }) {
    didPop(newRoute, oldRoute);
    didPush(newRoute, oldRoute);
  }

  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) { print('didStartUserGesture'); }

  void didStopUserGesture() { print('didStopUserGesture'); }
}


class Path {
  static const BAR = '/';
  String _path;

  Path({@required String path}) : this._path = path;

  String get path => _path;

  void setPath(String path) {
    print(this);
    _path += BAR+path;
    print(this);
  }

  String get last => _path.split(BAR).last;

  @override
  String toString() {
    return 'Path($path)';
  }

  void removeLast() {
    _path = _path.substring(0, _path.length-_path.split(BAR).last.length-1);
  }
}

/*/// Add it to MaterialApp
/// navigatorObservers: <NavigatorObserver>[ SwipeBackObserver(), ],
class SwipeBackObserver extends NavigatorObserver {
  static Completer promise;

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    // make a new promise
    promise = Completer();
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    // resolve the promise
    easyRouter.path.removeLast();
    promise.complete();
  }
}*/