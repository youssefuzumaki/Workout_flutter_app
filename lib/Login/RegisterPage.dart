import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nine_workout/Login/LogSignBody.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget 
{

  static const String routeName = '/RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> 
{
  bool _isLoading = false;

  Future<void> _signUp
  (
    BuildContext context, String email, String password, String? username) async 
    {
      setState(() 
      {
        _isLoading = true;
      });
      try 
      {
        // عملية التسجيل باستخدام Supabase Auth
        final response = await Supabase.instance.client.auth.signUp
        (
          email: email,
          password: password,
        );

        if (response.user != null) 
        {
          // تحديث بيانات الـ auth لتضمين display_name (اسم المستخدم)
          await Supabase.instance.client.auth.updateUser
          (
            UserAttributes
            (
              data: {'display_name': username ?? 'User Name'},
            ),
          );

          // إنشاء سجل الملف الشخصي في جدول profiles (المستخدمين)
          await Supabase.instance.client.from('profiles').upsert
          ({
            'id': response.user!.id,
            'username': username ?? 'User Name',
            'avatar_url': '',
            'email': email,
            'created_at': DateTime.now().toIso8601String(),
          });

          // إنشاء ملف placeholder لتوليد فولدر المستخدم في Storage
          final placeholderContent = Uint8List.fromList
          (
            utf8.encode("Folder created for user ${response.user!.id}"),
          );

          final tempDir = await getTemporaryDirectory();

          final filePath = '${tempDir.path}/${response.user!.id}_placeholder.txt';

          final file = File(filePath);

          await file.writeAsBytes(placeholderContent);

          // رفع الملف إلى Supabase Storage ضمن الـ Bucket "user-data"
          // نحط الملف في مسار: /profiles/{user_id}/avatar/placeholder.txt
          await Supabase.instance.client.storage
              .from('user-data')
              .upload('${response.user!.id}/avatar/placeholder.txt', file);

          Navigator.pushReplacementNamed(context, '/MainScreen');
        } else 
        {
          ScaffoldMessenger.of(context).showSnackBar
          (
            const SnackBar(content: Text("Registration failed ممكن بسبب النت")),
          );
        }
      } catch (e) 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          SnackBar(content: Text("check your email for verification")),
        // SnackBar(content: Text("Registration failed Error: $e")),
        // لو حصل خطأ أثناء التسجيل، نعرض رسالة الخطأ
        );
      }
      setState(() 
      {
        _isLoading = false;
      });
    }

    @override
    Widget build(BuildContext context) 
    {
      return Logsignbody
      (
        returnPageRoute: '/LoginPage',
        doSign: _signUp,
        title: 'Sign Up',
        anotheroptiontext: "Already have an account?",
        anotheroptionpage: '  Login',
        ButtonTitle: 'SIGN UP',
        showForgetPassword: false,
        showUsernameField: true,
        doSignColor: Colors.grey,
      );
  }
}







// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:nine_workout/Login/LogSignBody.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class RegisterPage extends StatefulWidget {
//   static const String routeName = '/RegisterPage';
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool _isLoading = false;

//   Future<void> _signUp(
//       BuildContext context, String email, String password, String? username) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       // عملية التسجيل باستخدام Supabase Auth
//       final response = await Supabase.instance.client.auth.signUp(
//         email: email,
//         password: password,
//       );

//       if (response.user != null) {
//         // تحديث بيانات الـ auth لتضمين display_name (اسم المستخدم)
//         await Supabase.instance.client.auth.updateUser(
//           UserAttributes(
//             data: {'display_name': username ?? 'User Name'},
//           ),
//         );

//         // إنشاء سجل الملف الشخصي في جدول user_profiles
//         await Supabase.instance.client.from('user_profiles').upsert({
//           'id': response.user!.id,
//           'username': username ?? 'User Name',
//           'avatar_url': '',
//           'email': email,
//           'created_at': DateTime.now().toIso8601String(),
//         });

//         // إنشاء محتوى placeholder لتوليد الملف (لتنشئة فولدر المستخدم)
//         final placeholderContent = Uint8List.fromList(
//           utf8.encode("Folder created for user ${response.user!.id}"),
//         );

//         // الحصول على دليل التخزين المؤقت وإنشاء ملف placeholder
//         final tempDir = await getTemporaryDirectory();
//         final filePath = '${tempDir.path}/${response.user!.id}_placeholder.txt';
//         final file = File(filePath);
//         await file.writeAsBytes(placeholderContent);

//         // رفع الملف إلى Supabase Storage على مسار المجلد الخاص بالمستخدم
//         // تأكد إن مسار الرفع يبدأ بمعرف المستخدم، مثلاً: '<user_id>/placeholder.txt'
//         await Supabase.instance.client.storage
//             .from('user-assets')
//             .upload('${response.user!.id}/placeholder.txt', file);

//         Navigator.pushReplacementNamed(context, '/MainScreen');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration failed ممكن بسبب النت")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Registration failed Error: $e")),
//       );
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Logsignbody(
//       returnPageRoute: '/LoginPage',
//       doSign: _signUp,
//       title: 'Sign Up',
//       anotheroptiontext: "Already have an account?",
//       anotheroptionpage: '  Login',
//       ButtonTitle: 'SIGN UP',
//       showForgetPassword: false,
//       showUsernameField: true,
//       doSignColor: Colors.grey,
//     );
//   }
// }
