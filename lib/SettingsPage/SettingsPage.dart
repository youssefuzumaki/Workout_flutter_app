import 'package:flutter/material.dart';
import 'package:nine_workout/Needes/Notiffication.dart';
import 'package:nine_workout/Needes/Profile.dart';
import 'package:nine_workout/SettingsPage/EditButton.dart';
import 'package:nine_workout/SettingsPage/SettingsBody.dart';
import 'package:nine_workout/SettingsPage/SettingsLogic.dart'; // يستخدم جدول profiles الآن
import 'package:nine_workout/Useless/CustomIconButton.dart';
import 'package:nine_workout/Useless/consts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends StatefulWidget 
{
  const SettingsPage({super.key});
  
  static const String routeName = '/SettingsPage';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> 
{

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() 
  {
    super.initState();
    // تحميل بيانات الملف الشخصي عند بدء الصفحة باستخدام ProfileService الذي يعمل على جدول profiles
    final profileService = Provider.of<ProfileService>(context, listen: false);
    profileService.loadProfile();
    profileService.loadUserName();
  }

  Future<void> _showNameInputDialog(BuildContext context) async 
  {
    final result = await Navigator.push
    (
      context,
      MaterialPageRoute(builder: (context) => const NameInputPage()),
    );
    
    if (result != null && result is String) 
    {
      try 
      {
        await Provider.of<ProfileService>(context, listen: false)
            .updateUsername(result);
      } 
      catch (e) 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text("فشل في تحديث الاسم: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) 
  {

    final profileService = Provider.of<ProfileService>(context);
    final user = _supabase.auth.currentUser;

    return StreamBuilder<AuthState>
    (
      stream: _supabase.auth.onAuthStateChange,

      builder: (context, snapshot) 
      {
        return Stack
        (
          children: 
          [
            Scaffold
            (
              appBar: AppBar
              (
                toolbarHeight: 75,
                leading: Padding
                (
                  padding: const EdgeInsets.only(left: 5.0),
                  child: IconButton
                  (
                    icon: const ImageIcon
                    (
                      AssetImage('assets/IconImage/crown (1).png'),
                      size: 25,
                      color: Colors.amber,
                    ),
                    onPressed: () => Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    ),
                  ),
                ),
                centerTitle: true,
                title: const Text('Settings'),
                actions: 
                [
                  Padding
                  (
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomIconButton
                    (
                      iconName: Icons.notifications,
                      pagename: const Notiffication(),
                    ),
                  ),
                ],
              ),

              body: const SettingsBody(),
            ),

            // زر تعديل الاسم (Edit Profile)
            Positioned
            (
              top: 187,
              left: 138,
              child: GestureDetector
              (
                onTap: () 
                {
                  if (_supabase.auth.currentUser == null) 
                  {
                    ScaffoldMessenger.of(context).showSnackBar
                    (
                      const SnackBar(content: Text("عليك تسجيل الدخول أولاً")),
                    );
                    return;
                  }
                  _showNameInputDialog(context);
                },

                child: Container
                (
                  width: 108,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),

                  decoration: BoxDecoration
                  (
                    color: myColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  
                  child: const Center
                  (
                    child: Text
                    (
                      'Edit Profile',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
