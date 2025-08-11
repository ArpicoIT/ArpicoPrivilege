import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({super.key});

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await launchUrl(
          Uri.parse("https://www.arpico.com/contents/about_us_overview.php"),
          mode: LaunchMode.externalApplication);
      // await launchUrlString("https://www.arpico.com/contents/about_us_overview.php");
    });
  }

  AppBar get appBar => AppBar(
        title: Text("About Us"),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}
