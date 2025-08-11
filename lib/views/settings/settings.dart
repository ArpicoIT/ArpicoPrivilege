import 'package:arpicoprivilege/core/extentions/string_extensions.dart';
import 'package:arpicoprivilege/shared/components/buttons/primary_button.dart';
import 'package:arpicoprivilege/shared/components/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../app/app_routes.dart';
import '../../core/constants/loyalty_tier.dart';
import '../../core/services/configure_service.dart';
import '../../data/mixin/authentication_mixin.dart';
import '../../data/models/tile_data.dart';
import '../../data/models/user.dart';
import '../../data/repositories/app_cache_repository.dart';
import '../../shared/components/app_text.dart';
import '../../shared/components/buttons/action_icon_button.dart';
import '../../shared/components/empty_placeholder.dart';
import '../../shared/components/images/user_avatar.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @protected
  static Widget buildTile(BuildContext context, TileData tileData) {
    return ListTile(
      onTap: tileData.onTap,
      leading: tileData.leadingIcon != null ? Icon(tileData.leadingIcon) : null,
      title: Text(tileData.title!),
      subtitle: (tileData.subtitle != null)
          ? Text(tileData.subtitle!, overflow: TextOverflow.ellipsis)
          : null,
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ((tileData.trailingText ?? '').isNotEmpty)
              ? Text(tileData.trailingText!, style: TextStyle(fontSize: 16))
              : const SizedBox.shrink(),
          const SizedBox(width: 12),
          const Icon(Icons.navigate_next),
        ],
      ),
      tileColor: Theme.of(context).colorScheme.surface,
      shape: Border(),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  static Widget buildSection(BuildContext context,
      {String? title, required List<TileData> dataList}) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ...dataList
              .asMap()
              .map((i, tileData) => MapEntry(
                  i,
                  Column(
                    children: [
                      (i != 0)
                          ? Divider(height: 0, indent: 16, endIndent: 16)
                          : const SizedBox.shrink(),
                      buildTile(context, tileData),
                    ],
                  )))
              .values
        ],
      ),
    );
  }

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> with AuthenticationMixin {
  final configService = ConfigService();
  LoyaltyTier userTier = LoyaltyTier.unknown;
  User? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialize();
    });
  }

  void initialize() async {
    try {
      setState(() {
        user = AppCacheRepository.loadUserCache();
        userTier = LoyaltyTier.getTier(user?.cardTypeId);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<TileData> get _generalSettingsTileData {
    final navigator = Navigator.of(context);

    return [
      TileData(
        title: "Your Information",
        subtitle: "Profile, Contacts, Address",
        leadingIcon: Icons.person,
        onTap: () async {
          final result = await navigator.pushNamed(AppRoutes.accountInfo);

          if (result == true) {
            initialize();
          }
        },
      ),
      TileData(
        title: "Preferences",
        subtitle: "Theme, Country & Region, Language, Currency",
        leadingIcon: Icons.tune,
        onTap: () => navigator.pushNamed(AppRoutes.preferences),
      ),
    ];
  }

  List<TileData> get _securityAndPrivacyTileData {
    final navigator = Navigator.of(context);

    return [
      TileData(
        title: "App Lock",
        subtitle: "PIN, Biometric",
        leadingIcon: Icons.security,
        onTap: () => navigator.pushNamed(AppRoutes.appLock),
      ),
      TileData(
        title: "Permissions",
        subtitle: "Camera, Notifications, Location",
        leadingIcon: Icons.privacy_tip_outlined,
        onTap: () => navigator.pushNamed(AppRoutes.permissions),
      ),
      TileData(
        title: "Linked Devices",
        subtitle: "Manage linked devices",
        leadingIcon: Icons.devices_other,
        onTap: () => navigator.pushNamed(AppRoutes.linkedDevices),
      ),
    ];
  }

  List<TileData> get _supportAndLegalTileData {
    final navigator = Navigator.of(context);

    return [
      TileData(
        title: "Help Center",
        subtitle: "Get support and FAQs",
        leadingIcon: Icons.support_agent,
        onTap: () => navigator.pushNamed(AppRoutes.helpCenter),
      ),
      TileData(
        title: "Feedback",
        subtitle: "Share your thoughts with us",
        leadingIcon: Icons.feedback,
        onTap: () => navigator.pushNamed(AppRoutes.feedback),
      ),
      TileData(
        title: "About Us",
        subtitle: "Learn more about our company",
        leadingIcon: Icons.info,
        // onTap: () => navigator.pushNamed(AppRoutes.aboutUs),
        onTap: () async => launchUrl(
            Uri.parse("https://www.arpico.com/contents/about_us_overview.php"),
            mode: LaunchMode.externalApplication),
        //await launchUrlString(
        //    "https://www.arpico.com/contents/about_us_overview.php"),
      ),
      TileData(
        title: "Terms of Service",
        subtitle: "Review our usage terms",
        leadingIcon: Icons.receipt_long,
        onTap: () => navigator.pushNamed(AppRoutes.termsOfService),
      ),
      TileData(
          title: "Privacy Policy",
          subtitle: "Understand how we handle your data",
          leadingIcon: Icons.privacy_tip,
          // onTap: () => navigator.pushNamed(AppRoutes.privacyPolicy),
          onTap: () async => launchUrl(
              Uri.parse("https://www.arpico.com/privacy/privacy-policy.pdf"),
              mode: LaunchMode.externalApplication)
          // await launchUrlString(
          //     "https://www.arpico.com/privacy/privacy-policy.pdf "),
          ),
      // TileData(
      //   title: "Report a Problem",
      //   onTap: () => navigator.pushNamed(AppRoutes.reportProblem),
      // ),
    ];
  }

  Widget buildFooter() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              children: [
                const TextSpan(
                  text: "- Powered by -\n",
                  // style: Theme.of(context).textTheme.bodySmall?.getTextStyle()
                ),
                TextSpan(
                  text:
                      "${configService.getConfig("appInfo")["department"]} - ${configService.getConfig("appInfo")["company"]}\n",
                ),
                TextSpan(
                  text:
                      "version ${configService.getConfig("appInfo")["version"]}",
                )
              ])),
    );
  }

  Widget buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FlexibleSpaceBar(
      title: Container(
        margin: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
              child: const SizedBox(
                height: 72.0,
                width: 78.0,
                child: Stack(
                  children: [
                    UserAvatar(
                      avatar: null,
                      userName: 'Gayan',
                      radius: 36.0,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.camera_alt_outlined))
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Gayan Weerasinghe",
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text("+94710930444"),
              ],
            )),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final topPadding = MediaQuery.of(context).viewPadding.top;
        bool titleVisibility =
            constraints.maxHeight <= kToolbarHeight + topPadding;

        return FlexibleSpaceBar(
          title: titleVisibility
              ? Padding(
                  padding: const EdgeInsets.only(left: 0), // 16
                  child: Text("Settings"), // Account Settings
                )
              : null,
          // centerTitle: true,
          background: Container(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            margin: EdgeInsets.only(top: kToolbarHeight + topPadding),
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 84.0,
                    width: 84.0,
                    child: Stack(
                      children: [
                        UserAvatar(
                          avatar: null,
                          userName: user?.custFullName,
                          radius: 48.0,
                        ),
                        // Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: Icon(Icons.camera_alt_outlined)
                        // )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((user?.custFullName ?? '---- ----').toTitleCase(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      // const SizedBox(height: 4),
                      // Text(user?.custMobNo1 ?? 'xxx-xxx-x-xxx',
                      //     style: TextStyle()),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: userTier.primaryColor),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_events,
                                color: userTier.tertiaryColor),
                            const SizedBox(width: 8),
                            Text(userTier.label,
                                style:
                                    TextStyle(color: userTier.tertiaryColor)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: true,
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: appBar(),
            actions: [
              ActionIconButton.of(context)
                  .menu(items: ['home', 'notifications']),
              // IconButton(
              //     onPressed: () => logout(context),
              //     icon: Icon(Icons.logout)),
            ],
          ),
          SliverList.list(children: [
            SettingsView.buildSection(context,
                title: "General Settings", dataList: _generalSettingsTileData),
            const SizedBox(height: 12),
            // SettingsView.buildSection(context, title: "Security & Privacy", dataList: _securityAndPrivacyTileData),
            // const SizedBox(height: 12),
            SettingsView.buildSection(context,
                title: "Support & Legal", dataList: _supportAndLegalTileData),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: PrimaryButton.outline(
                  text: "Log Out",
                  onPressed: () => logout(context),
                  color: Theme.of(context).colorScheme.onSurface),
            ),
            buildFooter(),
          ])
        ],
      ),
    );
  }
}
