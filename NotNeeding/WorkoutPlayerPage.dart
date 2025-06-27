// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:nine_workout/Useless/consts.dart';

// class WorkoutPlayerPage extends StatefulWidget 
// {
//   final List<Map<String, dynamic>> exercises;

//   const WorkoutPlayerPage
//   ({
//     Key? key, 
//     required this.exercises,
//   }) : super(key: key);

//   @override
//   _WorkoutPlayerPageState createState() => _WorkoutPlayerPageState();
// }

// class _WorkoutPlayerPageState extends State<WorkoutPlayerPage> {
//   int currentIndex = 0;
//   // علم لتمييز فترة الراحة عن فترة التمرين
//   bool isRestPeriod = true;
//   // فترة الراحة الثابتة 5 ثواني
//   int remainingTime = 5;
//   bool isPaused = false;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.exercises.isNotEmpty) {
//       startTimer();
//     }
//   }

//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

//   // دالة التايمر التي تدير فترتي الراحة والتمرين
//   void startTimer() {
//     timer?.cancel();
//     timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!isPaused) {
//         if (remainingTime > 0) {
//           setState(() {
//             remainingTime--;
//           });
//         } else {
//           if (isRestPeriod) {
//             // انتهاء فترة الراحة، بدء التمرين الحالي
//             setState(() {
//               isRestPeriod = false;
//               // مدة التمرين الحالي أو 30 ثانية افتراضي
//               remainingTime = widget.exercises[currentIndex]['duration'] ?? 30;
//             });
//           } else {
//             // انتهاء التمرين الحالي، وفي حال وجود تمرين لاحق، يدخل فترة الراحة
//             if (currentIndex < widget.exercises.length - 1) {
//               setState(() {
//                 currentIndex++;
//                 isRestPeriod = true;
//                 remainingTime = 5;
//               });
//             } else {
//               t.cancel();
//               // انتهاء جميع التمارين، عرض رسالة انتهاء التدريب
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   backgroundColor: const Color(0xff272727),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   title: const Text(
//                     "انتهى التدريب",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pop(); // إغلاق الديالوج
//                         Navigator.of(context).pop(); // العودة للصفحة السابقة
//                       },
//                       child: const Text("موافق", style: TextStyle(color: myColor)),
//                     )
//                   ],
//                 ),
//               );
//             }
//           }
//         }
//       }
//     });
//   }

//   // تبديل حالة الإيقاف المؤقت/التشغيل
//   void togglePause() {
//     setState(() {
//       isPaused = !isPaused;
//     });
//   }

//   // تحويل الثواني لصيغة MM:SS
//   String formatTime(int seconds) {
//     final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds % 60).toString().padLeft(2, '0');
//     return "$minutes:$secs";
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.exercises.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("مشغل التمارين")),
//         body: const Center(child: Text("لا توجد تمارين متاحة")),
//       );
//     }

//     final currentExercise = widget.exercises[currentIndex];
//     // الحصول على مسار الصورة من المفتاح assetPath
//     final String imageAsset =
//         currentExercise['assetPath'] ?? 'Gifs/Back/main/main_Flexability/Butterfly-Stretch.gif';
//     final title = currentExercise['title'] ?? "تمرين";

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           isRestPeriod ? "راحة" : "$title",style: TextStyle(fontSize: 15),),
//         centerTitle: true,
//         actions: [
//           IconButton
//           (
//             icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
//             onPressed: togglePause,
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // عرض صورة التمرين مع إطار
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey,
//                   width: 5,
//                 ),
//                 borderRadius: BorderRadius.circular(45),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(40),
//                 child: Image.asset(
//                   imageAsset,
//                   fit: BoxFit.cover,
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // عرض العنوان أو رسالة الاستعداد في فترة الراحة
//             Text(
//               isRestPeriod ? "استعد للتمرين" : title,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             // عرض المؤقت
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: myColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 formatTime(remainingTime),
//                 style: const TextStyle(fontSize: 36, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // عرض مؤشر للتقدم أو رسالة الراحة
//             Text(isRestPeriod
//                 ? "راحة 5 ثواني"
//                 : "تمرين ${currentIndex + 1} من ${widget.exercises.length}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
