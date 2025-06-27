// lib/widgets/preview_equipment_item.dart

import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

class PreviewEquipmentItem extends StatelessWidget 
{
  final int index;
  final Map<String, dynamic> equipment;
  final VoidCallback onDelete;

  const PreviewEquipmentItem
  ({
    Key? key,
    required this.index,
    required this.equipment,
    required this.onDelete,
  }) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context) 
  {
    showDialog
    (
      context: context,

      builder: (ctx) => AlertDialog
      (
        backgroundColor: const Color(0xff272727),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        title: const Text
        (
          'تأكيد العملية',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: const Text
        (
          'هل أنت متأكد أنك تريد حذف هذا العنصر؟',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),

        actions: 
        [
          TextButton
          (
            onPressed: () => Navigator.pop(ctx),

            child: const Text
            (
              'إلغاء',
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),

          ElevatedButton
          (
            style: ElevatedButton.styleFrom
            (
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),

            onPressed: () 
            {
              Navigator.pop(ctx);
              onDelete();
            },

            child: const Text('موافق', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return GestureDetector
    (
      onLongPress: () => _showDeleteConfirmationDialog(context),

      child: Stack
      (
        children: 
        [
          AnimatedContainer
          (
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(top: 10, left: 50, right: 17),
            width: 350,
            height: 90,

            decoration: BoxDecoration
            (
              color: const Color(0xff272727).withOpacity(.5),
              borderRadius: BorderRadius.circular(17),
            ),

            child: Stack
            (
              children: 
              [
                Row
                (
                  children: 
                  [
                    Padding
                    (
                      padding: const EdgeInsets.all(9),

                      child: ClipRRect
                      (
                        borderRadius: BorderRadius.circular(22),
                        
                        child: Image.asset
                        (
                          equipment['assetPath'],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column
                    (
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: 
                      [
                        AnimatedDefaultTextStyle
                        (
                          duration: const Duration(milliseconds: 300),
                          style: const TextStyle(fontSize: 9, color: Colors.white),
                          child: Text(equipment['title']),
                        ),

                        const SizedBox(height: 10),

                        Text
                        (
                          '${equipment['reps']} Reps',
                          style: const TextStyle(fontSize: 9, color: Color(0xff8B8686)),
                        ),

                        const SizedBox(height: 2),

                        Text
                        (
                          '${equipment['times']} Times',
                          style: const TextStyle(fontSize: 9, color: Color(0xff8B8686)),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned
                (
                  right: 15,
                  bottom: 30,
                  child: ReorderableDragStartListener
                  (
                    index: index,
                    child: const Icon(Icons.drag_handle_outlined, size: 30, color: Colors.white),
                  ),
                ),

                Positioned
                (
                  right: 21,
                  bottom: 10,
                  child: Text
                  (
                    equipment['points'],
                    style: const TextStyle
                    (
                      fontSize: 14,
                      color: myColor,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: myColor, offset: Offset(1, 1), blurRadius: 5)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned
          (
            left: 7,
            top: 0,
            bottom: 0,
            child: IconButton
            (
              icon: const Icon(Icons.delete, color: Colors.red),
              iconSize: 24,
              onPressed: () => _showDeleteConfirmationDialog(context),
            ),
          ),
        ],
      ),
    );
  }
}
