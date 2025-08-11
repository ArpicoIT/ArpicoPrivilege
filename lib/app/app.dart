import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/providers/theme_provider.dart';
import '../core/services/configure_service.dart';
import '../core/services/storage_service.dart';
import '../l10n/app_localizations.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.9)),
    // SystemChrome.setSystemUIOverlayStyle(
    //         SystemUiOverlayStyle(
    //           // statusBarColor: _themeMode == ThemeMode.light ? Colors.green : Colors.red,
    //           statusBarColor: Colors.transparent,
    //           statusBarIconBrightness: themeProvider.themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    //           statusBarBrightness: themeProvider.themeMode == ThemeMode.light ? Brightness.light : Brightness.dark,
    //         ),
    //       );

    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    // TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    // MaterialTheme theme = MaterialTheme(textTheme);

    return FutureBuilder(
      future: _appRouteInitialize(),
      initialData: AppRoutes.initialRoute,
      builder: (context, snapshot) {

        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            final configService = ConfigService();

            // if(snapshot.connectionState != ConnectionState.done){
            //   return Material(
            //     child: Center(
            //       child: CupertinoActivityIndicator(),
            //     ),
            //   );
            // }

            return MaterialApp(
              key: ValueKey(snapshot.data),
              title: configService.getConfig('appInfo')['name'],
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeProvider.themeMode,
              initialRoute: snapshot.data,
              // initialRoute: AppRoutes.initialRoute,
              routes: AppRoutes.generate,
              onUnknownRoute: AppRoutes.unknown,
              navigatorObservers: [RouteObserverService()],
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
                  child: child!,
                );
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('en'),
            );
          },
        );
      }
    );

  }

  Future<String> _appRouteInitialize() async {
    try {
      final accessToken = await StorageService.instance.read("access_token");
      return accessToken != null ? AppRoutes.appHome : AppRoutes.intro;
    } catch (e) {
      return AppRoutes.intro;
    }
  }
}

class RouteObserverService extends NavigatorObserver {
  static String? currentRoute;
  static String? previousRoute;

  void _updateRoutes(Route<dynamic>? newRoute, Route<dynamic>? oldRoute) {
    currentRoute = newRoute?.settings.name;
    previousRoute = oldRoute?.settings.name;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoutes(route, previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoutes(previousRoute, route);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateRoutes(newRoute, oldRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // You may want to clear or update currentRoute here depending on your app logic
    _updateRoutes(null, route);
    super.didRemove(route, previousRoute);
  }
}

/*
class RouteObserverService extends NavigatorObserver {
  static String? currentRoute;
  static String? previousRoute;

  final int maxSameNamedRoutes;
  final Map<String, List<Route<dynamic>>> _routeMap = {};

  RouteObserverService({this.maxSameNamedRoutes = 3});

  void _updateRoutes(Route<dynamic>? newRoute, Route<dynamic>? oldRoute) {
    currentRoute = newRoute?.settings.name;
    previousRoute = oldRoute?.settings.name;
  }

  void _trackRoute(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null || route == null) return;

    final list = _routeMap.putIfAbsent(name, () => []);
    list.add(route);

    if (list.length > maxSameNamedRoutes) {
      final routeToRemove = list.removeAt(0);
      // Delay removal until after push completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator?.canPop() ?? false) {
          try {
            navigator?.removeRoute(routeToRemove);
          } catch (_) {
            // safely ignore if already removed or active
          }
        }
      });
    }
  }

  void _untrackRoute(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null || route == null) return;
    _routeMap[name]?.remove(route);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoutes(route, previousRoute);
    _trackRoute(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoutes(previousRoute, route);
    _untrackRoute(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateRoutes(newRoute, oldRoute);
    _untrackRoute(oldRoute);
    _trackRoute(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoutes(null, route);
    _untrackRoute(route);
    super.didRemove(route, previousRoute);
  }
}
*/


