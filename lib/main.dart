import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nine_workout/Login/LoginPage.dart';
import 'package:nine_workout/Login/RegisterPage.dart';
import 'package:nine_workout/Pages/NavigationBar.dart';
import 'package:nine_workout/SettingsPage/SettingsLogic.dart';
import 'package:nine_workout/scafold%20theme/DarkTheme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async 
{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize
  (
    url: "https://drjligihjmshctyxrmdk.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyamxpZ2loam1zaGN0eXhybWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM0MzI3NzIsImV4cCI6MjA1OTAwODc3Mn0.AJF3wGh13UsE7i1p6VJelD8pWagV1cvOPLuShqLdsI8",
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider
    (
      providers: 
      [
        ChangeNotifierProvider<ProfileService>
        (
          create: (_) => ProfileService(),
        ),
      ],
      child: const MyApp(initialRoute: '/MainScreen'),
    ),
  );
}

class MyApp extends StatelessWidget 
{
  
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Nine Workout',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: initialRoute,
      routes: 
      {
        Loginpage.routeName: (context) => Loginpage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        '/MainScreen': (context) => const MainScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute
      (
        builder: (context) => const Scaffold
        (
          body: Center(child: Text('الصفحة غير موجودة')),
        ),
      ),
    );
  }
}



 // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   runApp(
  //     MyApp(
  //       initialRoute: user != null ? '/MainScreen' : '/LoginPage',
  //     ),
  //   ););
  //   }



// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async 
// {

//   WidgetsFlutterBinding.ensureInitialized();

//    await Supabase.initialize(
//     url: 'https://nvcmkzqjucueahxkkvli.supabase.co',  // Project URL
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im52Y21renFqdWN1ZWFoeGtrdmxpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4Nzk1MzksImV4cCI6MjA1ODQ1NTUzOX0.DBAW7ToXXu1rMZtaBN-ZWzuWhTCp4tLzmUQdsENvCnsf',  // anon key
  
//   );

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
  
//   final InitializationSettings initializationSettings = 
//       InitializationSettings(android: initializationSettingsAndroid);
  
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //FirebaseAuth.instance.authStateChanges().listen((User? user) {
    // runApp(
    //   MyApp(
    //     initialRoute: user != null ? '/MainScreen' : '/LoginPage',
    //   ),
    // ););
    // }

     // ضبط إعدادات Cloudinary لتستخدم رابط آمن
 

  //    runApp(
  //   MyApp(
  //     initialRoute: '/MainScreen',
  //   ),
  // );
  // }
// class MyApp extends StatelessWidget {
//   final String initialRoute;
//   const MyApp({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Nine Workout',
//       debugShowCheckedModeBanner: false,
//       theme: customTheme,
//       initialRoute: initialRoute,
//       routes: {
//         Loginpage.routeName: (context) => Loginpage(),
//         Regesterpage.routeName: (context) => Regesterpage(),
//         '/MainScreen': (context) => MainScreen(),
//       },
//       onUnknownRoute: (settings) => MaterialPageRoute(
//         builder: (context) => const Scaffold(
//           body: Center(child: Text('الصفحة غير موجودة')),
//         ),
//       ),
//     );
//   }
// }