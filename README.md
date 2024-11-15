# Chat application written in dart and flutters using firebase services

# Auth

The chat application now includes a fully developed system for user authorization, along with functionalities for both login and registration.

![Auth](https://raw.githubusercontent.com/BUYZQ/ChatApplication/main/README_ASSETS/auth.jpg)

## Code 
```dart class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('users');

  Future<User?> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        _firestore.doc(user!.uid).set({
          'username': username,
          'uid': user!.uid,
          'email': user.email,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      log('SignUp Failed');
      log(e.toString());
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      log('SignIn Failed');
      log(e.toString());
    }
    return null;
  }
}
```
# Main functional

The core features of the application include a home page, a chat list, and a user profile that allows for logging out, changing the theme, adding posts, or updating the username. 

![Main functional](https://github.com/BUYZQ/ChatApplication/blob/main/README_ASSETS/main.png)

## firestore code 
```dart class FirestoreService {
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
```

## firebase storage code

```dart class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> addImage(File file) async {
    try {
      Reference ref = _firebaseStorage.ref().child('images/${DateTime.now().microsecondsSinceEpoch}.png');
      await ref.putFile(file);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch(e) {
      log(e.toString());
    }
    return null;
  }
}
```

## Change theme

```dart class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
  }
}
```
# Dark theme and Chat
![Screen](https://github.com/BUYZQ/ChatApplication/blob/main/README_ASSETS/chat_and_theme.png)

The app has a dark theme, as well as a chat feature that allows users to exchange messages. All messages are saved in the Firestore database.

## firestore chat service

```dart class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(
    String receiverId,
    String senderUsername,
    String message,
  ) async {
    final currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderUsername: senderUsername,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toJson());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    final streamMessages = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
    return streamMessages;
  }
}
```
## ThemeData 

```dart ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade600,
    ),
    displaySmall: const TextStyle(
      fontSize: 18,
      color: Colors.black,
    ),
    headlineLarge: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    bodySmall: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade800,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.grey.shade800,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: Colors.black,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey,
      ),
      backgroundColor: Colors.white),
  canvasColor: Colors.blueGrey.withOpacity(0.3),
  bannerTheme: MaterialBannerThemeData(
    backgroundColor: Colors.black.withOpacity(0.7),
  ),
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black.withOpacity(0.6),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade600,
    ),
    displaySmall: const TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    headlineLarge: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodySmall: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade800,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.grey.shade800,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    unselectedIconTheme: const IconThemeData(
      color: Colors.grey,
    ),
    backgroundColor: Colors.black.withOpacity(0.6),
  ),
  canvasColor: Colors.white,
  bannerTheme: const MaterialBannerThemeData(
    backgroundColor: Colors.black,
  ),
);
 ```
# This is how the layout was created in the application using the example of a chat

```dart class ChatPage extends StatefulWidget {
  final String username;
  final String uid;
  final String? imageUrl;

  const ChatPage({
    super.key,
    required this.username,
    required this.uid,
    required this.imageUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                color: theme.scaffoldBackgroundColor,
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: theme.textTheme.displaySmall?.color,
                      ),
                    ),
                    widget.imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 35,
                            color: theme.textTheme.displaySmall?.color,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              widget.imageUrl!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                    const SizedBox(width: 10),
                    Text(widget.username,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.textTheme.displaySmall?.color,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessages(
                    _firebaseAuth.currentUser!.uid,
                    widget.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Загрузить сообщения не удалось'),
                      );
                    }
                    List<dynamic> messages = snapshot.data!.docs;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = messages[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String message = data['message'];
                        bool isCurrentUser =
                            data['senderId'] == _firebaseAuth.currentUser!.uid;
                        Timestamp time = data['timestamp'];
                        return Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  top: 4,
                                  left: isCurrentUser ? 130 : 4,
                                  right: isCurrentUser ? 4 : 130,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isCurrentUser
                                        ? Colors.deepPurpleAccent
                                        : Colors.blueGrey),
                                child: Text(message, softWrap: true),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MessageTextField(
                  messageController: _messageController,
                  sendMessage: sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.uid,
        widget.username,
        _messageController.text,
      );
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _messageController.clear();
  }
}
```

## Данный проект я делал в Августе 2024 года для того, чтобы посмотреть, как работать с Firebase, посмотреть его основные сервисы и конечно же это было хороший практикой, в применение базы данных в приложении