import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed; // <-- إضافة خاصية onPressed
  final Color titlecolor;
  final Color backgroundcolor;

  const Custombutton({
    super.key,
    required this.title,
    required this.onPressed, 
    this.titlecolor = Colors.white, 
    this.backgroundcolor = Colors.white, // <-- جعلها مطلوبة
  });

  @override
  Widget build(BuildContext context) 
  {
    return ElevatedButton(
      style: ElevatedButton.styleFrom
      (
        backgroundColor: backgroundcolor,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed, // <-- ربط الحدث
     child: Text(
        title,
        style: TextStyle
        (
          color: titlecolor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}