import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final IconData optionIcon;
  final Color optionColor;
  final String title;

  final VoidCallback onPress;

  const OptionWidget(
      {super.key,
      required this.title,
      required this.optionIcon,
      required this.optionColor,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: DimensionsCustom.calculateWidth(4),
            vertical: DimensionsCustom.calculateHeight(1.5)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              optionIcon,
              size: DimensionsCustom.calculateWidth(9),
              color: optionColor,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: DimensionsCustom.calculateWidth(2.5)),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: DimensionsCustom.calculateWidth(4),
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
