import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() {
    final usersStream = _firestore.collection('users').snapshots();
    return usersStream;
  }

  Future<Map<String, dynamic>> getUserByUid(String uid) async {
    DocumentSnapshot document =
        await _firestore.collection('users').doc(uid).get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data;
  }

  Future<void> addImageUrl({
    required String imageUrl,
    required String userId,
    required String email,
    required String username,
  }) async {
    _firestore.collection('users').doc(userId).set({
      'imageUrl': imageUrl,
      'username': username,
      'email': email,
      'uid': userId,
    });
  }

  Future<void> updateUsername(String userId, String newUsername) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId);
    try {
      await userDoc.update({
        'username': newUsername,
      });
      log('Username updated successfully');
    } catch (e) {
      log('Error updating username: $e');
    }
  }

  Stream<QuerySnapshot> getPosts() {
    final postsStream = _firestore.collection('posts').snapshots();
    return postsStream;
  }

  Future<void> createPost(
    String? imageUrl,
    String username,
    String uid,
    String newPost,

  ) async {
    final CollectionReference firestoreService =
        _firestore.collection('posts');
    try {
      await firestoreService.add({
        'imageUrl': imageUrl,
        'username': username,
        'newPost': newPost,
        'uid': uid,
      });
    } catch (e) {
      log('Error $e');
    }
  }

  Future<void> deletePost(String id) async {
    await _firestore.collection('posts').doc(id).delete();
  }
}
