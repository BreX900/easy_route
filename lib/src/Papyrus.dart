import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Papyrus extends Navigator {
  Papyrus({Key key, @required WidgetRoute home}) : assert(home != null), super(
    key: key,
    initialRoute: home.route,
    onGenerateRoute: EasyRouter.onGenerateRoute(home),
  );
}


class PapyrusApp extends MaterialApp {
  PapyrusApp({
    Key key,
    GlobalKey<NavigatorState>  navigatorKey,
    WidgetRoute home,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
    TransitionBuilder builder,
    String title: '',
    GenerateAppTitle onGenerateTitle,
    Color color,
    ThemeData theme,
    ThemeData darkTheme,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleListResolutionCallback localeListResolutionCallback,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
  }) : super(
    key: key,
    navigatorKey: navigatorKey,
    initialRoute: home.route,
    onGenerateRoute: EasyRouter.onGenerateRoute(home),
    navigatorObservers: navigatorObservers,
    builder: builder,
    title: title,
    onGenerateTitle: onGenerateTitle,
    color: color,
    theme: theme,
    darkTheme: darkTheme,
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    localeListResolutionCallback: localeListResolutionCallback,
    localeResolutionCallback: localeResolutionCallback,
    supportedLocales: supportedLocales,
    debugShowMaterialGrid: debugShowMaterialGrid,
    showPerformanceOverlay: showPerformanceOverlay,
    checkerboardRasterCacheImages: checkerboardRasterCacheImages,
    checkerboardOffscreenLayers: checkerboardOffscreenLayers,
    showSemanticsDebugger: showSemanticsDebugger,
    debugShowCheckedModeBanner: debugShowCheckedModeBanner,
  );
}