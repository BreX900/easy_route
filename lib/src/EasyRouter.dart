import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:easy_route/src/Common.dart';
import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as mt;



/// !!! DEPRECATED !!!
/// First Screen please reference EsyRouter.HOME
/// Complete Material App with 'onGenerateRoute'
class EasyRouter {
  EasyRouter._();

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: EasyRouter.onGenerateRoute((context) => HomeScreen()),
  static RouteFactory onGenerateRouteBuilder(WidgetRouteBuilder builder, String initialRoute, {
    PocketRouteOptions homeOptions: const PocketRouteOptions(transition: Transition.material), PocketRouteOptions defaultOptions: const PocketRouteOptions.def(),
  }) {
    assert(builder != null);
    assert(initialRoute != null);
    assert(defaultOptions != null);

    return (RouteSettings settings) {
      // Check is the first route
      final argument = settings.name == initialRoute ?
        Argument.builder(builder, homeOptions) :
        settings.arguments as Argument;

      if ((argument.options.transition??defaultOptions.transition) == Transition.material) {
        return mt.MaterialPageRoute(
          builder: argument.builder,
          settings: settings,
          maintainState: argument.options.maintainState ?? defaultOptions.maintainState,
        );
      } else {
        return cp.CupertinoPageRoute(
          builder: argument.builder,
          settings: settings,
          maintainState: argument.options.maintainState ?? defaultOptions.maintainState,
        );
      }
    };
  }

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: EasyRouter.onGenerateRoute(HomeScreen()),
  static RouteFactory onGenerateRoute(WidgetRoute home, {
    PocketRouteOptions homeOptions, PocketRouteOptions defaultOptions: const PocketRouteOptions.def(),
  }) {
    return onGenerateRouteBuilder((_) => home, home.route,
      homeOptions:homeOptions, defaultOptions: defaultOptions,
    );
  }

  //static final Path _path = Path(path: '');

  /// Opens a new screen only if the current screen is not the first one,
  /// otherwise it closes the current screen
  static Future<dynamic> pushSecondElseClose(BuildContext context, WidgetRouteBuilder builder, {
    PocketRouteOptions options,
  }) async {
    return canPop(context) ? pop(context) : await push(context, builder(context), options: options);
  }

  /// Open new Screen
  static Future<dynamic> push(BuildContext context, WidgetRoute screen, {PocketRouteOptions options}) async {
    return await Navigator.pushNamed(context, screen.route, arguments: Argument(screen, options),);
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
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName),);
  }

  /// Close all the screens and push screen
  static Future<Object> pushAndRemoveAll(BuildContext context, WidgetRoute screen, {
    PocketRouteOptions options: const PocketRouteOptions(transition: Transition.material),
  }) async {
    return await pushAndRemoveUntil(context, screen, (_) => false, options: options);
  }

  /// Close all the screens up to the routeName and push screen
  static Future<Object> pushAndRemoveUntilRoute(BuildContext context, WidgetRoute screen, String routeName, {
    PocketRouteOptions options,
  }) async {
    return await pushAndRemoveUntil(context, screen, ModalRoute.withName(routeName), options: options);
  }

  /// Close all the screens up to the [RoutePredicate] and push screen
  static Future<Object> pushAndRemoveUntil(BuildContext context, WidgetRoute screen, RoutePredicate predicate, {
    PocketRouteOptions options,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil(context, screen.route, predicate,
      arguments: Argument(screen, options),
    );
  }

  /// Replace current screen with a destroy animation for current screen
  static Future<Object> pushReplacement(BuildContext context, WidgetRoute screen, {
    PocketRouteOptions options,
  }) async {
    return await Navigator.pushReplacementNamed(context, screen.route,
      arguments: Argument(screen, options),
    );
  }

  /// Replace current screen with swipe animation for current screen
  static Future<dynamic> popAndPush(BuildContext context, WidgetRoute screen, {
    PocketRouteOptions options,
  }) async {
    return await Navigator.popAndPushNamed(context, screen.route, arguments: Argument(screen, options),);
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










/// Add it to MaterialApp
/// navigatorObservers: <NavigatorObserver>[ SwipeBackObserver(), ],
@deprecated
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

@deprecated
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