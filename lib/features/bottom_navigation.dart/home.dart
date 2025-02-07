// Import to generate random numbers
import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/constants/categories.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/theme/styles.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_greeting.dart';
import 'package:helphive_flutter/core/widgets/custom_tasks_list.dart';
import 'package:helphive_flutter/core/widgets/horizontal_list.dart';
import 'package:helphive_flutter/features/tasks/create.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = '';
  String? selectedCategory; // Add this variable to store selected category

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() async {
    String? userId = AuthService().getCurrentUserId();
    if (userId != null) {
      String? fetchedUsername = await AuthService().getUsernameById(userId);
      setState(() {
        username = fetchedUsername ?? 'Unknown User';
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // Add this widget to display greeting
                      GreetingWidget(username: username),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Hilf mit – deine Hilfe macht den Unterschied.',
                          style: secondTextStyle(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HorizontalListWidget(
                          items: categories,
                          onCategorySelected: (category) {
                            setState(() {
                              // Toggle selected category
                              if (selectedCategory == category) {
                                selectedCategory = null;
                              } else {
                                selectedCategory = category;
                              }
                            });
                          },
                        ),
                      ),
                      // Add this widget to display tasks
                      TaskList(selectedCategory: selectedCategory),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: 'Hilfe anfordern',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Create();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
