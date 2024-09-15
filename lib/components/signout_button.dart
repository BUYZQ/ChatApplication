import 'package:chat_app_example/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        final route = MaterialPageRoute(builder: (_) => const LoginPage());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      },
      icon: const Icon(Icons.logout),
    );
  }
}
