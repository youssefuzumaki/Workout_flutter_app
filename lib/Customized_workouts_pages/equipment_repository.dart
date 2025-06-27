import 'package:supabase_flutter/supabase_flutter.dart';

class EquipmentRepository 
{
  final _supabase = Supabase.instance.client;

  /// جلب اسم التمرين
  Future<String?> fetchWorkoutName(String id) async 
  {
    final res = await _supabase
        .from('workouts')
        .select('name')
        .eq('id', id);
    if (res is List && res.isNotEmpty) 
    {
      return res[0]['name'] as String;
    }
    return null;
  }

  /// جلب قائمة الأجهزة المرتبطة بالتمرين
  Future<List<Map<String, dynamic>>> fetchEquipment(String workoutId) async 
  {
    final res = await _supabase
        .from('equipments')
        .select()
        .eq('workout_id', workoutId);
    return List<Map<String, dynamic>>.from(res as List);
  }

  /// حذف كل الأجهزة ثم إعادة إدخال القائمة الجديدة (للإضافة أو لحفظ الترتيب)
  Future<void> replaceEquipment(String workoutId, List<String> paths) async 
  {
    await _supabase
        .from('equipments')
        .delete()
        .eq('workout_id', workoutId);

    for (final path in paths) 
    {
      await _supabase.from('equipments').insert
      ({
        'name': path,
        'workout_id': workoutId,
        'muscle_group': 'custom',
      });
    }
  }

  /// حذف جهاز واحد حسب المعرف
  Future<void> deleteEquipment(String id) async 
  {
    await _supabase
        .from('equipments')
        .delete()
        .eq('id', id);
  }
}
