
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  AppBar get appBar => AppBar(
    title: Text("Privacy Policy"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}