import 'package:chat_app_example/pages/main/main_page.dart';
import 'package:chat_app_example/pages/main/post_page.dart';
import 'package:chat_app_example/pages/main/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavPages extends StatefulWidget {
  const BottomNavPages({super.key});

  @override
  State<BottomNavPages> createState() => _BottomNavPagesState();
}

class _BottomNavPagesState extends State<BottomNavPages> {

  int _currentIndex = 0;
  List<Widget> pages = [
    const PostPage(),
    const MainPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (pageIndex) {
          setState(() {
            _currentIndex = pageIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outlined),
              label: 'Чат'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль'
          ),
        ],
      ),
    );
  }
}
