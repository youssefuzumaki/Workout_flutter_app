// lib/screens/preview_screen.dart

import 'package:flutter/material.dart';
import 'package:nine_workout/ChooseEquipments/preview_equipment_item.dart';


class PreviewBody extends StatefulWidget 
{
  final List<String> equipmentPaths;
  final Map<String, String>? Function(String) getEquipmentDetails;
  final Function(String) onDeleteEquipment;
  final Function(List<String>) onReorderEquipment;

  const PreviewBody
  ({
    Key? key,
    required this.equipmentPaths,
    required this.getEquipmentDetails,
    required this.onDeleteEquipment,
    required this.onReorderEquipment,
  }) : super(key: key);

  @override
  _PreviewBodyState createState() => _PreviewBodyState();
}

class _PreviewBodyState extends State<PreviewBody> 
{
  late List<String> _localEquipmentPaths;

  @override
  void initState() 
  {
    super.initState();
    _localEquipmentPaths = List.from(widget.equipmentPaths);
  }

  @override
  void didUpdateWidget(covariant PreviewBody oldWidget) 
  {
    super.didUpdateWidget(oldWidget);
    if (widget.equipmentPaths.toString() != _localEquipmentPaths.toString()) 
    {
      _localEquipmentPaths = List.from(widget.equipmentPaths);
    }
  }

  List<Map<String, dynamic>> get _equipmentList 
  {
    return _localEquipmentPaths.map((assetPath) 
    {
      final details = widget.getEquipmentDetails(assetPath);

      return 
      {
        'id': assetPath,
        'assetPath': assetPath,
        'title': details?['title'] ?? 'Unknown',
        'reps': details?['reps'] ?? '0',
        'times': details?['times'] ?? '0',
        'points': details?['points'] ?? '0',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) 
  {
    final list = _equipmentList;

    return Scaffold
    (
      appBar: AppBar(title: const Text("Preview")),

      body: list.isEmpty
          ? const Center(child: Text("لا يوجد أجهزة مضافة"))
          : ReorderableListView
          (
              padding: const EdgeInsets.only(bottom: 20),

              onReorder: (oldIndex, newIndex) 
              {
                setState(() 
                {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _localEquipmentPaths.removeAt(oldIndex);
                  _localEquipmentPaths.insert(newIndex, item);
                  widget.onReorderEquipment(List.from(_localEquipmentPaths));
                });
              },
              children: 
              [
                for (var i = 0; i < list.length; i++)
                  PreviewEquipmentItem
                  (
                    key: ValueKey(list[i]['id']),
                    index: i,
                    equipment: list[i],
                    onDelete: () 
                    {
                      setState(() 
                      {
                        _localEquipmentPaths.remove(list[i]['assetPath']);
                      });
                      widget.onDeleteEquipment(list[i]['assetPath']);
                    },
                  ),
              ],
            ),
    );
  }
}
