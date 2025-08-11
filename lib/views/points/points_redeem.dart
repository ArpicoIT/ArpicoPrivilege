import 'package:flutter/material.dart';

class PointsRedeem extends StatefulWidget {
  const PointsRedeem({super.key});

  @override
  State<PointsRedeem> createState() => _PointsRedeemState();
}

class _PointsRedeemState extends State<PointsRedeem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Redeem")),
    );
  }
}
