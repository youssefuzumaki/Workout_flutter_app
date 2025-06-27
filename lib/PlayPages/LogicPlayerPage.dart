import 'dart:async';

import 'package:flutter/foundation.dart';

class LogicPlayerPage 
{
  final List<Map<String, dynamic>> exercises;
  
  int currentIndex = 0;
  bool isRestPeriod = true;
  int remainingTime = 5;
  bool isPaused = false;
  Timer? timer;

  LogicPlayerPage
  ({
    required this.exercises,
  });

  // يبدأ التايمر مع Callback للتحديث وعند الانتهاء
  void startTimer(VoidCallback onTick, VoidCallback onComplete) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isPaused) {
        if (remainingTime > 0) {
          remainingTime--;
          onTick();
        } else {
          if (isRestPeriod) {
            isRestPeriod = false;
            remainingTime = exercises[currentIndex]['duration'] ?? 30;
            onTick();
          } else {
            if (currentIndex < exercises.length - 1) {
              currentIndex++;
              isRestPeriod = true;
              remainingTime = 5;
              onTick();
            } else {
              t.cancel();
              onComplete();
            }
          }
        }
      }
    });
  }

  // تبديل حالة الإيقاف المؤقت
  void togglePause() {
    isPaused = !isPaused;
  }

  // تحويل الثواني لصيغة MM:SS
  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // إلغاء التايمر عند عدم الحاجة إليه
  void dispose() {
    timer?.cancel();
  }

  
}
