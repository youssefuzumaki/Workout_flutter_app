import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WorkoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 250),
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: myColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              bottomLeft: Radius.circular(17),
            ),
          ),
        ),
        onPressed: () {
          // التحقق من تسجيل الدخول
          final user = Supabase.instance.client.auth.currentUser;
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("عليك تسجيل الدخول أولاً")),
            );
            return;
          }
          // إذا كان المستخدم مسجلاً، يتم تنفيذ العملية الممررة
          onPressed();
        },
        child: const Text(
          'More Action',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
