import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_tasks_list.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  String? username;
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    userId = _auth.getCurrentUserId();
    if (userId != null) {
      String? fetchedUsername = await _auth.getUsernameById(userId!);
      setState(() {
        username = fetchedUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              if (username != null)
                Text(
                  'Hallo $username',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorDarkGray),
                )
              else
                const CircularProgressIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TaskList(userId: userId),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: 'Abmelden',
                onPressed: () async {
                  await _auth.signOut();
                },
                type: ButtonType.primary,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
