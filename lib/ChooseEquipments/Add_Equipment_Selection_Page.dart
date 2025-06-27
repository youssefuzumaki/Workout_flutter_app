import 'package:flutter/material.dart';
import 'package:nine_workout/ChooseEquipments/Selected_Equipments_Body.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEquipmentSelectionPage extends StatefulWidget 
{

  final String workoutId;
  final List<String>? initialEquipmentPaths;

  const AddEquipmentSelectionPage
  ({
    Key? key,
    required this.workoutId,
    this.initialEquipmentPaths,
  }) : super(key: key);

  @override
  _AddEquipmentSelectionPageState createState() =>
      _AddEquipmentSelectionPageState();
}

class _AddEquipmentSelectionPageState extends State<AddEquipmentSelectionPage> 
{
  // مفتاح للوصول لحالة SelectedEquipmentsBody
  final GlobalKey _bodyKey = GlobalKey();
  final SupabaseClient supabase = Supabase.instance.client;

  // لما المستخدم يضغط Save
  void _onSave() 
  {
    // نجيب الحالة ونستخرج المسارات المختارة
    final bodyState = _bodyKey.currentState as dynamic;
    final List<String> selectedPaths =
        (bodyState.selectedEquipmentPaths as List<String>).toList();

    // بدلاً من تحويلها لقائمة خرائط، نقوم بإرجاع القائمة النصية مباشرة
    Navigator.pop(context, selectedPaths);
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title:const Text
        (
          "Equipment Selection", 
          style: TextStyle(fontSize: 22)
        ),

        centerTitle: true,

        actions: 
        [
          TextButton
          (
            onPressed: _onSave,

            child: const Text
            (
              'Save',

              style: TextStyle
              (
                color: Color.fromARGB(255, 97, 96, 96),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 7),
          
        ],
      ),
      body: SelectedEquipmentsBody
      (
        key: _bodyKey,
        workoutId: widget.workoutId,
        supabase: supabase,
        initialEquipmentPaths: widget.initialEquipmentPaths,
      ),
    );
  }
}
