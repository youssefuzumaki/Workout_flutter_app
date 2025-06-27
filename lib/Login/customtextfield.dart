import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

class CustomTextField extends StatelessWidget {
  final Color bordercolor;
  final String hinttext;
  final TextEditingController? controller;
  final bool obscureText;
  final Icon? iconfield;

  const CustomTextField({
    super.key,
    required this.bordercolor,
    required this.hinttext,
    this.controller,
    this.obscureText = false,
    this.iconfield,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      
      decoration: InputDecoration
      (
        prefixIcon: iconfield,
        labelText: hinttext, // استخدم labelText بدلاً من hintText
        labelStyle: const TextStyle(color: Colors.white70),
        floatingLabelBehavior: FloatingLabelBehavior.auto, // سيجعل النص يطفو للأعلى عند التركيز
        
        // الحالة العامة للحقل
        border: OutlineInputBorder(
          borderSide: BorderSide(color: bordercolor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        
        // الحالة عندما يكون الحقل غير نشط
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: bordercolor),
          borderRadius: BorderRadius.circular(12.0),
        ),
        
        // الحالة عندما يكون الحقل في وضع التركيز
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: myColor.withOpacity(0.8),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        
        // الحالة عندما يكون هناك خطأ في الحقل (اختياري)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        
        // الحالة عندما يكون الحقل مملوءًا
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        
        // إضافة هوامش داخلية
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }
}