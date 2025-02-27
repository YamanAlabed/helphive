import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helphive_flutter/core/services/database_services.dart';
import 'package:helphive_flutter/core/utils/get_random_image_url.dart';
import 'package:helphive_flutter/core/widgets/custom_card.dart';

class TaskList extends StatelessWidget {
  final String? selectedCategory;
  final String? userId; // Add userId

  const TaskList({super.key, this.selectedCategory, this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseService().getPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!;
        
        // Filter by category and user ID
        final filteredPosts = posts.where((post) {
          final matchesCategory = selectedCategory == null || post['Category'] == selectedCategory;
          final matchesUser = userId == null || post['userId'] == userId;
          return matchesCategory && matchesUser;
        }).toList();
        
        filteredPosts.sort((a, b) {
          final aTimestamp = (a['createdAt'] as Timestamp?)?.toDate();
          final bTimestamp = (b['createdAt'] as Timestamp?)?.toDate();
          return (bTimestamp ?? DateTime(0)).compareTo(aTimestamp ?? DateTime(0));
        });

        // Return the list of posts
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            final post = filteredPosts[index];
            return CustomCard(
              postId: post['Id'],
              userId: post['userId'],
              title: post['Name'] ?? 'No Title',
              description: post['Description'] ?? 'No Content',
              street: post['Street'] ?? 'No Street',
              when: post['When'] ?? 'No date',
              whatsappNumber: post['WhatsappNumber'] ?? 'No number',
              createdAt: (post['createdAt'] as Timestamp?) ?? Timestamp.now(),
              imageUrl: getRandomImageUrl(),
            );
          },
        );
      },
    );
  }
}
