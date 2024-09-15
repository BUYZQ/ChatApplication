import 'package:chat_app_example/pages/main/chat_page.dart';
import 'package:chat_app_example/services/firestore/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Чаты',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error on load'));
          }

          if (snapshot.hasData) {
            List<dynamic> usersList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = usersList[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String username = data['username'];
                String uid = data['uid'];
                String? imageUrl = data['imageUrl'];
                String email = data['email'];
                if (email != _firebaseAuth.currentUser!.email) {
                  return Card(
                    elevation: 1,
                    child: ListTile(
                      onTap: () => navigateToChatPage(username, uid, imageUrl),
                      leading: imageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                            ),
                      title: Text(username),
                      subtitle: Text(email, style: const TextStyle(
                        color: Colors.black,
                      ),),
                      trailing:
                          const Icon(Icons.keyboard_arrow_right, size: 35),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  void navigateToChatPage(String username, String uid, String? imageUrl) {
    final route = MaterialPageRoute(
      builder: (_) => ChatPage(
        username: username,
        uid: uid,
        imageUrl: imageUrl,
      ),
    );
    Navigator.push(context, route);
  }
}
