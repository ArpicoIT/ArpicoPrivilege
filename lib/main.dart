import 'dart:async';
import 'dart:io';

import 'package:arpicoprivilege/core/services/storage_service.dart';
import 'package:arpicoprivilege/handler.dart';
import 'package:arpicoprivilege/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/services/cloud_messaging_service.dart';
import 'core/services/shared_prefs_service.dart';
import 'firebase_options.dart';
import 'app/app.dart';
import 'core/providers/loading_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/configure_service.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  await SharedPrefsService.init();

  /// Loading configures
  final configService = ConfigService();
  await configService.loadEndpoints();
  await configService.loadConfig();

  /// Initialize appAlerts
  await appAlerts.loadAlerts('assets/alert/alerts_localized.json');

  /// Initialize timeago
  timeago.setDefaultLocale('en_short');
  // timeago.setDefaultLocale('en');

  /// device information
  String? uuid = await getDeviceId();
  debugPrint("DEVICE ID: $uuid");

  /// Load messaging token
  await setupFirebaseMessaging();

  // try {
  //   final String? token = await FirebaseMessaging.instance.getToken()
  //       .onError((error, _) => null).timeout(Duration(seconds: 2));
  //   debugPrint(token);
  // } catch (e){
  //   debugPrint(e.toString());
  // }

  /// testing
  // await setAccessTokenToStorage(TEST_TOKEN);
  // StorageService.instance.deleteAll();

  /// testing Data
  // final localJsonService = LocalJsonService();
  // final bills = await localJsonService.getEBills();

  // Lock orientation dynamically at runtime
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]).then((_) {
  //   runApp(MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider(create: (context) => ThemeProvider()),
  //       // ChangeNotifierProvider(create: (context) => LoadingProvider()),
  //     ],
  //     child: const App(),
  //   ));
  // });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const App(),
  ));
}
