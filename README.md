# Chat application written in dart and flutters using firebase services

## Auth

The chat application now includes a fully developed system for user authorization, along with functionalities for both login and registration.

![Auth](https://raw.githubusercontent.com/BUYZQ/ChatApplication/main/README_ASSETS/auth.jpg)

# Code 
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
## Main functional

The core features of the application include a home page, a chat list, and a user profile that allows for logging out, changing the theme, adding posts, or updating the username. 

![Main functional](https://github.com/BUYZQ/ChatApplication/blob/main/README_ASSETS/main.png)

# firestore code 
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

# firebase storage code

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

# Change theme

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