import 'package:flutter/material.dart';
import 'package:nine_workout/ChooseEquipments/Add_Equipment_Selection_Page.dart';
import 'package:nine_workout/Customized_workouts_pages/equipment_list.dart';
import 'package:nine_workout/Customized_workouts_pages/equipment_repository.dart';
import 'package:nine_workout/DataFolder/FlexibilityEquipment.dart';
import 'package:nine_workout/DataFolder/IndoorEquipment.dart';
import 'package:nine_workout/DataFolder/WorkoutEquipment.dart';
import 'package:nine_workout/PlayPages/PlayPageBody.dart';

class CustomizedWorkoutPage extends StatefulWidget 
{
  final String workoutId;

  const CustomizedWorkoutPage({Key? key, required this.workoutId})
      : super(key: key);

  @override
  _CustomizedWorkoutPageState createState() => _CustomizedWorkoutPageState();
}

class _CustomizedWorkoutPageState extends State<CustomizedWorkoutPage> 
{

  final _repo = EquipmentRepository();
  List<Map<String, dynamic>> _equipmentList = [];
  bool _isLoading = false;
  String? _workoutName;
  String? _activeLongPressedId;
  bool _isReorderMode = false;

  @override
  void initState() 
  {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async 
  {

    setState(() => _isLoading = true);
    _workoutName = await _repo.fetchWorkoutName(widget.workoutId);

    // جلب البيانات الخام من المستودع وتحديثها بالتفاصيل والمدة الافتراضية (30 ثانية)
    final rawList = await _repo.fetchEquipment(widget.workoutId);

    _equipmentList = rawList.map((e) 
    {
      final path = e['name'] as String;
      Map<String, String>? getDetails(String assetPath) 
      {
        // البحث في بيانات WorkoutEquipment
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

        // البحث في بيانات FlexibilityEquipment
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
        // البحث في بيانات IndoorEquipment
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

      // تعيين مدة افتراضية (30 ثانية) إذا لم تكن موجودة أو غير صحيحة
      final rawDur = e['duration'];

      final dur = rawDur is int ? rawDur : 30;

      return 
      {
        ...e,
        'details': getDetails(path),
        'duration': dur,
      };
    }).toList();

    setState(() => _isLoading = false);
  }

  Future<void> _addEquipment() async 
  {
    final List<String>? newPaths = await Navigator.push<List<String>>
    (

      context,

      MaterialPageRoute
      (
        builder: (_) => AddEquipmentSelectionPage
        (
          workoutId: widget.workoutId,

          initialEquipmentPaths:
              _equipmentList.map((e) => e['name'] as String).toList(),
        ),
      ),
    );
    if (newPaths != null) 
    {

      await _repo.replaceEquipment(widget.workoutId, newPaths);

      await _loadData();

      ScaffoldMessenger.of(context).showSnackBar
      (
        const SnackBar(content: Text('تم تحديث الأجهزة بنجاح')),
      );
    }
  }

  Future<void> _deleteEquipment(String id) async 
  {
    await _repo.deleteEquipment(id);

    setState(() 
    {
      _equipmentList.removeWhere((e) => e['id'] == id);
      if (_activeLongPressedId == id) _activeLongPressedId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar
    (
      const SnackBar(content: Text('تم حذف الجهاز بنجاح')),
    );
  }

  void _toggleLongPress(String? id) 
  {
    setState(() => _activeLongPressedId =
        _activeLongPressedId == id ? null : id);
  }

  void _setDuration(String id, int sec) 
  {
    setState(() 
    {
      final idx = _equipmentList.indexWhere((e) => e['id'] == id);

      if (idx != -1) _equipmentList[idx]['duration'] = sec;
    });
  }

  void _onReorder(int oldIndex, int newIndex) 
  {
    setState(() 
    {
      if (newIndex > oldIndex) newIndex--;

      final item = _equipmentList.removeAt(oldIndex);

      _equipmentList.insert(newIndex, item);

      _isReorderMode = true;
    });
  }

  Future<void> _saveOrder() async 
  {
    await _repo.replaceEquipment
    (
      widget.workoutId,

      _equipmentList.map((e) => e['name'] as String).toList(),
    );

    setState(() => _isReorderMode = false);

    ScaffoldMessenger.of(context).showSnackBar
    (
      const SnackBar(content: Text('تم حفظ الترتيب الجديد')),
    );
  }

  void _startWorkout() 
  {
    final exercises = _equipmentList.map((e) 
    {
      return 
      {
        ...e,
        'assetPath': e['name'],
        'title': (e['details'] as Map?)?['title'] ?? 'Unknown',
        'points': (e['details'] as Map?)?['points'] ?? '0',
        'times': (e['details'] as Map?)?['times'] ?? '0',
        'reps': (e['details'] as Map?)?['reps'] ?? '0',
      };
    }).toList();

    Navigator.push
    (
      context,
      MaterialPageRoute
      (
        builder: (_) => PlayPageBody(exercises: exercises),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return EquipmentList
    (
      workoutName: _workoutName,
      equipmentList: _equipmentList,
      isLoading: _isLoading,
      isReorderMode: _isReorderMode,
      activeLongPressedId: _activeLongPressedId,
      onAdd: _addEquipment,
      onDelete: _deleteEquipment,
      onToggleLongPress: _toggleLongPress,
      onSetDuration: _setDuration,
      onReorder: _onReorder,
      onSaveOrder: _saveOrder,
      onStartWorkout: _startWorkout,
    );
  }
}
