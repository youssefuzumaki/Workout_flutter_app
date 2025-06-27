// equipment_chip_page.dart

import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

/// EquipmentChipPage تعرض شريط الـ Chips للمجموعات العضلية الرئيسية،
/// ثم تعرض لكل مجموعة فرعية لوحة تحتوي على عنوان المجموعة وأزرار التبديل بين عرض الأجهزة
/// الأساسية (main) والأجهزة الفرعية (sub). تُستدعى الدالة onToggle عند الضغط على جهاز لتبديل اختياره.
class EquipmentChipPage extends StatefulWidget 
{

  final Map<String, Map<String, Map<String, Map<String, Map<String, String>>>>> equipmentDetails;
  final Set<String> selectedEquipmentPaths;
  final Function(String) onToggle;

  const EquipmentChipPage
  ({
    Key? key,
    required this.equipmentDetails,
    required this.selectedEquipmentPaths,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<EquipmentChipPage> createState() => _EquipmentChipPageState();
}

class _EquipmentChipPageState extends State<EquipmentChipPage> 
{

  late String _selectedMuscle;
  // حالة toggle لكل مجموعة فرعية: "none" (افتراضي)، "main" لعرض الأجهزة الأساسية، أو "sub" لعرض الأجهزة الفرعية.

  Map<String, String> _toggleStatus = {};

  @override
  void initState() 
  {
    super.initState();
    // تعيين أول مجموعة عضلية إذا كانت موجودة
    _selectedMuscle = widget.equipmentDetails.keys.isNotEmpty ? widget.equipmentDetails.keys.first : '';
    _initializeToggleStatus();
  }

  /// تهيئة _toggleStatus بحيث يكون لكل مجموعة فرعية القيمة الافتراضية "none".
  void _initializeToggleStatus() 
  {
    final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};
    _toggleStatus = { for (var subgroup in subgroupsMap.keys) subgroup: "none" };
  }

  @override
  Widget build(BuildContext context) 
  {

    final muscleGroups = widget.equipmentDetails.keys.toList();

    if (muscleGroups.isEmpty) return const Center(child: Text('لا توجد بيانات'));

    final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};

    final subgroupNames = subgroupsMap.keys.toList();

    return Column
    (
      children: 
      [
        // عرض شريط أفقي للمجموعات العضلية الرئيسية
        SingleChildScrollView
        (
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          child: Row
          (
            children: muscleGroups.map((muscle) 
            {

              final bool isActive = (muscle == _selectedMuscle);

              return GestureDetector
              (
                onTap: () 
                {
                  setState(() 
                  {
                    _selectedMuscle = muscle;
                    _initializeToggleStatus();
                  });
                },

                child: Container
                (

                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

                  decoration: BoxDecoration
                  (
                    color: isActive ? myColor : const Color(0xff8B8686),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text
                  (
                    muscle[0].toUpperCase() + muscle.substring(1),

                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // عرض شريط العناوين "Sub" و "Main"
        Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: 
          [
            Padding
            (
              padding: const EdgeInsets.only(left: 12.0, top: 10),

              child: Text
              (
                'Sub',

                style: TextStyle
                (
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding
            (
              padding: const EdgeInsets.only(right: 19.0, top: 10),

              child: Text
              (
                'Main',

                style: TextStyle
                (
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        // عرض قائمة الأجهزة لكل مجموعة فرعية طبقاً لحالة التبديل (toggle)
        Expanded
        (
          child: ListView.builder
          (
            itemCount: subgroupNames.length,

            itemBuilder: (context, index) 
            {
              final subgroupName = subgroupNames[index];

              final subgroupData = subgroupsMap[subgroupName] ?? {};

              // نتوقع أن يكون لكل مجموعة بيانات مفتاحين: "main" و "sub"
              final mainDevices = subgroupData['main'] ?? {};

              final subDevices = subgroupData['sub'] ?? {};

              final toggle = _toggleStatus[subgroupName] ?? "none";

              // تحديد أي قائمة يتم عرضها بناءً على حالة التبديل
              final Map<String, Map<String, String>> devicesMap =
                  toggle == "main" ? mainDevices : toggle == "sub" ? subDevices : {};

              final equipmentList = devicesMap.keys.toList();

              return Column
              (
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: 
                [
                  // لوحة العنوان مع زر لكل من التبديل بين القوائم
                  Padding
                  (
                    padding: const EdgeInsets.only(right: 12, bottom: 4),

                    child: Row
                    (
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: 
                      [
                        // زر لتبديل عرض الأجهزة الفرعية (sub)
                        if (subDevices.isNotEmpty)
                          IconButton
                          (
                            icon: Icon
                            (
                              toggle == "sub" ? Icons.arrow_drop_down : Icons.arrow_right,
                              size: 20,
                              color: Colors.grey,
                            ),

                            onPressed: () 
                            {
                              setState(() 
                              {
                                _toggleStatus[subgroupName] = toggle == "sub" ? "none" : "sub";
                              });
                            },
                          )

                        else
                          const SizedBox(width: 16),

                        // عنوان المجموعة الفرعية
                        Expanded
                        (
                          child: Text
                          (
                            subgroupName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),

                        // زر لتبديل عرض الأجهزة الأساسية (main)
                        if (mainDevices.isNotEmpty)
                          IconButton
                          (
                            icon: Icon
                            (
                              toggle == "main" ? Icons.arrow_drop_down : Icons.arrow_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                            onPressed: () 
                            {
                              setState(() 
                              {
                                _toggleStatus[subgroupName] = toggle == "main" ? "none" : "main";
                              });
                            },
                          )
                        else
                          const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  const Divider(color: Colors.grey, thickness: 0.5),
                  
                  // عرض القائمة إذا تم اختيار عرض أحد المجموعتين (main أو sub)
                  if (toggle != "none")
                    ListView.builder
                    (
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: equipmentList.length,

                      itemBuilder: (context, eqIndex) 
                      {
                        final assetPath = equipmentList[eqIndex];
                        final details = devicesMap[assetPath];
                        final isSelected = widget.selectedEquipmentPaths.contains(assetPath);

                        return GestureDetector
                        (
                          onTap: () 
                          {
                            widget.onToggle(assetPath);
                            setState(() {}); // لتحديث علامة الاختيار
                          },
                          child: Padding
                          (
                            padding: const EdgeInsets.all(5.5),

                            child: Container
                            (
                              width: 300,
                              height: 100,

                              decoration: BoxDecoration
                              (
                                color: const Color(0xff272727).withOpacity(.5),
                                borderRadius: BorderRadius.circular(17),
                              ),

                              child: Row
                              (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: 
                                [
                                  if (isSelected)
                                    Container
                                    (
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.black54,
                                      child: const Icon(Icons.check, color: myColor),
                                    ),
                                  Expanded
                                  (
                                    child: Text
                                    (
                                      details?['title'] ?? 'Unknown',

                                      style: const TextStyle
                                      (
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  Padding
                                  (
                                    padding: const EdgeInsets.only(right: 10.0),

                                    child: ClipRRect
                                    (
                                      borderRadius: BorderRadius.circular(22),
                                      child: Image.asset
                                      (
                                        assetPath,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
