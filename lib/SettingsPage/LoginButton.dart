import 'package:flutter/material.dart';
import 'package:nine_workout/Login/Loginpage.dart';

/// زر تسجيل الدخول الذي يستخدم عادة في صفحة Settings 
/// لاستدعاء صفحة Loginpage عند الضغط عليه.
class Loginbutton extends StatelessWidget {
  const Loginbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(Colors.blue),
      ),
      // عند الضغط يتم الانتقال إلى صفحة Loginpage
      onPressed: () =>
         Navigator.push(context,  MaterialPageRoute(builder: (context) => Loginpage())),
      child: const Text('Log in'),
    );
  }
}
