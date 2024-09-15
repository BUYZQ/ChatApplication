import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
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
