import 'package:flutter/material.dart';

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  AppBar get appBar => AppBar(
    title: Text("Permissions"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}
