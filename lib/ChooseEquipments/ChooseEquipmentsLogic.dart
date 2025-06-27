// choose_equipments_logic.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

class ChooseEquipmentsLogic 
{
  /// القائمة التي تحوي مسارات الأجهزة المختارة.
  final List<String> selectedEquipmentPaths = [];

  /// دالة تبديل اختيار الجهاز بناءً على الـ assetPath.
  /// إذا كان الجهاز مختاراً يتم إزالته، وإذا لم يكن مختاراً يتم إضافته.
  void toggleSelection(String assetPath) 
  {
    if (selectedEquipmentPaths.contains(assetPath)) 
    {
      selectedEquipmentPaths.remove(assetPath);
    } else 
    {
      selectedEquipmentPaths.add(assetPath);
    }
  }

  /// دالة رفع ملف نصي إلى Supabase.
  /// تأخذ الـ assetPath ومعلمات الـ Supabase الضرورية (client و workoutId).
  /// تُرجع الـ assetPath في حال نجاح الرفع أو null في حال فشل العملية.
  Future<String?> uploadTextFile
  (
    String assetPath, 
    {
    required SupabaseClient client,
    required String workoutId,
  }) async 
  {
    try 
    {
      final user = client.auth.currentUser;
      if (user == null) return null;

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}.txt';

      final storagePath = '${user.id}/workouts/$workoutId/$fileName';

      final bytes = Uint8List.fromList(utf8.encode(assetPath));

      final response = await client.storage
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
      print('Error uploading text file: $e');
      return null;
    }
  }

  /// دالة البحث عن تفاصيل الجهاز داخل خرائط الأجهزة.
  /// يجب تمرير الخرائط الخاصة بكل نوع (workout، flexibility، indoor) كمعاملات.
Map<String, String>? getEquipmentDetails
(
  String assetPath, 
  {
  required Map<String, Map<String, Map<String, Map<String, Map<String, String>>>>>workoutEquipment,
  required Map<String, Map<String, Map<String, Map<String, String>>>> flexibilityEquipment,
  required Map<String, Map<String, Map<String, Map<String, String>>>> indoorEquipment,
}) 
{
  // البحث في قائمة WorkoutEquipment
  for (final muscle in workoutEquipment.keys) 
  {

    final subgroups = workoutEquipment[muscle];

    if (subgroups != null) 
    {
      for (final subgroup in subgroups.keys) 
      {

        final categoryMap = subgroups[subgroup];

        if (categoryMap != null) 
        {
          for (final type in categoryMap.keys) 
          {

            final equipmentMap = categoryMap[type]; // يجب أن يكون نوعه Map<String, Map<String, String>>

            if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
            {
              // هنا نقوم بـ cast للتأكيد أن القيمة من نوع Map<String, String>
              return equipmentMap[assetPath] as Map<String, String>?;
            }
          }
        }
      }
    }
  }

  // البحث في قائمة FlexibilityEquipment
  for (final muscle in flexibilityEquipment.keys) 
  {
    final subgroups = flexibilityEquipment[muscle];

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
              return equipmentMap[assetPath] as Map<String, String>?;
            }
          }
        }
      }
    }
  }

  // البحث في قائمة IndoorEquipment
  for (final muscle in indoorEquipment.keys) 
  {
    final subgroups = indoorEquipment[muscle];

    if (subgroups != null) 
    {
      for (final subgroup in subgroups.keys) 
      {

        final categoryMap = subgroups[subgroup];

        if (categoryMap != null) 
        {
          for (final type in categoryMap.keys) {

            final equipmentMap = categoryMap[type];

            if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
            {
              return equipmentMap[assetPath] as Map<String, String>?;
            }
          }
        }
      }
    }
  }
  return null;
}


  /// دالة لحذف جهاز من القائمة.
  void deleteEquipment(String assetPath) 
  {
    selectedEquipmentPaths.remove(assetPath);
  }

  /// دالة لإعادة ترتيب الأجهزة في القائمة بناءً على القائمة الجديدة.
  void reorderEquipment(List<String> newOrder) 
  {
    selectedEquipmentPaths
      ..clear()
      ..addAll(newOrder);
  }
}
