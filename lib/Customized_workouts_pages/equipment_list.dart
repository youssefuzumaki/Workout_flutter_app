import 'package:flutter/material.dart';
import 'package:nine_workout/Customized_workouts_pages/equipment_item_container.dart';

class EquipmentList extends StatelessWidget 
{
  final String? workoutName;
  final List<Map<String, dynamic>> equipmentList;
  final bool isLoading;
  final bool isReorderMode;
  final String? activeLongPressedId;
  final VoidCallback onAdd;
  final Function(String) onDelete;
  final Function(String?) onToggleLongPress;
  final Function(String, int) onSetDuration;
  final Function(int, int) onReorder;
  final VoidCallback onSaveOrder;
  final VoidCallback onStartWorkout;

  const EquipmentList
  ({
    Key? key,
    this.workoutName,
    required this.equipmentList,
    required this.isLoading,
    required this.isReorderMode,
    required this.activeLongPressedId,
    required this.onAdd,
    required this.onDelete,
    required this.onToggleLongPress,
    required this.onSetDuration,
    required this.onReorder,
    required this.onSaveOrder,
    required this.onStartWorkout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        toolbarHeight: 65,
        centerTitle: true,

        title: Text(workoutName ?? 'Customized Workout'),

        actions: 
        [
          isReorderMode
              ? TextButton(onPressed: onSaveOrder, child: const Text('Save'))
              : IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
        ],
      ),
      body: Stack
      (
        children: 
        [
          if (isLoading)
            const Center(child: CircularProgressIndicator())

          else if (equipmentList.isEmpty)
            const Center(child: Text('ابدأ تمرينك بإضافة أجهزة'))

          else
            ReorderableListView
            (
              onReorder: onReorder,
              padding: const EdgeInsets.only(bottom: 80),

              children: 
              [
                for (int i = 0; i < equipmentList.length; i++)
                  EquipmentItemContainer
                  (

                    key: ValueKey(equipmentList[i]['id']),

                    index: i,

                    equipment: equipmentList[i],

                    details: equipmentList[i]['details'] as Map<String, String>?,

                    duration: (equipmentList[i]['duration'] as int?) ?? 30,

                    isLongPressed:
                        activeLongPressedId == equipmentList[i]['id'],

                    onLongPress: () =>
                        onToggleLongPress(equipmentList[i]['id'] as String),

                    onDelete: () =>
                        onDelete(equipmentList[i]['id'] as String),

                    onTap: () 
                    {
                      if (activeLongPressedId != null) 
                      {
                        onToggleLongPress(null);
                        return;
                      }
                      Navigator.pushNamed
                      (
                        context,
                        '/details',
                        arguments: equipmentList[i],
                      );
                    },
                    onSetDuration: (sec) =>
                        onSetDuration(equipmentList[i]['id'] as String, sec),
                  ),
              ],
            ),
          if (!isLoading && equipmentList.isNotEmpty)
            Positioned
            (
              bottom: 20,
              left: 0,
              right: 0,
              child: Center
              (
                child: ElevatedButton
                (
                  onPressed: onStartWorkout,
                  child: const Text('Play'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
