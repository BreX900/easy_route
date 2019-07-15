

import 'package:flutter/widgets.dart';

enum Transition {
  material, cupertino,
}


class PocketRouteOptions {
  final Transition transition;
  final bool maintainState;

  const PocketRouteOptions({
    this.transition,
    this.maintainState,
  });

  const PocketRouteOptions.def() : this(transition: null, maintainState: true);

  const PocketRouteOptions.material() : this(transition: Transition.material);

  PocketRouteOptions copyWith({Transition transition, bool maintainState}) {
    return PocketRouteOptions(
      transition: transition??this.transition,
      maintainState: maintainState??this.maintainState,
    );
  }
}


/// Example:
/// static const ROUTE = 'home';
/// String get route => ROUTE;
abstract class WidgetRoute implements Widget {
  String get route;
}

class ScreenRoute extends StatelessWidget implements WidgetRoute{
  final String route;
  final Widget child;

  const ScreenRoute({Key key, @required this.route, @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

typedef WidgetRoute WidgetRouteBuilder(BuildContext context);


class Argument {
  final WidgetRouteBuilder builder;
  final PocketRouteOptions options;

  Argument(
      WidgetRoute screen,
      [PocketRouteOptions options]
      ) : this.builder((_) => screen, options);

  Argument.builder(
      this.builder,
      [PocketRouteOptions options]
      ) : this.options = options??const PocketRouteOptions();
}