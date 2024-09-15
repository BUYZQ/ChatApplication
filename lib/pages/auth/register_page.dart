import 'package:chat_app_example/components/my_text_field.dart';
import 'package:chat_app_example/pages/auth/login_page.dart';
import 'package:chat_app_example/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main/bottom_nav_pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.chat,
                size: 100,
              ),
              Text(
                'Регистрация',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _usernameController,
                hintText: 'Username',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: signUpWithEmailAndPassword,
                  child: const Text('Зарегистрироваться'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Уже зарегистрированны?',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.textTheme.displayLarge!.color,
                    ),
                  ),
                  TextButton(
                    onPressed: navigateToSignInPage,
                    child: Text(
                      'Вход',
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateToSignInPage() {
    final route = MaterialPageRoute(builder: (_) => const LoginPage());
    Navigator.push(context, route);
  }

  Future<void> signUpWithEmailAndPassword() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _firebaseAuthService.signUpWithEmailAndPassword(
      username: username,
      email: email,
      password: password,
    );

    if(user != null) {
      final route = MaterialPageRoute(builder: (_) => const BottomNavPages());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }
}
