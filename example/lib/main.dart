import 'package:flutter/material.dart';
import 'package:easy_route/easy_route.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.ROUTE,
      onGenerateRoute: EasyRouter.onGenerateRouteBuilder((_) => HomeScreen(), HomeScreen.ROUTE),
      navigatorObservers: <NavigatorObserver>[ SwipeBackObserver(), ],
    );
  }
}


class HomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "HomeScreen";
  @override
  String get route => HomeScreen.ROUTE;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: InkWell(
          radius: 200,
          onTap: () => EasyRouter.push(context, SecondScreen()),
          child: Text("Home Screen"),
        ),
      ),
    );
  }
}


class SecondScreen extends StatelessWidget implements WidgetRoute {
  static const ROUTE = 'second';
  @override
  String get route => ROUTE;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green,
      child: Center(
        child: InkWell(
          radius: 200,
          onTap: () => EasyRouter.popAndPush(context, AnotherScreen()),
          child: Text("Second Screen"),
        ),
      ),
    );
  }
}


class AnotherScreen extends StatelessWidget implements WidgetRoute {
  static const ROUTE = 'another';
  @override
  String get route => ROUTE;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow,
      child: Center(
        child: InkWell(
          radius: 200,
          onTap: () => EasyRouter.popUntil(context, HomeScreen.ROUTE),
          child: Text("Another Screen"),
        ),
      ),
    );
  }
}