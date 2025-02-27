import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/services/database_services.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/theme/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helphive_flutter/features/tasks/details.dart';
import 'package:helphive_flutter/features/tasks/edit.dart';
import 'package:intl/intl.dart';

class CustomCard extends StatelessWidget {
  final String postId;
  final String userId;
  final String title;
  final String description;
  final String street;
  final String when;
  final String whatsappNumber;
  final Timestamp createdAt;
  final String imageUrl;

  const CustomCard({
    super.key,
    required this.postId,
    required this.userId,
    required this.title,
    required this.description,
    required this.street,
    required this.when,
    required this.whatsappNumber,
    required this.createdAt,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(

      // Get the username by user ID
      
      future: AuthService().getUsernameById(userId),
      builder: (context, usernameSnapshot) {
        if (usernameSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        String postUsername = usernameSnapshot.data ?? 'Unknown User';
        final date = DateFormat('dd MMM yyyy').format(createdAt.toDate());
        final isNew = DateTime.now().difference(createdAt.toDate()).inHours <
            48;

        final currentUserId = AuthService().getCurrentUserId();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(
                  username: postUsername,
                  title: title,
                  description: description,
                  street: street,
                  when: when,
                  whatsappNumber: whatsappNumber,
                  createdAt: createdAt.toDate(),
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                color: lightBeige,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image,
                                size: 80,
                                color: colorCoolGray,
                              );
                            },
                          )
                        : const Icon(
                            Icons.image,
                            size: 80,
                            color: colorCoolGray,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              postUsername,
                              style: cardSubtitleTextStyle(context),
                            ),
                            if (isNew)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorDarkGray,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'NEU',
                                  style: newMarkTextStyle(context),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: cardTitleTextStyle(context),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: cardDateTextStyle(context),
                            ),
                            if (currentUserId ==
                                userId) // Show edit/delete icons if user is the owner
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTask(
                                            postId: postId,
                                            name: title,
                                            description: description,
                                            street: street,
                                            when: when,
                                            whatsappNumber: whatsappNumber,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _confirmDelete(context),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  // Show a confirmation dialog before deleting the post
  Future<void> _confirmDelete(BuildContext context) async {
    bool confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sind Sie sicher?'),
              content: const Text(
                  'Diese Aktion kann nicht rückgängig gemacht werden.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Löschen'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmDelete) {
      await DatabaseService().deletePost(postId);
    }
  }
}
