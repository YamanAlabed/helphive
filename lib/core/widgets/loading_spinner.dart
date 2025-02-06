import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helphive_flutter/core/theme/colors.dart';

class Loading extends StatelessWidget {
  final Color backgroundColor;
  final double size;

  const Loading({
    super.key,
    this.backgroundColor = colorDarkGray,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitChasingDots(
          color: colorSoftWhite,
          size: size,
        ),
      ),
    );
  }
}
