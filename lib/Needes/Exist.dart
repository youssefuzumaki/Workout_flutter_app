import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لاستخدام SystemNavigator.pop()

class DoubleSwipeExit extends StatefulWidget {
  final Widget child;
  const DoubleSwipeExit({Key? key, required this.child}) : super(key: key);

  @override
  _DoubleSwipeExitState createState() => _DoubleSwipeExitState();
}

class _DoubleSwipeExitState extends State<DoubleSwipeExit> {
  DateTime? _lastExitAttempt;
  Offset? _dragStartPosition; // لتخزين نقطة بداية السحب

  // دالة التعامل مع زر الرجوع (Back button)
  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastExitAttempt == null ||
        now.difference(_lastExitAttempt!) > const Duration(seconds: 2)) {
      _lastExitAttempt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("اضغط مرة أخرى للخروج")),
      );
      return false;
    } else {
      SystemNavigator.pop();
      return true;
    }
  }

  // دالة التعامل مع إيماءة السحب الأفقي
  void _handleHorizontalSwipe() {
    final now = DateTime.now();
    if (_lastExitAttempt == null ||
        now.difference(_lastExitAttempt!) > const Duration(seconds: 2)) {
      _lastExitAttempt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("اسحب مرة تانية للخروج")),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد قيمة عتبة الحافة (مثلاً 25 بكسل)
    const double edgeThreshold = 25.0;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        // تم تغيير السلوك من opaque إلى translucent للسماح بمرور اللمسات للأجزاء التفاعلية الداخلية
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (details) {
          _dragStartPosition = details.globalPosition;
        },
        onHorizontalDragEnd: (details) {
          if (_dragStartPosition != null) {
            final screenWidth = MediaQuery.of(context).size.width;
            bool fromLeftEdge = _dragStartPosition!.dx <= edgeThreshold;
            bool fromRightEdge =
                _dragStartPosition!.dx >= screenWidth - edgeThreshold;

            if (fromLeftEdge || fromRightEdge) {
              if (details.velocity.pixelsPerSecond.dx.abs() > 300) {
                _handleHorizontalSwipe();
              }
            }
          }
          _dragStartPosition = null;
        },
        child: widget.child,
      ),
    );
  }
}
