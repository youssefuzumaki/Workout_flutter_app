import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_workout/SettingsPage/LoginButton.dart';
import 'package:nine_workout/SettingsPage/SettingButtons.dart';
import 'package:nine_workout/SettingsPage/SettingsLogic.dart';
import 'package:nine_workout/SettingsPage/SignOutButton.dart';
import 'package:nine_workout/SettingsPage/ViewPage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsBody extends StatelessWidget 
{
  const SettingsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {

    final profileService = Provider.of<ProfileService>(context);
    final SupabaseClient supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    return SingleChildScrollView
    (
      child: Column
      (
        children: 
        [

          const SizedBox(height: 20),

          Row
          (
            children: 
            [

              const SizedBox(width: 20),

              GestureDetector
              (
                onTap: () async 
                {
                  if (user == null) 
                  {
                    ScaffoldMessenger.of(context).showSnackBar
                    (
                      const SnackBar(content: Text("يجب تسجيل الدخول أولاً")),
                    );
                    return;
                  }

                  final result = await Navigator.push
                  (
                    context,
                    MaterialPageRoute
                    (
                      builder: (context) => ViewPage
                      (
                        imageUrl: profileService.avatarUrl,
                      ),
                    ),
                  );

                  if (result == true) 
                  {
                    await profileService.loadProfile();
                  }
                },

                child: Hero
                (
                  tag: 'user-avatar', // يجب أن يكون نفس tag المستخدم في ViewPage
                  child: CircleAvatar
                  (
                    backgroundColor: Colors.grey,
                    radius: 50,
                    backgroundImage: profileService.avatarUrl?.isNotEmpty == true
                        ? NetworkImage(profileService.avatarUrl!)
                        : null,
                    child: (profileService.avatarUrl == null ||
                            profileService.avatarUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                ),
              ),

              const SizedBox(width: 20),

              Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  Text
                  (
                    profileService.userName,
                    style: const TextStyle
                    (
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text
                  (
                    user?.email ?? 'Not logged in',
                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),

                  const SizedBox(height: 38),

                ],
              ),
            ],
          ),

          const SizedBox(height: 35),

          SettingButton
          (
            icon: Icons.history_outlined,
            text: 'History',
            onTap: () => Navigator.pushNamed(context, '/History'),
          ),
          SettingButton
          (
            icon: Icons.fitness_center,
            text: 'Workout',
            onTap: () => Navigator.pushNamed(context, '/Workout'),
          ),
          SettingButton
          (
            icon: CupertinoIcons.lock,
            text: 'Lock',
            onTap: () => Navigator.pushNamed(context, '/Lock'),
          ),
          SettingButton
          (
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/Settings'),
          ),
          SettingButton
          (
            icon: CupertinoIcons.info,
            text: 'About',
            onTap: () => Navigator.pushNamed(context, '/About'),
          ),

          const SizedBox(height: 20),
          
          user != null ? const SignOutButton() : const Loginbutton(),
        ],
      ),
    );
  }
}
