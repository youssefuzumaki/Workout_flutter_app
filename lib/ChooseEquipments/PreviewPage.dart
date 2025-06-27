// import 'package:flutter/material.dart';
// import 'package:nine_workout/Useless/consts.dart';

// class Preview extends StatefulWidget 
// {
//   final List<String> equipmentPaths;
//   final Map<String, String>? Function(String) getEquipmentDetails;
//   final Function(String) onDeleteEquipment;
//   final Function(List<String>) onReorderEquipment;

//   const Preview
//   ({
//     Key? key,
//     required this.equipmentPaths,
//     required this.getEquipmentDetails,
//     required this.onDeleteEquipment,
//     required this.onReorderEquipment,
//   }) : super(key: key);

//   @override
//   _PreviewState createState() => _PreviewState();
// }

// class _PreviewState extends State<Preview> 
// {
//   // إنشاء نسخة محلية من قائمة الأجهزة بحيث يمكن تعديلها دون التأثير المباشر على القائمة الأصلية
//   late List<String> _localEquipmentPaths;

//   @override
//   void initState() 
//   {
//     super.initState();
//     _localEquipmentPaths = List.from(widget.equipmentPaths);
//   }

//   @override
//   void didUpdateWidget(covariant Preview oldWidget) 
//   {
//     super.didUpdateWidget(oldWidget);

//     // تحديث النسخة المحلية إذا حصل تغيير في الترتيب أو المحتوى
//     if (widget.equipmentPaths.toString() != _localEquipmentPaths.toString()) 
//     {
//       _localEquipmentPaths = List.from(widget.equipmentPaths);
//     }
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     // بناء قائمة من الخرائط لكل جهاز باستخدام _localEquipmentPaths والدالة getEquipmentDetails
//     List<Map<String, dynamic>> equipmentList = _localEquipmentPaths.map((assetPath) 
//     {
//       final details = widget.getEquipmentDetails(assetPath);

//       return 
//       {
//         'id': assetPath, // استخدام assetPath كمعرف فريد
//         'assetPath': assetPath,
//         'title': details?['title'] ?? 'Unknown',
//         'reps': details?['reps'] ?? '0',
//         'times': details?['times'] ?? '0',
//         'points': details?['points'] ?? '0'
//       };
//     }).toList();

//     return Scaffold
//     (
//       appBar: AppBar
//       (
//         title: const Text("Preview"),
//       ),

//       body: equipmentList.isEmpty
//           ? const Center(child: Text("لا يوجد أجهزة مضافة"))
//           : ReorderableListView
//           (
//               onReorder: (oldIndex, newIndex) 
//               {
//                 setState(() 
//                 {
//                   if (newIndex > oldIndex) newIndex -= 1;

//                   final item = _localEquipmentPaths.removeAt(oldIndex);

//                   _localEquipmentPaths.insert(newIndex, item);
//                   // إرسال النسخة الجديدة للصفحة الأم لتحديث القائمة الكلية
//                   widget.onReorderEquipment(List.from(_localEquipmentPaths));
//                 });
//               },
//               padding: const EdgeInsets.only(bottom: 20),

//               children: List.generate
//               (
//                 equipmentList.length,
//                 (index) 
//                 {
//                   final equipment = equipmentList[index];

//                   return PreviewEquipmentItemContainer
//                   (
//                     key: ValueKey(equipment['id']),
//                     index: index,
//                     equipment: equipment,
//                     onDelete: () 
//                     {
//                       setState(() 
//                       {
//                         _localEquipmentPaths.remove(equipment['assetPath']);
//                       });

//                       widget.onDeleteEquipment(equipment['assetPath']);
//                     },
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }

// class PreviewEquipmentItemContainer extends StatelessWidget 
// {
//   final int index;
//   final Map<String, dynamic> equipment;
//   final VoidCallback onDelete;

//   const PreviewEquipmentItemContainer
//   ({
//     Key? key,
//     required this.index,
//     required this.equipment,
//     required this.onDelete,
//   }) : super(key: key);

//   void _showDeleteConfirmationDialog(BuildContext context) 
//   {
//     showDialog
//     (
//       context: context,
//       builder: (context) => AlertDialog
//       (
//         backgroundColor: const Color(0xff272727),
//         shape: RoundedRectangleBorder
//         (
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text
//         (
//           'تأكيد العملية',
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//         content: const Text
//         (
//           'هل أنت متأكد أنك تريد حذف هذا العنصر؟',
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),

//         actions: 
//         [
//           TextButton
//           (
//             onPressed: () => Navigator.pop(context),
//             child: const Text
//             (
//               'إلغاء',
//               style: TextStyle(color: Colors.redAccent, fontSize: 14),
//             ),
//           ),
//           ElevatedButton
//           (
//             style: ElevatedButton.styleFrom
//             (
//               shape: RoundedRectangleBorder
//               (
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onPressed: () 
//             {
//               Navigator.pop(context);
//               onDelete();
//             },

//             child: const Text('موافق', style: TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) 
//   {
//     // الكونتينر في حالة الضغط المطول كما في صفحة CustomizedWorkout
//     final double containerWidth = 350;
//     final double containerHeight = 90;

//     final EdgeInsets containerMargin =
//         const EdgeInsets.only(top: 10, left: 50, right: 17);

//     return GestureDetector
//     (
//       onTap: () {},
//       child: Stack
//       (
//         children: 
//         [
//           AnimatedContainer
//           (
//             duration: const Duration(milliseconds: 300),

//             curve: Curves.easeInOut,
//             margin: containerMargin,
//             width: containerWidth,
//             height: containerHeight,

//             decoration: BoxDecoration
//             (
//               color: const Color(0xff272727).withOpacity(.5),
//               borderRadius: BorderRadius.circular(17),
//             ),
//             child: Stack
//             (
//               children: 
//               [
//                 Row
//                 (
//                   children: 
//                   [
//                     Padding
//                     (
//                       padding: const EdgeInsets.all(9),

//                       child: ClipRRect
//                       (
//                         borderRadius: BorderRadius.circular(22),

//                         child: Image.asset
//                         (
//                           equipment['assetPath'],

//                           width: 90,
//                           height: 90,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),

//                     const SizedBox(width: 10),

//                     Column
//                     (
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,

//                       children: 
//                       [
//                         AnimatedDefaultTextStyle
//                         (
//                           duration: const Duration(milliseconds: 300),

//                           style: const TextStyle
//                           (
//                             fontSize: 9,
//                             color: Colors.white,
//                           ),

//                           child: Text(equipment['title'] ?? 'Unknown Equipment'),
//                         ),

//                         const SizedBox(height: 10),

//                         Text
//                         (
//                           '${equipment['reps'] ?? '0'} Reps',
//                           style: const TextStyle(
//                               fontSize: 9, color: Color(0xff8B8686)),
//                         ),

//                         const SizedBox(height: 2),

//                         Text
//                         (
//                           '${equipment['times'] ?? '0'} Times',
//                           style: const TextStyle
//                           (
//                               fontSize: 9, color: Color(0xff8B8686)
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Positioned
//                 (
//                   right: 15,
//                   bottom: 30,
//                   child: ReorderableDragStartListener
//                   (
//                     index: index,
//                     child: const Icon
//                     (
//                       Icons.drag_handle_outlined,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//                 Positioned
//                 (
//                   right: 21,
//                   bottom: 10,
//                   child: Text
//                   (
//                     equipment['points'] ?? '0',
//                     style: const TextStyle
//                     (
//                       fontSize: 14,
//                       color: myColor,
//                       fontWeight: FontWeight.bold,

//                       shadows: 
//                       [
//                         Shadow
//                         (
//                           color: myColor,
//                           offset: Offset(1, 1),
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned
//           (
//             left: 7,
//             top: 0,
//             bottom: 0,
//             child: IconButton
//             (
//               icon: const Icon(Icons.delete, color: Colors.red),
//               iconSize: 24,

//               onPressed: () => _showDeleteConfirmationDialog(context),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
