import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

import 'LogicPlayerPage.dart';

class PlayPageBody extends StatefulWidget {
  final List<Map<String, dynamic>> exercises;
  const PlayPageBody({Key? key, required this.exercises}) : super(key: key);

  @override
  _PlayPageBodyState createState() => _PlayPageBodyState();
}

class _PlayPageBodyState extends State<PlayPageBody> {
  late LogicPlayerPage workoutLogic;

  @override
  void initState() {
    super.initState();
    workoutLogic = LogicPlayerPage(exercises: widget.exercises);
    if (widget.exercises.isNotEmpty) {
      workoutLogic.startTimer(() {
        setState(() {}); // تحديث الواجهة عند كل tick
      }, () {
        // عند انتهاء جميع التمارين
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xff272727),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "انتهى التدريب",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // إغلاق الديالوج
                  Navigator.of(context).pop(); // العودة للصفحة السابقة
                },
                child: const Text("موافق", style: TextStyle(color: myColor)),
              )
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    workoutLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("مشغل التمارين")),
        body: const Center(child: Text("لا توجد تمارين متاحة")),
      );
    }

    final currentExercise = widget.exercises[workoutLogic.currentIndex];
    final String imageAsset = currentExercise['assetPath'] ??
        'Gifs/Back/main/main_Flexability/Butterfly-Stretch.gif';
    final title = currentExercise['title'] ?? "تمرين";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          workoutLogic.isRestPeriod ? "راحة" : title,
          style: const TextStyle(fontSize: 15),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(workoutLogic.isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: () {
              setState(() {
                workoutLogic.togglePause();
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض صورة التمرين مع إطار
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 5),
                borderRadius: BorderRadius.circular(45),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // عرض العنوان أو رسالة الاستعداد في فترة الراحة
            Text(
              workoutLogic.isRestPeriod ? "استعد للتمرين" : title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // عرض المؤقت
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                workoutLogic.formatTime(workoutLogic.remainingTime),
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // عرض مؤشر التقدم أو رسالة الراحة
            Text(workoutLogic.isRestPeriod
                ? "راحة 5 ثواني"
                : "تمرين ${workoutLogic.currentIndex + 1} من ${widget.exercises.length}"),
          ],
        ),
      ),
    );
  }
}
