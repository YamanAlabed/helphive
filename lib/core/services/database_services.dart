import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  // reusable reference to the 'Posts' collection
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('Posts');

  // Add post
  Future addPost(Map<String, dynamic> postsInfoMap, String id) async {
    postsInfoMap['createdAt'] = FieldValue.serverTimestamp();
    return await postsCollection.doc(id).set(postsInfoMap);
  }

  // Fetch posts as a stream
  Stream<List<Map<String, dynamic>>> getPosts() {
    return postsCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
  }
  

  Future<void> updatePost(
      String postId, Map<String, dynamic> updatedData) async {
    try {
      await postsCollection.doc(postId).update(updatedData);
      if (kDebugMode) {
        print("Post wurde erfolgreich aktualisiert!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Fehler beim Aktualisieren: $e");
      }
      rethrow; 
    }
  }

  Future deletePost(String id) async {
    return await postsCollection.doc(id).delete();
  }
  
}
