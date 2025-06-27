import 'package:flutter/material.dart';
import 'package:nine_workout/Login/LogSignBody.dart';
import 'package:nine_workout/Pages/NavigationBar.dart';
import 'package:nine_workout/Useless/consts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Loginpage extends StatefulWidget 
{
  static const String routeName = '/LoginPage';

  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> 
{
  bool _isLoading = false;

  // دالة تسجيل الدخول: لا تحتاج لاسم المستخدم هنا لذا سنمرر null للـ username
  Future<void> _login
  (
      BuildContext context, String email, String password, String? username) async 
      {
    setState(() 
    {
      _isLoading = true;
    });
    try 
    {
      final response = await Supabase.instance.client.auth.signInWithPassword
      (
        email: email,
        password: password,
      );

      if (response.session != null) 
      {
        Navigator.pushReplacement
        (
          context,

          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } 
      else 
      {
        ScaffoldMessenger.of(context).showSnackBar
        (
          const SnackBar(content: Text("Login failed ممكن بسبب النت")),
        );
      }
    } catch (e) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text("Login failed Error: $e")),
        const SnackBar(content: Text("you Don't have an account : Login failed")),
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
      returnPageRoute: '/RegisterPage',
      doSign: _login,
      title: 'Login',
      anotheroptiontext: "Don't have an account?",
      anotheroptionpage: '  Register',
      ButtonTitle: 'LOGIN',
      showForgetPassword: true,
      showUsernameField: false, // لا نعرض حقل اسم المستخدم في صفحة الدخول
      doSignColor: myColor,
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:nine_workout/Login/LogSignBody.dart';
// import 'package:nine_workout/Pages/NavigationBar.dart';
// import 'package:nine_workout/Useless/consts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Loginpage extends StatefulWidget 
// {
//   static const String routeName = '/LoginPage';
//   const Loginpage({super.key});

//   @override
//   State<Loginpage> createState() => _LoginpageState();
// }

// class _LoginpageState extends State<Loginpage> 
// {
//   bool _isLoading = false;

//   // دالة تسجيل الدخول: لا تحتاج لاسم المستخدم هنا لذا سنمرر null للـ username
//   Future<void> _login
//   (
//       BuildContext context, String email, String password, String? username) async 
//       {
//     setState(() 
//     {
//       _isLoading = true;
//     });
//     try 
//     {
//       final response = await Supabase.instance.client.auth.signInWithPassword
//       (
//         email: email,
//         password: password,
//       );
      
//       if (response.session != null) 
//       {
//         Navigator.pushReplacement
//         (
//           context,
//           MaterialPageRoute(builder: (context) => const MainScreen()),
//         );
//       } 
      
//       else 
//       {
//         ScaffoldMessenger.of(context).showSnackBar
//         (
//           const SnackBar(content: Text("Login failed ممكن بسبب النت")),
//         );
//       }
//     } catch (e) 
//     {
//       ScaffoldMessenger.of(context).showSnackBar
//       (
//         SnackBar(content: Text("Login failed Error: $e")),
//       );
//     }
//     setState(() 
//     {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     return Logsignbody
//     (
//       returnPageRoute: '/RegisterPage',
//       doSign: _login,
//       title: 'Login',
//       anotheroptiontext: "Don't have an account?",
//       anotheroptionpage: '  Register',
//       ButtonTitle: 'LOGIN',
//       showForgetPassword: true,
//       showUsernameField: false, // لا نعرض حقل اسم المستخدم في صفحة الدخول
//       doSignColor: myColor,
//     );
//   }
// }
