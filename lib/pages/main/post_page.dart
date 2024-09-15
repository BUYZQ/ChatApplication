import 'package:chat_app_example/services/firestore/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }

            List<dynamic> postsList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: postsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = postsList[index];
                String id = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String? imageUrl = data['imageUrl'];
                String username = data['username'];
                String text = data['newPost'];
                String uid = data['uid'];
                return Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    children: [
                      if(index <= 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Посты',
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: theme.canvasColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                imageUrl == null
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundColor: theme.bannerTheme.backgroundColor,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          imageUrl,
                                          height: 55,
                                          width: 55,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                const SizedBox(width: 6),
                                Text(
                                  username,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const Expanded(child: SizedBox()),
                                if(_firebaseAuth.currentUser!.uid == uid)
                                  IconButton(
                                    splashRadius: 25,
                                    onPressed: () => deletePost(id),
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 28,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: Text(
                                text,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void deletePost(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Вы точно хотите удалить пост?', style: TextStyle(fontSize: 18),),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _firestoreService.deletePost(id);
                        Navigator.pop(context);
                      },
                      child: const Text('Да'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Отмена'),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
