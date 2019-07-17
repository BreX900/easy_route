import 'dart:collection';

import 'package:easy_route/src/Common.dart';
import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' as mt;
import 'package:bloc_provider/bloc_provider.dart';


typedef PocketRoute PocketRouteBuilder();

class PocketRoute {
  final WidgetBuilder builder;
  final PocketRouteOptions options;

  const PocketRoute(this.builder, [this.options = const PocketRouteOptions()]);

  static PocketRoute bloc<T extends Bloc>(BlocCreator<T> creator, BlocBuilder<T> builder, [
    PocketRouteOptions options = const PocketRouteOptions()
  ]) {
    return PocketRoute(((context) {
      return BlocProvider.builder(
        creator: creator,
        builder: builder,
      );
    }), options);
  }

  static PocketRoute blocs<T extends Bloc>(List<BlocProvider> creator(), WidgetBuilder builder, [
    PocketRouteOptions options = const PocketRouteOptions()
  ]) {
    return PocketRoute(((context) {
      return BlocProviderTree(
        blocProviders: creator(),
        child: builder(context),
      );
    }), options);
  }

  PocketRoute copyWith({WidgetBuilder builder, PocketRouteOptions options}) {
    return PocketRoute(
      builder??this.builder,
      options == null ? this.options : this.options.copyWith(
        transition: options.transition,
        maintainState: options.maintainState,
      ),
    );
  }
}



/// First Screen please reference [MaterialApp.initialRoute]
/// Complete [MaterialAPP.onGenerateRoute] with  [PocketRouter.onGenerateRoute]
class PocketRouter {
  final HashMap<String, WidgetBuilder> _routes;
  void registers(Map<String, WidgetBuilder> routes) => _routes.addAll(routes);
  void register(String name, WidgetBuilder builder) => _routes[name] = builder;

  PocketRouter.internal({
    HashMap<String, WidgetBuilder> routes,
  }) : this._routes = routes??HashMap();

  static PocketRouter _instance = PocketRouter.internal();

  factory PocketRouter() => _instance;

  RouteFactory onGenerateRouteBuilder({
    PocketRouteOptions initialOptions: const PocketRouteOptions.material(),
    PocketRouteOptions defaultOptions: const PocketRouteOptions.def(),
  }) {
    assert(defaultOptions != null);

    return (RouteSettings settings) {
      var route = settings.arguments != null
          ? settings.arguments as PocketRoute
          : PocketRoute(null, initialOptions);

      route = PocketRoute(
        route.builder??_routes[settings.name],
        route.options == null ? defaultOptions : defaultOptions.copyWith(
          transition: route.options.transition,
          maintainState: route.options.maintainState,
        ),
      );
      assert(route.builder != null, _notExistRoute(settings.name));

      if (route.options.transition == Transition.material) {
        return mt.MaterialPageRoute(
          builder: route.builder,
          settings: settings,
          maintainState: route.options.maintainState,
        );
      } else {
        return cp.CupertinoPageRoute(
          builder: route.builder,
          settings: settings,
          maintainState: route.options.maintainState,
        );
      }
    };
  }

  /// Opens a new screen only if the current screen is not the first one,
  /// otherwise it closes the current screen
  Future<dynamic> pushSecondElseClose(BuildContext context, String name, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return canPop(context) ? pop(context) : await push(context, name, builder: builder, options: options);
  }

  /// Open new Screen
  Future<dynamic> push(BuildContext context, String name, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return await Navigator.pushNamed(context, name, arguments: PocketRoute(builder, options));
  }

  /// Close last screen
  bool pop(BuildContext context) {
    return Navigator.pop(context);
  }

  /// Close last screen in safe Mode
  bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Close all the screens up to the routeName
  void popUntil(BuildContext context, String name) {
    Navigator.popUntil(context, ModalRoute.withName(name),);
  }

  void popToHome(BuildContext context) {
    while (canPop(context)) {
      pop(context);
    }
  }

  void popBeforeMe(BuildContext context, String name) {
    bool isMe = false;
    Navigator.popUntil(context, (route) {
      if (isMe)
        return false;
      if (route.settings.name == name) {
        isMe = true;
      }
      return true;
    });
  }

  /// Close all the screens and push screen
  Future<Object> pushAndRemoveAll(BuildContext context, String name, {
    WidgetBuilder builder,
    PocketRouteOptions options: const PocketRouteOptions(transition: Transition.material),
  }) async {
    return await pushAndRemoveUntil(context, name, (_) => false,
      builder: builder,
      options: options,
    );
  }

  /// Close all the screens up to the routeName and push screen
  Future<Object> pushAndRemoveUntilRoute(BuildContext context, String name, String closeName, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return await pushAndRemoveUntil(context, name, ModalRoute.withName(closeName),
      builder: builder, options: options,
    );
  }

  /// Close all the screens up to the [RoutePredicate] and push screen
  Future<Object> pushAndRemoveUntil(BuildContext context, String name, RoutePredicate predicate, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil(context, name, predicate,
      arguments: PocketRoute(builder, options),
    );
  }

  /// Replace current screen with a destroy animation for current screen
  Future<Object> pushReplacement(BuildContext context, String name, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return await Navigator.pushReplacementNamed(context, name,
      arguments: PocketRoute(builder, options),
    );
  }

  /// Replace current screen with swipe animation for current screen
  Future<dynamic> popAndPush(BuildContext context,  String name, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    return await Navigator.popAndPushNamed(context, name, arguments: PocketRoute(builder, options),);
  }

  Future<dynamic> pushBloc<B extends Bloc>(BuildContext context, String name, {
    @required BlocCreator<B> creator, BlocBuilder<B> builder, PocketRouteOptions options,
  }) async {
    return await push(context, name,
      builder: (_context) => BlocProvider.builder(
        creator: creator,
        builder: builder??(__context, _) {
          final _builder = _routes[name];
          assert(_builder != null, _notExistRoute(name));
          return _builder(_context);
        },
      ),
    );
  }

  String _notExistRoute(String route) => "Not exist route '$route'";

  Future<void> drawerPush(BuildContext context, String name, {
    WidgetBuilder builder, PocketRouteOptions options,
  }) async {
    popToHome(context);
    await push(context, name);
  }
}