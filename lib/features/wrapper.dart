import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helphive_flutter/features/auth/authentication.dart';
import 'package:helphive_flutter/features/bottom_navigation.dart/nav_controller.dart';
import 'package:helphive_flutter/core/models/user.dart' as custom;

import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    // get the custom user from the Provider
    final user = Provider.of<custom.User?>(context);
    if (kDebugMode) {
      print(user);
    }
    // Return either Home or Authenticate widget based on user state
    if (user == null) {
      return const Authenticate(); // User is not logged in, show Authenticate screen
    } else {
      return const BottomNavigationBarWidget(); // User is logged in, show Home screen
    }
  }
}
