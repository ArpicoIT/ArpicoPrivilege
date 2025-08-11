import 'package:flutter/material.dart';
import 'package:localized_alerts/localized_alerts.dart' as appAlerts;

import '../app/app_routes.dart';
import '../core/services/configure_service.dart';
import '../l10n/app_translator.dart';
import '../shared/components/app_name.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final configService = ConfigService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor?.withAlpha(0),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height * 0.54),
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/intro-background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                    child: Container(color: Colors.black.withAlpha(50))
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                color: colorScheme.surface,
              ),
              child: Flex(
                  direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppName(sloganVisibility: true),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signin),
                            style: TextButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              iconColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))
                            ),
                            label: Text("Let's Start"),
                            icon: Icon(Icons.navigate_next),
                            iconAlignment: IconAlignment.end,
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: TextButton.icon(
                        //     onPressed: () async {
                        //       await appAlerts.showAlertById(context, 'eBillRegistered', (key) => AppTranslator.of(context).call(key));
                        //     },
                        //     style: TextButton.styleFrom(
                        //         backgroundColor: colorScheme.secondary,
                        //         foregroundColor: colorScheme.onSecondary,
                        //         iconColor: colorScheme.onSecondary,
                        //         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36))
                        //     ),
                        //     label: Text("Test Alert"),
                        //     icon: Icon(Icons.navigate_next),
                        //     iconAlignment: IconAlignment.end,
                        //   ),
                        // ),
                      ],
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Powered by",
                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${configService.getConfig("appInfo")["department"]} - ${configService.getConfig("appInfo")["company"]}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Version ${configService.getConfig("appInfo")["version"]}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
