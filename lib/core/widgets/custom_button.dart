import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/theme/styles.dart';

enum ButtonType { primary, secondary, alert }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final double width;
  final double height;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.width = 250,
    this.height = 45.0,
    super.key,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.secondary:
        return colorSoftGreen;
      case ButtonType.alert:
        return colorLightPink;
      case ButtonType.primary:
      return colorDarkGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorSoftWhite,
          backgroundColor: _getBackgroundColor(),
          textStyle: buttonTextStyle(context),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
