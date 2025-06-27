// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:nine_workout/ChooseEquipments/Add_Equipment_Selection_Page.dart';
// import 'package:nine_workout/DataFolder/FlexibilityEquipment.dart';
// import 'package:nine_workout/DataFolder/IndoorEquipment.dart';
// import 'package:nine_workout/DataFolder/WorkoutEquipment.dart';
// import 'package:nine_workout/Pages/DetailsPage.dart';
// import 'package:nine_workout/PlayPages/PlayPageBody.dart';
// import 'package:nine_workout/Useless/consts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// /// صفحة CustomizedWorkout الرئيسية
// class CustomizedWorkout extends StatefulWidget {
//   final String workoutId;
//   const CustomizedWorkout({Key? key, required this.workoutId}) : super(key: key);

//   @override
//   _CustomizedWorkoutState createState() => _CustomizedWorkoutState();
// }

// class _CustomizedWorkoutState extends State<CustomizedWorkout> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> _equipmentList = [];
//   bool _isLoading = false;
//   String? workoutName;
//   String? _activeLongPressedId; // معرف العنصر المفعل بوضع الضغط المطول
//   bool _isReorderMode = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchWorkoutName();
//     _fetchEquipment();
//   }

//   Future<void> _fetchWorkoutName() async {
//     final response = await _supabase
//         .from('workouts')
//         .select('name')
//         .eq('id', widget.workoutId);
//     if (response != null && response is List && response.isNotEmpty) {
//       setState(() {
//         workoutName = response[0]['name'];
//       });
//     }
//   }

//   Future<void> _fetchEquipment() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final response = await _supabase
//         .from('equipments')
//         .select()
//         .eq('workout_id', widget.workoutId);
//     if (response != null) {
//       setState(() {
//         _equipmentList = List<Map<String, dynamic>>.from(response as List);
//       });
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // تحديث مدة الجهاز
//   void _setEquipmentDuration(String equipmentId, int newDuration) {
//     setState(() {
//       int index =
//           _equipmentList.indexWhere((equipment) => equipment['id'] == equipmentId);
//       if (index != -1) {
//         _equipmentList[index]['duration'] = newDuration;
//       }
//     });
//   }

//   // البحث في الخرائط لاسترجاع تفاصيل الجهاز
//   Map<String, String>? getEquipmentDetails(String assetPath) {
//     for (final muscle in WorkoutEquipment.keys) {
//       final subgroups = WorkoutEquipment[muscle];
//       if (subgroups != null) {
//         for (final subgroup in subgroups.keys) {
//           final categoryMap = subgroups[subgroup];
//           if (categoryMap != null) {
//             for (final type in categoryMap.keys) {
//               final equipmentMap = categoryMap[type];
//               if (equipmentMap != null && equipmentMap.containsKey(assetPath)) {
//                 return equipmentMap[assetPath];
//               }
//             }
//           }
//         }
//       }
//     }
//     for (final muscle in FlexibilityEquipment.keys) {
//       final subgroups = FlexibilityEquipment[muscle];
//       if (subgroups != null) {
//         for (final subgroup in subgroups.keys) {
//           final categoryMap = subgroups[subgroup];
//           if (categoryMap != null) {
//             for (final type in categoryMap.keys) {
//               final equipmentMap = categoryMap[type];
//               if (equipmentMap != null && equipmentMap.containsKey(assetPath)) {
//                 return equipmentMap[assetPath];
//               }
//             }
//           }
//         }
//       }
//     }
//     for (final muscle in IndoorEquipment.keys) {
//       final subgroups = IndoorEquipment[muscle];
//       if (subgroups != null) {
//         for (final subgroup in subgroups.keys) {
//           final categoryMap = subgroups[subgroup];
//           if (categoryMap != null) {
//             for (final type in categoryMap.keys) {
//               final equipmentMap = categoryMap[type];
//               if (equipmentMap != null && equipmentMap.containsKey(assetPath)) {
//                 return equipmentMap[assetPath];
//               }
//             }
//           }
//         }
//       }
//     }
//     return null;
//   }

//   // الانتقال لصفحة إضافة الأجهزة
//   Future<void> _addEquipment() async {
//     final List<dynamic>? returnedData = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEquipmentSelectionPage(
//           workoutId: widget.workoutId,
//           initialEquipmentPaths:
//               _equipmentList.map((e) => e['name'] as String).toList(),
//         ),
//       ),
//     );
//     if (returnedData != null && returnedData.isNotEmpty) {
//       await _supabase.from('equipments').delete().eq('workout_id', widget.workoutId);
//       for (final equipment in returnedData) {
//         try {
//           await _supabase.from('equipments').insert({
//             'name': equipment['assetPath'],
//             'workout_id': widget.workoutId,
//             'muscle_group': 'custom'
//           });
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('فشل في إضافة الجهاز: ${e.toString()}')),
//           );
//         }
//       }
//       await _fetchEquipment();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم تحديث الأجهزة بنجاح')),
//       );
//     }
//   }

//   // حذف الجهاز من القائمة وقاعدة البيانات
//   Future<void> _deleteEquipment(Map<String, dynamic> equipment) async {
//     final id = equipment['id'];
//     try {
//       await _supabase.from('equipments').delete().eq('id', id);
//       setState(() {
//         _equipmentList.remove(equipment);
//         if (_activeLongPressedId == equipment['id']) {
//           _activeLongPressedId = null;
//         }
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم حذف الجهاز بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('فشل في حذف الجهاز: ${e.toString()}')),
//       );
//     }
//   }

//   // تفعيل أو إلغاء الضغط المطول
//   void _setActiveLongPressed(String? id) {
//     setState(() {
//       _activeLongPressedId = id;
//     });
//   }

//   // إعادة ترتيب العناصر
//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) newIndex = newIndex - 1;
//       final item = _equipmentList.removeAt(oldIndex);
//       _equipmentList.insert(newIndex, item);
//       _isReorderMode = true;
//     });
//   }

//   // حفظ الترتيب الجديد في قاعدة البيانات
//   Future<void> _saveNewOrder() async {
//     await _supabase.from('equipments').delete().eq('workout_id', widget.workoutId);
//     for (final equipment in _equipmentList) {
//       try {
//         await _supabase.from('equipments').insert({
//           'name': equipment['name'],
//           'workout_id': widget.workoutId,
//           'muscle_group': 'custom'
//         });
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('فشل في حفظ الترتيب: ${e.toString()}')),
//         );
//       }
//     }
//     await _fetchEquipment();
//     setState(() {
//       _isReorderMode = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('تم حفظ الترتيب الجديد')),
//     );
//   }

//   // بناء عنصر عرض الجهاز
//   Widget _buildEquipmentItem(Map<String, dynamic> equipment, int index) {
//     String assetPath = equipment['name'] ?? 'assets/placeholder.png';
//     Map<String, String>? details = getEquipmentDetails(assetPath);
//     bool isLongPressed = (_activeLongPressedId == equipment['id']);
//     int duration =
//         equipment.containsKey('duration') ? equipment['duration'] as int : 30;

//     return EquipmentItemContainer(
//       key: ValueKey(equipment['id']),
//       index: index,
//       equipment: equipment,
//       details: details,
//       duration: duration,
//       isLongPressed: isLongPressed,
//       onLongPress: () {
//         if (isLongPressed) {
//           _setActiveLongPressed(null);
//         } else {
//           _setActiveLongPressed(equipment['id']);
//         }
//       },
//       onDelete: _deleteEquipment,
//       onSetDuration: (newDuration) {
//         _setEquipmentDuration(equipment['id'], newDuration);
//       },
//       onTap: () {
//         if (_activeLongPressedId != null) {
//           _setActiveLongPressed(null);
//           return;
//         }
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => DetailsPage(
//               titlesize: 15,
//               title: details?['title'] ?? 'Unknown Equipment',
//               imageAsset: assetPath,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // دالة بدء التمرين بعد تحويل البيانات لتتضمن المفاتيح المطلوبة
//   void _startWorkout() {
//     List<Map<String, dynamic>> exercises = _equipmentList.map((e) {
//       if (!e.containsKey('duration')) {
//         e['duration'] = 30;
//       }
//       e['assetPath'] = e['name'];
//       final details = getEquipmentDetails(e['name']);
//       e['title'] = details?['title'] ?? 'Unknown Equipment';
//       e['points'] = details?['points'] ?? '0';
//       e['times'] = details?['times'] ?? '0';
//       e['reps'] = details?['reps'] ?? '0';
//       return e;
//     }).toList();

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlayPageBody
//         (
//           exercises: exercises,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 65,
//         centerTitle: true,
//         title: Text(
//           workoutName ?? 'No workout name',
//           style: const TextStyle(fontSize: 20),
//         ),
//         actions: [
//           _isReorderMode
//               ? TextButton(
//                   onPressed: _saveNewOrder,
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(
//                         color: Color.fromARGB(255, 97, 96, 96),
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 )
//               : IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: _addEquipment,
//                 ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _equipmentList.isEmpty
//                   ? const Center(child: Text('ابدأ تمرينك بإضافة أجهزة'))
//                   : ReorderableListView(
//                       onReorder: _onReorder,
//                       padding: const EdgeInsets.only(bottom: 80),
//                       children: List.generate(
//                         _equipmentList.length,
//                         (index) => _buildEquipmentItem(_equipmentList[index], index),
//                       ),
//                     ),
//           // زر التشغيل (Play) في أسفل الصفحة
//           if (!_isLoading && _equipmentList.isNotEmpty)
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: _startWorkout,
//                   child: const Text("Play"),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// /// كونتينار عرض الجهاز مع التفاصيل والمؤقت لتحديد مدة التمرين
// class EquipmentItemContainer extends StatelessWidget {
//   final int index;
//   final Map<String, dynamic> equipment;
//   final Map<String, String>? details;
//   final int duration;
//   final bool isLongPressed;
//   final VoidCallback onLongPress;
//   final Function(Map<String, dynamic>) onDelete;
//   final VoidCallback onTap;
//   final Function(int) onSetDuration;

//   const EquipmentItemContainer({
//     Key? key,
//     required this.index,
//     required this.equipment,
//     required this.details,
//     required this.duration,
//     required this.isLongPressed,
//     required this.onLongPress,
//     required this.onDelete,
//     required this.onTap,
//     required this.onSetDuration,
//   }) : super(key: key);

//   void _showDeleteConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xff272727),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text(
//           'تأكيد العملية',
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//         content: const Text(
//           'هل أنت متأكد أنك تريد حذف هذا العنصر؟',
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'إلغاء',
//               style: TextStyle(color: Colors.redAccent, fontSize: 14),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               onDelete(equipment);
//             },
//             child: const Text('موافق', style: TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showDurationDialog(BuildContext context) async {
//     final controller = TextEditingController(text: duration.toString());
//     final int? newDuration = await showDialog<int>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("حدد مدة التمرين (بالثواني)"),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(hintText: "أدخل عدد الثواني"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, null),
//             child: const Text("إلغاء"),
//           ),
//           TextButton(
//             onPressed: () {
//               final sec = int.tryParse(controller.text);
//               Navigator.pop(context, sec);
//             },
//             child: const Text("حفظ"),
//           ),
//         ],
//       ),
//     );
//     if (newDuration != null) {
//       onSetDuration(newDuration);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double containerWidth = isLongPressed ? 350 : 379;
//     final double containerHeight = isLongPressed ? 90 : 110;
//     final EdgeInsets containerMargin = isLongPressed
//         ? const EdgeInsets.only(top: 10, left: 50, right: 17)
//         : const EdgeInsets.only(top: 10, left: 15, right: 17);

//     return GestureDetector(
//       onLongPress: onLongPress,
//       onTap: onTap,
//       child: Stack(
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//             margin: containerMargin,
//             width: containerWidth,
//             height: containerHeight,
//             decoration: BoxDecoration(
//               color: const Color(0xff272727).withOpacity(.5),
//               borderRadius: BorderRadius.circular(17),
//             ),
//             child: Stack(
//               children: [
//                 Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(9),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(22),
//                         child: Image.asset(
//                           equipment['name'] ?? 'assets/placeholder.png',
//                           width: 90,
//                           height: 90,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AnimatedDefaultTextStyle(
//                           duration: const Duration(milliseconds: 300),
//                           style: TextStyle(
//                             fontSize: isLongPressed ? 9 : 13,
//                             color: Colors.white,
//                           ),
//                           child: Text(
//                             details?['title'] ?? 'Unknown Equipment',
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           '${details?['reps'] ?? '0'} Reps',
//                           style: const TextStyle(fontSize: 9, color: Color(0xff8B8686)),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           '${details?['times'] ?? '0'} Times',
//                           style: const TextStyle(fontSize: 9, color: Color(0xff8B8686)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 if (isLongPressed)
//                   Positioned(
//                     right: 15,
//                     bottom: 30,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {},
//                       onLongPress: () {},
//                       child: ReorderableDragStartListener(
//                         index: index,
//                         child: const Icon(
//                           Icons.drag_handle_outlined,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                 Positioned(
//                   right: 21,
//                   bottom: 10,
//                   child: Text(
//                     details?['points'] ?? '0',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: myColor,
//                       fontWeight: FontWeight.bold,
//                       shadows: [
//                         Shadow(
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
//           if (isLongPressed)
//             Positioned(
//               left: 7,
//               top: 0,
//               bottom: 0,
//               child: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 iconSize: 24,
//                 onPressed: () => _showDeleteConfirmationDialog(context),
//               ),
//             ),
//           Positioned(
//             top: 5,
//             right: 5,
//             child: GestureDetector(
//               onTap: () => _showDurationDialog(context),
//               child: Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "$duration sec",
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
