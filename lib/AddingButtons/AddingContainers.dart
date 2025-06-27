import 'package:flutter/material.dart';
import 'package:nine_workout/Customized_workouts_pages/customized_workout_page.dart';

class AddingContainers extends StatefulWidget {
  final String docId;
  final String? title;
  final Function(String) onDelete;

  const AddingContainers({
    super.key,
    required this.docId,
    required this.title,
    required this.onDelete,
  });

  @override
  State<AddingContainers> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<AddingContainers>
    with SingleTickerProviderStateMixin {
  // ثابت لتتبع الكونتينر الذي في حالة الضغط المطول
  static _CustomContainerState? activeState;

  bool _isLongPressed = false;

  // دالة لإعادة الكونتينر للوضع الطبيعي
  void resetLongPressed() {
    if (mounted) {
      setState(() {
        _isLongPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    // عند الضغط المطول، يصبح عرض الكونتينر أصغر
    final double containerWidth = _isLongPressed ? 285 : 360;
    final double containerHeight = _isLongPressed ? 110 : 150;
    final double scaleFactor = containerWidth / 420;
    final double imageSize = 150 * scaleFactor;
    // تقليل المسافة بين النصوص في حالة الضغط المطول لتجنب مشكلة الـ overflow
    final double spacingBetweenPointsAndKcal =
        _isLongPressed ? 15 * scaleFactor : 30 * scaleFactor;

    return GestureDetector(
      onLongPress: () {
        // إذا كان هناك كونتينر آخر في حالة ضغط مطول، نعيده للوضع الطبيعي
        if (activeState != null && activeState != this) {
          activeState!.resetLongPressed();
        }
        setState(() {
          _isLongPressed = true;
        });
        activeState = this;
      },
      onTap: () {
        // إذا كان هناك كونتينر آخر في وضع ضغط مطول غير هذا، نعيده للوضع الطبيعي
        if (activeState != null && activeState != this) {
          activeState!.resetLongPressed();
          activeState = null;
          return;
        }
        // إذا كان هذا الكونتينر في وضع الضغط المطول، نقوم بإعادة تعيين الحالة
        if (_isLongPressed) {
          setState(() {
            _isLongPressed = false;
          });
          activeState = null;
        } else {
          // الانتقال للصفحة المحدثة CustomizedWorkoutPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomizedWorkoutPage(workoutId: widget.docId),
            ),
          );
        }
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: containerWidth,
            height: containerHeight,
            margin:
                const EdgeInsets.only(top: 7, left: 15, right: 17, bottom: 7),
            decoration: BoxDecoration(
              color: const Color(0xff272727).withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 10 * scaleFactor, top: 17 * scaleFactor),
                  // AnimatedSize مع vsync لضمان حركة سلسة
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22 * scaleFactor,
                          ),
                          child: Text(widget.title ?? ''),
                        ),
                        SizedBox(height: 5 * scaleFactor),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * scaleFactor,
                          ),
                          child: const Text('50 Points'),
                        ),
                        SizedBox(height: spacingBetweenPointsAndKcal),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            color: const Color(0xff8B8686),
                            fontSize: 13 * scaleFactor - 1,
                          ),
                          child: const Text('80 Kcal / 60 min'),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            color: const Color(0xff8B8686),
                            fontSize: 13 * scaleFactor - 1,
                          ),
                          child: const Text('10 Times this month'),
                        ),
                      ],
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 0 * scaleFactor),
                      child: Image.asset(
                        'assets/workout_page_componant/left shape.png',
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10 * scaleFactor),
                      child: Image.asset(
                        'assets/new_muscle/Add_Image.png',
                        width: imageSize,
                        height: imageSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isLongPressed)
            Positioned(
              right: 7,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                iconSize: 24 * scaleFactor,
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff272727),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'تأكيد العملية',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف هذا العنصر؟',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete(widget.docId);
              setState(() {
                _isLongPressed = false;
              });
              activeState = null;
            },
            child: const Text('موافق', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
