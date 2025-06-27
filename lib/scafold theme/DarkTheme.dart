import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xff000000), // لون الخلفية لـ Scaffold
  appBarTheme: const AppBarTheme( // استخدم const هنا
    color: Color(0xff000000), // لون الـ AppBar
    foregroundColor: Colors.white, // لون النص في الـ AppBar
  ),
  textTheme: const TextTheme( // استخدم const هنا
    bodyLarge: TextStyle(color: Colors.white), // لون النصوص العامة
    bodyMedium: TextStyle(color: Colors.white), // لون النصوص الثانوية
    titleLarge: TextStyle(color: Colors.blue), // لون العناوين الكبيرة
    titleMedium: TextStyle(color: Colors.red), // لون العناوين المتوسطة
    // يمكنك إضافة المزيد من الأنماط هنا حسب الحاجة
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
