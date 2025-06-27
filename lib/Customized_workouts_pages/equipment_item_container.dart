import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

class EquipmentItemContainer extends StatelessWidget 
{
  final int index;
  final Map<String, dynamic> equipment;
  final Map<String, String>? details;
  final int duration;
  final bool isLongPressed;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final Function(int) onSetDuration;

  const EquipmentItemContainer
  ({
    Key? key,
    required this.index,
    required this.equipment,
    required this.details,
    required this.duration,
    required this.isLongPressed,
    required this.onLongPress,
    required this.onDelete,
    required this.onTap,
    required this.onSetDuration,
  }) : super(key: key);

  Future<void> _showDurationDialog(BuildContext context) async 
  {
    final sec = await showDialog<int>
    (
      context: context,

      builder: (_) => AlertDialog
      (
        title: const Text('حدد مدة التمرين (ثواني)'),

        content: TextField
        (
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: duration.toString()),
          onSubmitted: (v) 
          {
            final i = int.tryParse(v);
            Navigator.pop(context, i);
          },
        ),
      ),
    );

    if (sec != null) 
    {
      onSetDuration(sec);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    final double containerWidth = isLongPressed ? 350 : 379;

    final double containerHeight = isLongPressed ? 90 : 110;

    final EdgeInsets containerMargin = isLongPressed
        ? const EdgeInsets.only(top: 10, left: 50, right: 17)
        : const EdgeInsets.only(top: 10, left: 15, right: 17);

    return GestureDetector
    (

      onLongPress: onLongPress,
      onTap: onTap,

      child: Container
      (
        margin: containerMargin,
        width: containerWidth,
        height: containerHeight,

        child: Stack
        (
          children: 
          [
            // الخلفية والمحتوى الرئيسي
            AnimatedContainer
            (
              duration: const Duration(milliseconds: 300),

              curve: Curves.easeInOut,
              width: containerWidth,
              height: containerHeight,

              decoration: BoxDecoration
              (
                color: const Color(0xff272727).withOpacity(0.5),

                borderRadius: BorderRadius.circular(17),
              ),
              child: Row
              (
                children: 
                [
                  // الصورة
                  Padding
                  (
                    padding: const EdgeInsets.all(9),

                    child: ClipRRect
                    (
                      borderRadius: BorderRadius.circular(22),

                      child: Image.asset
                      (
                        equipment['name'] ?? 'assets/placeholder.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // النصوص
                  Expanded
                  (
                    child: Column
                    (
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: 
                      [
                        Text
                        (
                          details?['title'] ?? 'Unknown Equipment',

                          style: TextStyle
                          (
                            fontSize: isLongPressed ? 9 : 13,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text
                        (
                          '${details?['reps'] ?? '0'} Reps',

                          style: const TextStyle
                          (
                            fontSize: 9,
                            color: Color(0xff8B8686),
                          ),
                        ),
                        Text
                        (
                          '${details?['times'] ?? '0'} Times',

                          style: const TextStyle
                          (
                            fontSize: 9,
                            color: Color(0xff8B8686),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // زرّ الحذف (على اليسار) عند الضغط المطول
            if (isLongPressed)
              Positioned
              (
                left: 7,
                top: 0,
                bottom: 0,

                child: IconButton
                (
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),

            // مقبض السحب لإعادة الترتيب
            if (isLongPressed)
              Positioned
              (
                right: 15,
                bottom: 30,

                child: ReorderableDragStartListener
                (
                  index: index,
                  child: const Icon
                  (
                    Icons.drag_handle_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

            // Badge مدة التمرين
            Positioned
            (
              top: 5,
              right: 5,

              child: GestureDetector
              (
                onTap: () => _showDurationDialog(context),

                child: Container
                (
                  padding: const EdgeInsets.all(4),

                  decoration: BoxDecoration
                  (
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Text
                  (
                    '$duration sec',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
            // عرض النقاط
            Positioned
            (
              bottom: 10,
              right: 21,
              child: Text
              (
                details?['points'] ?? '0',
                
                style: const TextStyle
                (
                  fontSize: 14,
                  color: myColor,
                  fontWeight: FontWeight.bold,

                  shadows: 
                  [
                    Shadow
                    (
                      color: myColor,
                      offset: Offset(1, 1),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
