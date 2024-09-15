import 'package:chat_app_example/components/my_text_field.dart';
import 'package:chat_app_example/pages/auth/register_page.dart';
import 'package:chat_app_example/pages/main/bottom_nav_pages.dart';
import 'package:chat_app_example/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
                'Вход',
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
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
                  onPressed: signInWithEmailAndPassword,
                  child: const Text('Войти'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Не зарегистрированны?',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.textTheme.displayLarge!.color,
                    ),
                  ),
                  TextButton(
                    onPressed: navigateToRegisterPage,
                    child: Text(
                      'Регистрация',
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

  void navigateToRegisterPage() {
    final route = MaterialPageRoute(builder: (_) => const RegisterPage());
    Navigator.push(context, route);
  }

  Future<void> signInWithEmailAndPassword() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if(user != null) {
      final route = MaterialPageRoute(builder: (_) => const BottomNavPages());
      Navigator.pushReplacement(context, route);
    }
  }
}
