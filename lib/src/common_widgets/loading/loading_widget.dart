import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitSpinningCircle(
          color: Colors.blue.shade300,
          size: DimensionsCustom.calculateWidth(12.5),
        ),
      ),
    );
  }
}
