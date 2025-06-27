// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// // استورد الخرائط الخاصة بكل نوع (مع البنية المحدثة: يوجد مستوى إضافي لتقسيم main و sub)
// import 'package:nine_workout/DataFolder/FlexibilityEquipment.dart';
// import 'package:nine_workout/DataFolder/IndoorEquipment.dart';
// import 'package:nine_workout/DataFolder/PreviewPage.dart';
// import 'package:nine_workout/DataFolder/WorkoutEquipment.dart';
// import 'package:nine_workout/Useless/consts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AddEquipmentSelectionPage extends StatefulWidget {
//   final String workoutId;
//   // قائمة الأجهزة المحفوظة مسبقاً في الـ CustomizedWorkout (assetPath)
//   final List<String>? initialEquipmentPaths;
//   const AddEquipmentSelectionPage({
//     Key? key,
//     required this.workoutId,
//     this.initialEquipmentPaths,
//   }) : super(key: key);

//   @override
//   _AddEquipmentSelectionPageState createState() =>
//       _AddEquipmentSelectionPageState();
// }

// class _AddEquipmentSelectionPageState extends State<AddEquipmentSelectionPage> {
//   final SupabaseClient _supabase = Supabase.instance.client;
//   // مؤشر الصفحة النشطة لشريط التنقل العلوي
//   int _selectedIndex = 0;

//   // قائمة عناوين الصفحات لتستخدم في AppBar
//   final List<String> _pageTitles = [
//     'Workout',
//     'Flexibility',
//     'Indoor',
//     'Preview'
//   ];

//   // قائمة لتخزين روابط الصور المُختارة (للحفاظ على الترتيب)
//   final List<String> selectedEquipmentPaths = [];

//   late final PageController _pageController;

//   // GlobalKey للعنصر الحاوي لشريط التنقل
//   final GlobalKey _navBarKey = GlobalKey();
//   // مفاتيح لكل زر من أزرار التنقل
//   final List<GlobalKey> _tabKeys = List.generate(4, (index) => GlobalKey());
//   // لتخزين عرض وموقع كل زر بالنسبة لشريط التنقل
//   List<double> _tabWidths = [0, 0, 0, 0];
//   List<double> _tabOffsets = [0, 0, 0, 0];

//   // تعريف عرض أدنى للمؤشر حتى لو كان النص قصير
//   final double _minIndicatorWidth = 80;

//   @override
//   void initState() {
//     super.initState();
//     // إضافة الأجهزة القديمة فقط لو القائمة فارغة لتفادي التكرار عند إعادة الدخول
//     if (widget.initialEquipmentPaths != null && selectedEquipmentPaths.isEmpty) {
//       selectedEquipmentPaths.addAll(widget.initialEquipmentPaths!);
//     }
//     _pageController = PageController(initialPage: _selectedIndex);
//     // حساب مواقع وأحجام الأزرار بعد اكتمال بناء الواجهة
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _calculateTabOffsetsAndWidths();
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   // دالة لحساب عرض وموقع كل زر نصي داخل شريط التنقل
//   void _calculateTabOffsetsAndWidths() {
//     final navBarBox =
//         _navBarKey.currentContext?.findRenderObject() as RenderBox?;
//     if (navBarBox == null) return;
//     final navBarPosition = navBarBox.localToGlobal(Offset.zero);

//     List<double> widths = [];
//     List<double> offsets = [];
//     for (var key in _tabKeys) {
//       final box = key.currentContext?.findRenderObject() as RenderBox?;
//       if (box != null) {
//         widths.add(box.size.width + 16);
//         final position = box.localToGlobal(Offset.zero);
//         offsets.add(position.dx - navBarPosition.dx - 8);
//       } else {
//         widths.add(0);
//         offsets.add(0);
//       }
//     }
//     setState(() {
//       _tabWidths = widths;
//       _tabOffsets = offsets;
//     });
//   }

//   // دالة لتبديل اختيار العنصر (بناءً على assetPath)
//   void _toggleSelection(String assetPath) {
//     setState(() {
//       if (selectedEquipmentPaths.contains(assetPath)) {
//         selectedEquipmentPaths.remove(assetPath);
//       } else {
//         selectedEquipmentPaths.add(assetPath);
//       }
//     });
//   }

//   // دالة رفع الملف باستخدام منطق supabase كما هو
//   Future<String?> _uploadTextFile(String assetPath) async {
//     try {
//       final user = _supabase.auth.currentUser;
//       if (user == null) return null;
//       final fileName =
//           '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}.txt';
//       final storagePath = '${user.id}/workouts/${widget.workoutId}/$fileName';
//       final bytes = Uint8List.fromList(utf8.encode(assetPath));
//       final response = await _supabase.storage
//           .from('user-data')
//           .uploadBinary(storagePath, bytes);
//       if (response != null) {
//         return assetPath;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error uploading text file: $e');
//       return null;
//     }
//   }

//   // دالة البحث لتعمل مع البنية المحدثة (يبحث في main و sub)
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

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     _pageController.animateToPage(index,
//         duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//   }

//   // دالة حذف جهاز من Preview (تحديث القائمة)
//   void _deleteEquipmentFromPreview(String assetPath) {
//     setState(() {
//       selectedEquipmentPaths.remove(assetPath);
//     });
//   }

//   // دالة إعادة ترتيب الأجهزة من Preview (تحديث القائمة) باستخدام نسخة جديدة من القائمة
//   void _reorderEquipmentFromPreview(List<String> newOrder) {
//     setState(() {
//       selectedEquipmentPaths
//         ..clear()
//         ..addAll(newOrder);
//     });
//   }

//   // إنشاء الصفحات المستخدمة
//   List<Widget> _buildPages() {
//     return [
//       EquipmentChipPage(
//         equipmentDetails: WorkoutEquipment,
//         selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
//         onToggle: _toggleSelection,
//       ),
//       EquipmentChipPage(
//         equipmentDetails: FlexibilityEquipment,
//         selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
//         onToggle: _toggleSelection,
//       ),
//       EquipmentChipPage(
//         equipmentDetails: IndoorEquipment,
//         selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
//         onToggle: _toggleSelection,
//       ),
//       Preview(
//         equipmentPaths: selectedEquipmentPaths,
//         getEquipmentDetails: getEquipmentDetails,
//         onDeleteEquipment: _deleteEquipmentFromPreview,
//         onReorderEquipment: _reorderEquipmentFromPreview,
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final pages = _buildPages();
//     const double navBarWidth = 340;
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           _pageTitles[_selectedIndex],
//           style: const TextStyle(fontSize: 22),
//         ),
//         toolbarHeight: 65,
//         actions: [
//           TextButton(
//             onPressed: () async {
//               // الآن نرجع القائمة الكاملة المُحدثة (old + new) بدون فلترة
//               List<Map<String, String>> selectedEquipments = [];
//               for (var assetPath in selectedEquipmentPaths) {
//                 final path = await _uploadTextFile(assetPath);
//                 if (path != null) {
//                   final details = getEquipmentDetails(assetPath);
//                   selectedEquipments.add({
//                     'assetPath': path,
//                     'title': details?['title'] ?? 'Unknown',
//                     'points': details?['points'] ?? '0',
//                     'times': details?['times'] ?? '0',
//                     'reps': details?['reps'] ?? '0',
//                   });
//                 }
//               }
//               Navigator.pop(context, selectedEquipments);
//             },
//             child: const Text(
//               'Save',
//               style: TextStyle(
//                   color: Color.fromARGB(255, 97, 96, 96),
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(width: 7),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(35),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 6, sigmaY: 20),
//                 child: Container(
//                   key: _navBarKey,
//                   width: navBarWidth,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xff888181).withOpacity(0.35),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       AnimatedPositioned(
//                         left: _tabOffsets[_selectedIndex],
//                         duration: const Duration(milliseconds: 275),
//                         curve: Curves.easeInOut,
//                         child: Container(
//                           width: max(_tabWidths[_selectedIndex], _minIndicatorWidth),
//                           height: 60,
//                           decoration: BoxDecoration(
//                             color: myColor,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildIconWithOverlay(
//                             key: _tabKeys[0],
//                             BarText: 'Workout',
//                             index: 0,
//                           ),
//                           _buildIconWithOverlay(
//                             key: _tabKeys[1],
//                             BarText: 'Flexibility',
//                             index: 1,
//                           ),
//                           _buildIconWithOverlay(
//                             key: _tabKeys[2],
//                             BarText: 'Indoor',
//                             index: 2,
//                           ),
//                           _buildIconWithOverlay(
//                             key: _tabKeys[3],
//                             BarText: 'Preview',
//                             index: 3,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               onPageChanged: (index) {
//                 setState(() {
//                   _selectedIndex = index;
//                 });
//               },
//               children: pages,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIconWithOverlay({
//     required int index,
//     required String BarText,
//     Key? key,
//   }) {
//     return TextButton(
//       key: key,
//       onPressed: () => _onItemTapped(index),
//       style: ButtonStyle(
//         overlayColor: MaterialStateProperty.all(Colors.transparent),
//       ),
//       child: Text(
//         BarText,
//         textAlign: TextAlign.center,
//         style: const TextStyle(color: Colors.white, fontSize: 13),
//       ),
//     );
//   }
// }

// /// EquipmentChipPage: تعرض شريط الـ Chips للمجموعات العضلية الرئيسية، ثم لكل مجموعة فرعية تُعرض
// /// لوحة تحتوي على عنوان المجموعة الفرعية مع سهمين: واحد لتبديل عرض الأجهزة الأساسية (main) والآخر للأجهزة الفرعية (sub).
// /// يتم التحكم في العرض باستخدام حالة toggle مُخزنة في خريطة _toggleStatus لكل مجموعة فرعية.
// /// الحالة الممكنة هي:
// /// "none" => لا يتم عرض أي قائمة (افتراضيًا)
// /// "main" => عرض قائمة الأجهزة الأساسية
// /// "sub" => عرض قائمة الأجهزة الفرعية
// class EquipmentChipPage extends StatefulWidget {
//   final Map<String, Map<String, Map<String, Map<String, Map<String, String>>>>> equipmentDetails;
//   final Set<String> selectedEquipmentPaths;
//   final Function(String) onToggle;

//   const EquipmentChipPage({
//     Key? key,
//     required this.equipmentDetails,
//     required this.selectedEquipmentPaths,
//     required this.onToggle,
//   }) : super(key: key);

//   @override
//   State<EquipmentChipPage> createState() => _EquipmentChipPageState();
// }

// class _EquipmentChipPageState extends State<EquipmentChipPage> {
//   late String _selectedMuscle;
//   // حالة toggle لكل مجموعة فرعية: "none" (افتراضي)، "main" أو "sub"
//   Map<String, String> _toggleStatus = {};

//   @override
//   void initState() {
//     super.initState();
//     _selectedMuscle = widget.equipmentDetails.keys.isNotEmpty
//         ? widget.equipmentDetails.keys.first
//         : '';
//     _initializeToggleStatus();
//   }

//   void _initializeToggleStatus() {
//     final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};
//     _toggleStatus = {
//       for (var subgroup in subgroupsMap.keys) subgroup: "none",
//     };
//   }
  
//   // تم حذف didUpdateWidget حتى لا يتم إعادة تهيئة _toggleStatus عند اختيار جهاز

//   @override
//   Widget build(BuildContext context) {
//     final muscleGroups = widget.equipmentDetails.keys.toList();
//     if (muscleGroups.isEmpty) return const Center(child: Text('لا توجد بيانات'));
//     final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};
//     final subgroupNames = subgroupsMap.keys.toList();

//     return Column(
//       children: [
//         // شريط أفقي للمجموعات العضلية الرئيسية
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           child: Row(
//             children: muscleGroups.map((muscle) {
//               final bool isActive = (muscle == _selectedMuscle);
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedMuscle = muscle;
//                     _initializeToggleStatus();
//                   });
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 5),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: isActive ? myColor : const Color(0xff8B8686),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     muscle[0].toUpperCase() + muscle.substring(1),
//                     style: const TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 12.0, top: 10),
//               child: Text(
//                 'Sub',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold, 
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 19.0, top: 10),
//               child: Text(
//                 'Main',
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold, 
//                 ),
//               ),
//             ),
//           ]
//         ),

//         // عرض كل مجموعة فرعية مع لوحة تحتوي على عنوان ومجموعتي أزرار للتحكم
//         Expanded(
//           child: ListView.builder(
//             itemCount: subgroupNames.length,
//             itemBuilder: (context, index) {
//               final subgroupName = subgroupNames[index];
//               final subgroupData = subgroupsMap[subgroupName] ?? {};
//               // من المتوقع أن يحتوي كل subgroupData على مفتاحين: "main" و "sub"
//               final mainDevices = subgroupData['main'] ?? {};
//               final subDevices = subgroupData['sub'] ?? {};
//               final toggle = _toggleStatus[subgroupName] ?? "none";
//               // حسب الحالة، نختار الأجهزة المعروضة:
//               // "none": لا تعرض أي قائمة، "main": عرض الأجهزة الأساسية، "sub": عرض قائمة الأجهزة الفرعية.
//               final Map<String, Map<String, String>> devicesMap =
//                   toggle == "main" ? mainDevices : toggle == "sub" ? subDevices : {};
//               final equipmentList = devicesMap.keys.toList();

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // لوحة العنوان مع زر لكل من main و sub
//                   Padding(
//                     padding: const EdgeInsets.only(right: 12, bottom: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // زر التحكم في قائمة الأجهزة الفرعية (sub)
//                         if (subDevices.isNotEmpty)
//                           IconButton(
//                             icon: Icon(
//                               toggle == "sub" ? Icons.arrow_drop_down : Icons.arrow_right,
//                               size: 20,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _toggleStatus[subgroupName] =
//                                     toggle == "sub" ? "none" : "sub";
//                               });
//                             },
//                           )
//                         else
//                           const SizedBox(width: 16),

//                         // عنوان المجموعة
//                         Expanded(
//                           child: Text(
//                             subgroupName,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontSize: 10, color: Colors.grey),
//                           ),
//                         ),

//                         // زر التحكم في قائمة الأجهزة الأساسية (main)
//                         if (mainDevices.isNotEmpty)
//                           IconButton(
//                             icon: Icon(
//                               toggle == "main" ? Icons.arrow_drop_down : Icons.arrow_right,
//                               size: 20,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _toggleStatus[subgroupName] =
//                                     toggle == "main" ? "none" : "main";
//                               });
//                             },
//                           )
//                         else
//                           const SizedBox(width: 16),
//                       ],
//                     ),
//                   ),
//                   const Divider(color: Colors.grey, thickness: 0.5),
//                   // قائمة الأجهزة بحسب الحالة المفتوحة
//                   if (toggle != "none")
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: equipmentList.length,
//                       itemBuilder: (context, eqIndex) {
//                         final assetPath = equipmentList[eqIndex];
//                         final details = devicesMap[assetPath];
//                         final isSelected =
//                             widget.selectedEquipmentPaths.contains(assetPath);
//                         return GestureDetector(
//                           onTap: () {
//                             widget.onToggle(assetPath);
//                             setState(() {}); // إعادة بناء الواجهة لتحديث علامة الاختيار
//                           },
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(5.5),
//                                 child: Container(
//                                   width: 300,
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xff272727).withOpacity(.5),
//                                     borderRadius: BorderRadius.circular(17),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       if (isSelected)
//                                         Container(
//                                           padding: const EdgeInsets.all(5),
//                                           color: Colors.black54,
//                                           child: const Icon(Icons.check, color: myColor),
//                                         ),
//                                       Text(
//                                         details?['title'] ?? 'Unknown',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 10.0),
//                                         child: ClipRRect(
//                                           borderRadius: BorderRadius.circular(22),
//                                           child: Image.asset
//                                           (
//                                             assetPath,
//                                             width: 80,
//                                             height: 80,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
