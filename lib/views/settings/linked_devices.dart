import 'package:flutter/material.dart';

class LinkedDevicesView extends StatelessWidget {
  const LinkedDevicesView({super.key});

  AppBar get appBar => AppBar(
    title: Text("Linked Devices"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(),
    );
  }
}
