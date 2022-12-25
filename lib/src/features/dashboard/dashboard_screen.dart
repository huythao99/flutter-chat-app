import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // nested routes will be rendered here
          child: AutoRouter(),
        )
      ],
    );
  }
}
