import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as mt;
import 'package:synchronized/synchronized.dart';

import 'SwipeBackObserver.dart';


typedef Widget RouteBuilder(EasyRoute params);


class EasyRouter {
  static const HOME = '/';

  EasyRouter._();

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: EasyRouter.onGenerateRoute((context) => HomeScreen()),
  static RouteFactory onGenerateRoute(WidgetBuilder homeRouteBuilder) {
    return (RouteSettings settings) {
      if (settings.name == HOME)
        return mt.MaterialPageRoute(
          builder: homeRouteBuilder,
        );

      return cp.CupertinoPageRoute(
        builder: (context) {
          return settings.arguments;
        },
        settings: settings,
      );
    };
  }

  /// Open new Screen
  static Future<dynamic> pushNamed(BuildContext context, EasyRoute screen) async {
    return Navigator.pushNamed(context, screen.name, arguments: screen,);
  }

  /// Close all the screens up to the screen route
  static Future<dynamic> popUntil(BuildContext context, String route) async {
    return Navigator.popUntil(context, ModalRoute.withName(route),);
  }

  /// Close last screen
  static Future<dynamic> pop(BuildContext context) async {
    return Navigator.pop(context);
  }

  /// Close last screen in safe Mode
  static Future<dynamic> canPop(BuildContext context) async {
    return Navigator.canPop(context);
  }

  final Lock _lockSwipeBack = Lock();

  /// Opens a new screen in safe mode
  Future openScreen(BuildContext context, Widget screen, {isMaterial: false, isDrawerOpen: false}) async {
    return _lockSwipeBack.synchronized(() async {
      final navigator = Navigator.of(context);
      if (isDrawerOpen) navigator.pop();
      final PageRoute pageRoute = isMaterial ?
      mt.MaterialPageRoute(builder: (_) => screen) :
      cp.CupertinoPageRoute(builder: (_) => screen);

      await SwipeBackObserver.promise?.future;

      return await navigator.push(pageRoute);
    });
  }
}


abstract class EasyRoute implements Widget {
  String get name;
}