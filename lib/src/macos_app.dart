import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/material.dart' as m;

/// Defines an application that uses macOS design
///
/// todo: Documentation
class MacosApp extends StatefulWidget {
  const MacosApp({
    Key? key,
    this.navigatorKey,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.pageRouteBuilder,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.primaryColor,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = true,
    this.inspectorSelectButtonBuilder,
    this.shortcuts,
    this.actions,
    this.style,
    this.darkStyle,
    this.themeMode,
  })  : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        super(key: key);

  MacosApp.router({
    Key? key,
    this.style,
    this.darkStyle,
    this.themeMode,
    this.routeInformationProvider,
    required this.routeInformationParser,
    required this.routerDelegate,
    BackButtonDispatcher? backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    required Color this.primaryColor,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowWidgetInspector = false,
    this.debugShowCheckedModeBanner = true,
    this.inspectorSelectButtonBuilder,
    this.shortcuts,
    this.actions,
  })  : assert(routeInformationParser != null && routerDelegate != null,
            'The routeInformationParser and routerDelegate cannot be null.'),
        assert(supportedLocales.isNotEmpty),
        navigatorObservers = null,
        backButtonDispatcher =
            backButtonDispatcher ?? RootBackButtonDispatcher(),
        navigatorKey = null,
        onGenerateRoute = null,
        pageRouteBuilder = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null,
        super(key: key);

  final Map<Type, Action<Intent>>? actions;

  final BackButtonDispatcher? backButtonDispatcher;

  final TransitionBuilder? builder;

  final bool checkerboardOffscreenLayers;

  final bool checkerboardRasterCacheImages;

  final Style? darkStyle;

  static bool debugAllowBannerOverride = true;

  final bool debugShowCheckedModeBanner;

  final bool debugShowWidgetInspector;

  static bool debugShowWidgetInspectorOverride = false;

  final Widget? home;

  final String? initialRoute;

  final InspectorSelectButtonBuilder? inspectorSelectButtonBuilder;

  final Locale? locale;

  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final GlobalKey<NavigatorState>? navigatorKey;

  final List<NavigatorObserver>? navigatorObservers;

  final InitialRouteListFactory? onGenerateInitialRoutes;

  final RouteFactory? onGenerateRoute;

  final GenerateAppTitle? onGenerateTitle;

  final RouteFactory? onUnknownRoute;

  final PageRouteFactory? pageRouteBuilder;

  final Color? primaryColor;

  final RouteInformationParser<Object>? routeInformationParser;

  final RouteInformationProvider? routeInformationProvider;

  final RouterDelegate<Object>? routerDelegate;

  final Map<String, WidgetBuilder>? routes;

  final Map<LogicalKeySet, Intent>? shortcuts;

  final bool showPerformanceOverlay;

  static bool showPerformanceOverlayOverride = false;

  final bool showSemanticsDebugger;

  final Style? style;

  final Iterable<Locale> supportedLocales;

  final ThemeMode? themeMode;

  final String title;

  @override
  _MacosAppState createState() => _MacosAppState();
}

class _MacosAppState extends State<MacosApp> {
  bool get _usesRouter => widget.routerDelegate != null;

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }

  Style theme(BuildContext context) {
    final mode = widget.themeMode ?? ThemeMode.system;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDarkStyle = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && platformBrightness == Brightness.dark);

    Style data =
        (useDarkStyle ? (widget.darkStyle ?? widget.style) : widget.style) ??
            Style.fallback(useDarkStyle ? Brightness.dark : Brightness.light);
    if (data.brightness == null) {
      data = data.copyWith(Style(
        brightness: useDarkStyle ? Brightness.dark : Brightness.light,
      ));
    }
    return data.build();
  }

  Widget _builder(BuildContext context, Widget? child) {
    final theme = this.theme(context);
    return m.Material(
      child: MacosTheme(
        style: theme,
        child: DefaultTextStyle(
          style: TextStyle(
            color: theme.typography?.body?.color,
          ),
          child: child!,
        ),
      ),
    );
  }

  Widget _buildApp(BuildContext context) {
    final defaultColor = widget.primaryColor ?? CupertinoColors.systemBlue;
    if (_usesRouter) {
      return m.MaterialApp.router(
        key: GlobalObjectKey(this),
        routeInformationProvider: widget.routeInformationProvider,
        routeInformationParser: widget.routeInformationParser!,
        routerDelegate: widget.routerDelegate!,
        backButtonDispatcher: widget.backButtonDispatcher,
        builder: _builder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        color: defaultColor,
        locale: widget.locale,
        localeResolutionCallback: widget.localeResolutionCallback,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        supportedLocales: widget.supportedLocales,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
      );
    }
    return m.MaterialApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      navigatorObservers: widget.navigatorObservers!,
      home: widget.home,
      routes: widget.routes!,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      builder: _builder,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      color: defaultColor,
      locale: widget.locale,
      localeResolutionCallback: widget.localeResolutionCallback,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      supportedLocales: widget.supportedLocales,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
    );
  }
}
