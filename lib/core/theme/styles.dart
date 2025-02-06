// lib/core/theme/styles.dart

import 'package:flutter/material.dart';
import 'colors.dart';  // Importiere die Farben

TextStyle largeBoldTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 46 : 36;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
    fontWeight: FontWeight.bold,
  );
}

TextStyle normalTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 14 : 12;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
  );
}

TextStyle secondTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 20 : 16;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
    fontWeight: FontWeight.bold,
  );
}

TextStyle buttonTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 16 : 14;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
    fontWeight: FontWeight.bold,
  );
}

TextStyle errorTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 16 : 12;
  return TextStyle(
    color: Colors.red,
    fontSize: fontSize,
  );
}

TextStyle cardTitleTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 18 : 14;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
    fontWeight: FontWeight.bold,
  );
}

TextStyle cardSubtitleTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 14 : 12;
  return TextStyle(
    fontSize: fontSize,
    // ignore: deprecated_member_use
    color: colorDarkGray.withOpacity(0.7),
  );
}

TextStyle cardDateTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 12 : 9;
  return TextStyle(
    fontSize: fontSize,
    // ignore: deprecated_member_use
    color: colorDarkGray.withOpacity(0.7),
  );
}

TextStyle greatingTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 26 : 20;
  return TextStyle(
    fontSize: fontSize,
    color: colorDarkGray,
    fontWeight: FontWeight.w600,
  );
}

TextStyle greatingSubtitleTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 16 : 14;
  return TextStyle(
    fontSize: fontSize,
    color: colorCoolGray,
    fontWeight: FontWeight.normal,
  );
}

TextStyle newMarkTextStyle(BuildContext context) {
  double fontSize = MediaQuery.of(context).size.width > 400 ? 12 : 9;
  return TextStyle(
    fontSize: fontSize,
    color: colorSoftWhite,
    fontWeight: FontWeight.bold,
  );
}
