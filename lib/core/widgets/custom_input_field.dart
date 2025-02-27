import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/theme/styles.dart';

class CustomTextField extends StatelessWidget {

  // CustomTextField constructor
  
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final Function? toggleVisibility;
  final EdgeInsetsGeometry contentPadding;
  final Color borderColor;
  final int? maxLines;
  final TextInputType keyboardType;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.toggleVisibility,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 16.0,
      horizontal: 12.0,
    ),
    this.borderColor = colorCoolGray,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: false,
      maxLines: maxLines, // Allows the field to grow as needed
      keyboardType: keyboardType, // Multi-line input type
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: normalTextStyle(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
        prefixIcon: Icon(
          icon,
          color: colorDarkGray,
        ),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: colorDarkGray,
                ),
                onPressed: () => toggleVisibility!(),
              )
            : null,
        contentPadding: contentPadding,
      ),
      style: normalTextStyle(context),
    );
  }
}
