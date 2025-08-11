import 'package:arpicoprivilege/app/app_routes.dart';
import 'package:flutter/material.dart';

class TestRoute extends StatelessWidget {
  const TestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.testRoute),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey
            ),
            child: Text("Next")),
      ),
    );
  }
}
