import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../app/app_settings.dart';
import '../../data/models/tile_data.dart';
import '../../shared/components/selectors/theme_mode_selector.dart';
import '../../core/extentions/string_extensions.dart';
import 'settings.dart';

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  AppPreferences appSettings = AppPreferences();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        appSettings = AppPreferences.defaultSettings;
        setState(() {});
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  List<TileData> get _basicTileData {
    return [
      TileData(
        title: "Theme Mode",
        leadingIcon: Icons.wb_sunny,
        trailingText: appSettings.themeMode.name.toUpperCaseFirst(),
        onTap: () => openThemeModePicker(),
      ),
      TileData(
        title: "Country & Region",
        leadingIcon: Icons.language,
        trailingText: appSettings.country ?? "--",
        // onTap: (){},
      ),
      TileData(
        title: "Language",
        leadingIcon: Icons.translate,
        trailingText: appSettings.language ?? "--",
        // onTap: (){},
      ),
      TileData(
        title: "Currency",
        leadingIcon: Icons.attach_money,
        trailingText:
            "${(appSettings.currency) ?? "--"} / ${(appSettings.currencyShort) ?? "--"}",
        // onTap: (){},
      ),
    ];
  }

  /// functions widgets
  void openThemeModePicker() async {
    final themeMode = await showThemeModePicker(
      context: context,
      initialValue: appSettings.themeMode,
    );

    if (themeMode != null) {
      appSettings.themeMode = themeMode;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingsView.buildSection(context, dataList: _basicTileData),
          ],
        ),
      ),
    );
  }
}
