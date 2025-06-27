import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService extends ChangeNotifier 
{

  final SupabaseClient _supabase = Supabase.instance.client;

  String userName = "User Name";
  String? avatarUrl;

  // تحميل الصورة الشخصية من جدول profiles
  Future<void> loadProfile() async 
  {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('profiles')
        .select('avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    avatarUrl = response?['avatar_url'];
    notifyListeners();
  }


  // تحديث الصورة الشخصية في جدول profiles
  Future<void> updateAvatar(String newAvatarUrl) async 
  {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try 
    {
      await _supabase
          .from('profiles')
          .update({'avatar_url': newAvatarUrl,})
          .eq('id', user.id);

      avatarUrl = newAvatarUrl;
      notifyListeners();
    } 
    catch (e) 
    {
      throw Exception("فشل في تحديث الصورة الشخصية: ${e.toString()}");
    }
  }

  // تحميل اسم المستخدم من جدول profiles
  Future<void> loadUserName() async 
  {

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    final response = await _supabase
        .from('profiles')
        .select('username')
        .eq('id', user.id)
        .maybeSingle();

    if (response != null) 
    {
      userName = response['username'] ?? "User Name";
      notifyListeners();
    }
  }

  // تحديث اسم المستخدم في جدول profiles
  Future<void> updateUsername(String newName) async 
  {

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    try 
    {
      final response = await _supabase
          .from('profiles')
          .upsert
          ({
            'id': user.id,
            'username': newName,
            'email': user.email, // لضمان عدم وجود null في عمود email
          })
          .select()
          .maybeSingle();

      if (response == null) 
      {
        throw Exception("فشل في تحديث الاسم: لم يتم إعادة بيانات");
      }

      userName = newName;
      notifyListeners();
    } 
    catch (e) 
    {
      throw Exception("فشل في تحديث الاسم: ${e.toString()}");
    }
  }

  // إعادة تعيين بيانات الملف الشخصي عند تسجيل الخروج
  void resetProfile() 
  {
    userName = "User Name";
    avatarUrl = null;
    notifyListeners();
  }
}


// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProfileService extends ChangeNotifier {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   String userName = "User Name";
//   String? avatarUrl;

//   // تحميل الصورة الشخصية من قاعدة البيانات
//   Future<void> loadProfile() async 
//   {
//     final user = _supabase.auth.currentUser;
//     if (user == null) return;

//     final response = await _supabase
//         .from('user_profiles')
//         .select('avatar_url')
//         .eq('id', user.id)
//         .maybeSingle();

//     avatarUrl = response?['avatar_url'];
//     notifyListeners();
//   }

//   // تحميل اسم المستخدم من قاعدة البيانات
//   Future<void> loadUserName() async {
//     final user = _supabase.auth.currentUser;
//     if (user == null) return;

//     final response = await _supabase
//         .from('user_profiles')
//         .select('username')
//         .eq('id', user.id)
//         .maybeSingle();

//     if (response != null) {
//       userName = response['username'] ?? "User Name";
//       notifyListeners();
//     }
//   }

//   // تحديث اسم المستخدم في قاعدة البيانات
//   Future<void> updateUsername(String newName) async {
//     final user = _supabase.auth.currentUser;
//     if (user == null) return;

//     try {
//       await _supabase.from('user_profiles').upsert({
//         'id': user.id,
//         'username': newName,
//         'updated_at': DateTime.now().toIso8601String(),
//       });
//       userName = newName;
//       notifyListeners();
//     } catch (e) {
//       throw Exception("فشل في تحديث الاسم: ${e.toString()}");
//     }
//   }

//   // إعادة تعيين بيانات الملف الشخصي عند تسجيل الخروج
//   void resetProfile() {
//     userName = "User Name";
//     avatarUrl = null;
//     notifyListeners();
//   }
// }
