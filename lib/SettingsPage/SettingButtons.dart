import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final IconData icon;         // الأيقونة على اليسار
  final String text;           // النص بجانب الأيقونة
  final IconData? arrowIcon;   // أيقونة السهم على اليمين (اختياري)
  final VoidCallback? onTap;   // الدالة التي تُنفذ عند الضغط
  final Color iconColor; 
  final Color textColor;  
  final Color splashColor;  
  final double iconsize ;  

  const SettingButton({
    Key? key,
    required this.icon,
    required this.text,
    this.arrowIcon,  // الآن اختياري بدون قيمة افتراضية
    this.onTap,
    this.iconColor = Colors.white,
    this.textColor = Colors.white, 
    this.splashColor = Colors.grey,
    this.iconsize = 30 ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // خلفية شفافة
      child: InkWell(
        onTap: () async {
          await Future.delayed(const Duration(milliseconds: 450));
          if (onTap != null) onTap!();
        },
        borderRadius: BorderRadius.circular(15.0),
        splashColor: splashColor.withOpacity(0.2),
        
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: iconsize,),
              const SizedBox(width: 30),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              const Spacer(flex: 15),
              if (arrowIcon != null) // ✅ عرض الأيقونة فقط إذا كانت غير فارغة
                Icon(arrowIcon, color: Colors.white, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}
