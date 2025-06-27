// selected_equipments_body.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nine_workout/ChooseEquipments/Custom_Nav_Bar.dart';
import 'package:nine_workout/ChooseEquipments/Preview_Body.dart';
import 'package:nine_workout/DataFolder/FlexibilityEquipment.dart';
import 'package:nine_workout/DataFolder/IndoorEquipment.dart';
import 'package:nine_workout/DataFolder/WorkoutEquipment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'equipment_chip_page.dart';

class SelectedEquipmentsBody extends StatefulWidget 
{
  // تمرير الـ workoutId والـ SupabaseClient ومجموعة المسارات الأولية للأجهزة إن وُجدت
  final String workoutId;
  final SupabaseClient supabase;
  final List<String>? initialEquipmentPaths;

  const SelectedEquipmentsBody
  ({
    Key? key,
    required this.workoutId,
    required this.supabase,
    this.initialEquipmentPaths,
  }) : super(key: key);

  @override
  _SelectedEquipmentsBodyState createState() => _SelectedEquipmentsBodyState();
}

class _SelectedEquipmentsBodyState extends State<SelectedEquipmentsBody> 
{
  // مؤشر الصفحة الحالي لشريط التنقل
  int _selectedIndex = 0;
  // عناوين الصفحات التي ستظهر في شريط التنقل العلوي
  final List<String> _pageTitles = ['Workout', 'Flexibility', 'Indoor', 'Preview'];
  // تخزين مسارات الأجهزة المختارة
  final List<String> selectedEquipmentPaths = [];
   
    // PageController للتحكم في التنقل بين الصفحات داخل PageView

  late final PageController _pageController;

  @override
  void initState() 
  {
    super.initState();
    // في حال وُجدت مسارات أجهزة مُختارة مسبقًا، نضيفها للمجموعة
    if (widget.initialEquipmentPaths != null && selectedEquipmentPaths.isEmpty) 
    {
      selectedEquipmentPaths.addAll(widget.initialEquipmentPaths!);
    }
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() 
  {
    _pageController.dispose();
    super.dispose();
  }

  // دالة لتبديل اختيار الجهاز بحسب assetPath
  void _toggleSelection(String assetPath) 
  {
    setState(() 
    {
      if (selectedEquipmentPaths.contains(assetPath)) 
      {
        selectedEquipmentPaths.remove(assetPath);
      } 
      else 
      {
        selectedEquipmentPaths.add(assetPath);
      }
    });
  }

  // دالة رفع الملف عبر Supabase (لم تتغير الدالة كما كانت)
  Future<String?> _uploadTextFile(String assetPath) async 
  {
    try 
    {
      final user = widget.supabase.auth.currentUser;

      if (user == null) return null;

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}.txt';

      final storagePath = '${user.id}/workouts/${widget.workoutId}/$fileName';

      final bytes = Uint8List.fromList(utf8.encode(assetPath));

      final response = await widget.supabase.storage
          .from('user-data')
          .uploadBinary(storagePath, bytes);

      if (response != null) 
      {
        return assetPath;
      } 
      else 
      {
        return null;
      }
    } catch (e) 
    {
      debugPrint('Error uploading text file: $e');
      return null;
    }
  }

  // دالة البحث عن تفاصيل الجهاز ضمن الخرائط الثلاث (workout, flexibility, indoor)
  Map<String, String>? getEquipmentDetails(String assetPath) 
  {
    for (final muscle in WorkoutEquipment.keys) 
    {
      final subgroups = WorkoutEquipment[muscle];

      if (subgroups != null) 
      {
        for (final subgroup in subgroups.keys) 
        {
          final categoryMap = subgroups[subgroup];
          
          if (categoryMap != null) 
          {
            for (final type in categoryMap.keys) 
            {
              final equipmentMap = categoryMap[type];

              if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
              {
                return equipmentMap[assetPath];
              }
            }
          }
        }
      }
    }
    for (final muscle in FlexibilityEquipment.keys) 
    {
      final subgroups = FlexibilityEquipment[muscle];

      if (subgroups != null) 
      {
        for (final subgroup in subgroups.keys) 
        {
          final categoryMap = subgroups[subgroup];

          if (categoryMap != null) 
          {
            for (final type in categoryMap.keys) 
            {
              final equipmentMap = categoryMap[type];

              if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
              {
                return equipmentMap[assetPath];
              }
            }
          }
        }
      }
    }

    for (final muscle in IndoorEquipment.keys) 
    {
      final subgroups = IndoorEquipment[muscle];

      if (subgroups != null) 
      {
        for (final subgroup in subgroups.keys) 
        {
          final categoryMap = subgroups[subgroup];

          if (categoryMap != null) 
          {
            for (final type in categoryMap.keys) 
            {
              final equipmentMap = categoryMap[type];

              if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
              {
                return equipmentMap[assetPath];
              }
            }
          }
        }
      }
    }
    return null;
  }

  // دالة تغيير الصفحة عند الضغط على زر في شريط التنقل navigation bar
  void _onItemTapped(int index) 
  {
    setState(() 
    {
      _selectedIndex = index;
    });

    _pageController.animateToPage
    (
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // دالة حذف جهاز من صفحة Preview
  void _deleteEquipmentFromPreview(String assetPath) 
  {
    setState(() {
      selectedEquipmentPaths.remove(assetPath);
    });
  }

  // دالة إعادة ترتيب الأجهزة من صفحة Preview
  void _reorderEquipmentFromPreview(List<String> newOrder) 
  {
    setState(() 
    {
      selectedEquipmentPaths
        ..clear()
        ..addAll(newOrder);
    });
  }

  // بناء صفحات الـ Tab (EquipmentChipPage لكل نوع وصفحة Preview)
  List<Widget> _buildPages() 
  {
    return 
    [
      EquipmentChipPage
      (
        equipmentDetails: WorkoutEquipment,
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
        onToggle: _toggleSelection,
      ),
      EquipmentChipPage
      (
        equipmentDetails: FlexibilityEquipment,
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
        onToggle: _toggleSelection,
      ),
      EquipmentChipPage
      (
        equipmentDetails: IndoorEquipment,
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
        onToggle: _toggleSelection,
      ),
      PreviewBody
      (
        equipmentPaths: selectedEquipmentPaths,
        getEquipmentDetails: getEquipmentDetails,
        onDeleteEquipment: _deleteEquipmentFromPreview,
        onReorderEquipment: _reorderEquipmentFromPreview,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) 
  {
    final pages = _buildPages();

    return Column
    (
      children: 
      [
        // شريط التنقل العلوي باستخدام CustomNavBar
        Padding
        (
          padding: const EdgeInsets.symmetric(vertical: 10),

          child: CustomNavBar
          (
            selectedIndex: _selectedIndex,
            titles: _pageTitles,
            onItemTapped: _onItemTapped,
          ),
        ),
        // عرض الـ TabView
        Expanded
        (
          child: PageView
          (
            controller: _pageController,
            onPageChanged: (index) 
            {
              setState(() 
              {
                _selectedIndex = index;
              });
            },
            
            children: pages,
          ),
        ),
      ],
    );
  }
}
