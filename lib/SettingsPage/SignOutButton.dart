import 'package:flutter/material.dart';
import 'package:nine_workout/SettingsPage/SettingButtons.dart';
import 'package:nine_workout/SettingsPage/SettingsLogic.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      // تسجيل الخروج من Supabase
      await Supabase.instance.client.auth.signOut();
      // إعادة تعيين بيانات الملف الشخصي إلى القيم الافتراضية
      Provider.of<ProfileService>(context, listen: false).resetProfile();
      // لا نقوم بعملية تنقل، سيقوم StreamBuilder في SettingsPage بتحديث الحالة
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingButton(
      icon: Icons.power_settings_new,
      iconColor: const Color.fromARGB(255, 161, 11, 0),
      onTap: () => _signOut(context),
      text: 'Log Out',
      textColor: const Color.fromARGB(255, 161, 11, 0),
      splashColor: const Color.fromARGB(255, 161, 11, 0),
    );
  }
}
