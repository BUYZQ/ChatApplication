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

