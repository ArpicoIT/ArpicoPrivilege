
import 'package:flutter/material.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  AppBar get appBar => AppBar(
    title: Text("Terms of Service"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}