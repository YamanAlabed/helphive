import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/theme/styles.dart';

class GreetingWidget extends StatelessWidget {
  final String username;

  const GreetingWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Hallo $username!',
            style: greatingTextStyle(context),
          ),
        ),
        const SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'schön, dass du da bist. ',
                style: greatingSubtitleTextStyle(context),
              ),
              const SizedBox(height: 20),
              Text(
                'Stärke den Zusammenhalt in deiner Nachbarschaft!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: slateBlue),
              ),
            ],
          ),
          ),
          
      ],
    );
  }
}
