

/*
typedef Widget RouteBuilder(EasyRoute params);



class Sailor {
  final Map<String, RouteBuilder> routes;

  Sailor(this.routes) : assert(routes != null && routes.isEmpty, "Crea il tuo path di route");

  /// Add it to MaterialApp for automatic generation
  /// onGenerateRoute: onGenerateRoute,
  Route<dynamic> onGenerateRoute<T extends EasyRoute>(RouteSettings settings) {
    return CupertinoPageRoute<T>(
      builder: (context) {
        final screenBuilder = routes[settings.name];
        return screenBuilder != null ?
          screenBuilder(settings.arguments) :
          Material(child: Center(child: Text("Page Not Found",),),);
      },
      settings: settings,
    );
  }

  /// Open new Screen
  static Future<dynamic> pushNamed(BuildContext context, EasyRoute params) async {
    return Navigator.pushNamed(context, params.name, arguments: params,);
  }

  /// Close all the screens up to the screen route
  static Future<dynamic> popUntil(BuildContext context, String route) async {
    return Navigator.popUntil(context, ModalRoute.withName(route),);
  }

  final Lock _lockSwipeBack = Lock();

  /// Opens a new screen in safe mode
  Future openScreen(BuildContext context, Widget screen, {isMaterial: false, isDrawerOpen: false}) async {
    return _lockSwipeBack.synchronized(() async {
      final navigator = Navigator.of(context);
      if (isDrawerOpen) navigator.pop();
      final PageRoute pageRoute = isMaterial ?
      MaterialPageRoute(builder: (_) => screen) :
      CupertinoPageRoute(builder: (_) => screen);

      await SwipeBackObserver.promise?.future;

      return await navigator.push(pageRoute);
    });
  }
}


abstract class EasyRoute {
  String get name;
  final Key key;

  EasyRoute(this.key);
}*/




