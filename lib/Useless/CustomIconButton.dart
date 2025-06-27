import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconName;
  final String? label; // النص اختياري
  final Widget pagename; // الصفحة التي سيتم التنقل إليها

  const CustomIconButton
  ({
    super.key,
    required this.iconName,
    this.label,
    required this.pagename, // اسم الصفحة مطلوب
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // التنقل إلى الصفحة
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pagename),
        );
      },
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon
          (
            iconName,
            color: Colors.white,
          ),
          if (label != null) // عرض النص فقط إذا كان غير فارغ
            Text(
              label!,
              style: const TextStyle(fontSize: 8),
            ),
        ],
      ),
    );
  }
}
