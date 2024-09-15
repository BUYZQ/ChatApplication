import 'dart:io';
import 'package:chat_app_example/pages/auth/login_page.dart';
import 'package:chat_app_example/services/firebase_storage/storage_service.dart';
import 'package:chat_app_example/services/firestore/firestore_service.dart';
import 'package:chat_app_example/services/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _postController = TextEditingController();
  String? imageUrl;
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = await _firestoreService.getUserByUid(uid);
    username = data['username'];
    email = data['email'];
    imageUrl = data['imageUrl'];
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              Container(
                color: theme.textTheme.headlineSmall?.color,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          splashRadius: 25,
                          onPressed: () {
                            _firebaseAuth.signOut();
                            final newRouteName = MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              newRouteName,
                              (route) => false,
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: theme.textTheme.bodySmall?.color,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                    Material(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: addImage,
                        child: imageUrl == null
                            ? const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 80,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  imageUrl!,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      username,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.scaffoldBackgroundColor,
                      ),
                      onPressed: createPost,
                      child: Text(
                        'Добавить пост',
                        style: TextStyle(
                          color: theme.textTheme.displaySmall?.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              TileUser(username: username),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: ElevatedButton(
                            onPressed: () {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .changeTheme();
                            },
                            child: const Text('Переключить тему'),
                          ),
                        );
                      });
                },
                leading: Icon(
                  Icons.light_mode,
                  color: theme.textTheme.headlineSmall?.color,
                ),
                title: Text(
                  'Theme',
                  style: TextStyle(color: theme.textTheme.headlineSmall?.color),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'light',
                      style: TextStyle(
                          color: theme.textTheme.headlineSmall?.color),
                    ),
                    const SizedBox(width: 15),
                    Icon(
                      Icons.edit,
                      color: theme.textTheme.headlineSmall?.color,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createPost() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _postController,
                  minLines: 1,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: 'Добавить пост'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bool postIsNotEmpty =
                          _postController.text.trim().isNotEmpty;
                      if (postIsNotEmpty) {
                        _firestoreService.createPost(
                          imageUrl,
                          username,
                          _firebaseAuth.currentUser!.uid,
                          _postController.text,
                        );
                        Navigator.pop(context);
                        _postController.clear();
                      }
                    },
                    child: const Text('Опубликовать'),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> addImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      final String? url =
          await _firebaseStorageService.addImage(File(file.path));
      if (url != null) {
        imageUrl = url;
        _firestoreService.addImageUrl(
          imageUrl: imageUrl!,
          userId: _firebaseAuth.currentUser!.uid,
          email: _firebaseAuth.currentUser?.email ?? '',
          username: username,
        );
        setState(() {});
      }
    }
  }
}

class TileUser extends StatefulWidget {
  final String username;
  const TileUser({super.key, required this.username});

  @override
  State<TileUser> createState() => _TileUserState();
}

class _TileUserState extends State<TileUser> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: showAlertWindow,
      leading: Icon(Icons.person, color: theme.textTheme.headlineSmall?.color),
      title: Text(
        'Username',
        style: TextStyle(color: theme.textTheme.headlineSmall?.color),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.username,
            style: TextStyle(color: theme.textTheme.headlineSmall?.color),
          ),
          const SizedBox(width: 15),
          Icon(
            Icons.edit,
            color: theme.textTheme.headlineSmall?.color,
          ),
        ],
      ),
    );
  }

  void showAlertWindow() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editController,
                decoration: const InputDecoration(hintText: 'Введите имя'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _firestoreService.updateUsername(
                      _firebaseAuth.currentUser!.uid,
                      _editController.text,
                    );
                    Navigator.pop(context);
                    setState(() {
                      widget.username;
                    });
                  },
                  child: const Text('Сохранить'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
