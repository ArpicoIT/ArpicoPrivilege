import 'package:flutter/material.dart';

class AppLockView extends StatelessWidget {
  const AppLockView({super.key});

  AppBar get appBar => AppBar(
    title: Text("App Lock"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}
