// equipment_chip_page.dart


//---------------------------------------EquipmentChipPage------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

/// EquipmentChipPage تعرض شريط الـ Chips للمجموعات العضلية الرئيسية،
/// ثم تعرض لكل مجموعة فرعية لوحة تحتوي على عنوان المجموعة وأزرار التبديل بين عرض الأجهزة
/// الأساسية (main) والأجهزة الفرعية (sub). تُستدعى الدالة onToggle عند الضغط على جهاز لتبديل اختياره.
class EquipmentChipPage extends StatefulWidget 
{

  final Map<String, Map<String, Map<String, Map<String, Map<String, String>>>>> equipmentDetails;  //تُستخدم كلمة final لتحديد أن المتغير الذي يتم إعلانُه لن يُعاد تعيينه بعد تهيئته لأول مرة.
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
  //هنا تم تعريف المتغير اول مره لكن بعد كده final دي معناها ان المتغير ده الي هيتم اعلانه اول مره  مش هيتم اعادة تهيئته تاني 
  late String _selectedMuscle;
  // حالة toggle لكل مجموعة فرعية: "none" (افتراضي)، "main" لعرض الأجهزة الأساسية، أو "sub" لعرض الأجهزة الفرعية.

  Map<String, String> _toggleStatus = {};

  @override
  void initState()        // دالة initState تُستدعى عند إنشاء الـ Widget لأول مرة وتقوم بتهيئة الحالة الأساسية.

  {
    super.initState();    // استدعاء التهيئة الأساسية من الـ State الأصلي.

    // يتم فحص ما إذا كانت بيانات equipmentDetails تحتوي على أي مفاتيح (أي وجود مجموعة عضلية).
    // في مثال بياناتنا، توجد مجموعة عضلية مثل "Back".
    // إذا كانت البيانات غير فارغة، يتم تعيين _selectedMuscle إلى أول مفتاح، 
    // أي سيتم تعيين _selectedMuscle = 'Back' (حسب ترتيب المفاتيح في Map).

    _selectedMuscle = widget.equipmentDetails.keys.isNotEmpty ? widget.equipmentDetails.keys.first : '';     


    // بعد تعيين المجموعة العضلية المختارة، نقوم بتهيئة حالة التبديل لكل مجموعة فرعية داخل هذه المجموعة.                 
    _initializeToggleStatus();  //تبديل الحالة ToggleStatus
  }

  

/// دالة _initializeToggleStatus تقوم بإعداد خريطة الحالة (_toggleStatus)
/// بحيث لكل مجموعة فرعية داخل _selectedMuscle (مثلاً، داخل "Back" يوجد قسمان فرعيان: 
/// "Back" و "Erector Spinae") تكون الحالة الافتراضية هي "none"
/// مما يعني أنه لا يتم عرض أي قائمة (لا "main" ولا "sub") عند بدء التطبيق.
  void _initializeToggleStatus() 
  {
  // استخراج بيانات المجموعات الفرعية للمجموعة العضلية المختارة.
  // على سبيل المثال، إذا كان _selectedMuscle = 'Back'، فإن subgroupsMap ستحصل على البيانات التالية:
  // {
  //   'Back': { ... بيانات الأجهزة لقسم "main" و "sub" ... },
  //   'Erector Spinae': { ... بيانات الأجهزة لقسم "main" و "sub" ... }
  // }
  // إذا كانت البيانات غير موجودة، نستخدم {} كقيمة افتراضية.
    final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};   //else رجع قائمة فارغه بس المهم ميحصلشي ايرور   
    //تُستخدم كلمة final لتحديد أن المتغير الذي يتم إعلانُه لن يُعاد تعيينه بعد تهيئته لأول مرة.

  // إنشاء خريطة _toggleStatus بحيث يتم تعيين قيمة "none" لكل مفتاح (أي لكل مجموعة فرعية).
  // باستخدام بناء الجملة (for in)، نقوم بتعيين كل مجموعة فرعية مثل "Back" أو "Erector Spinae" إلى "none".
  // هذا يعني أنه عند بدء التطبيق، لن يتم عرض القائمة الخاصة بأي من هذين القسمين تلقائيًا.

    _toggleStatus = { for (var subgroup in subgroupsMap.keys) subgroup: "none" }; // الوضع الافتراضي بتاع القائمتين انهم مقفولين 
  }

  @override
  Widget build(BuildContext context) 
  {
    //تُستخدم كلمة final لتحديد أن المتغير الذي يتم إعلانُه لن يُعاد تعيينه بعد تهيئته لأول مرة.
    // تحويل مفاتيح الخريطة (Map) equipmentDetails إلى قائمة وتخزينها في المتغير muscleGroups.
    // 'final' هنا تعني أن قيمة المتغير لا يمكن إعادة تعيينها بعد تهيئتها.
    // نوع المتغير muscleGroups هنا هو List<String> لأن المفاتيح في الخريطة تمثل أسماء المجموعات العضلية كسلاسل نصية.
    final muscleGroups = widget.equipmentDetails.keys.toList();
  
    // هنا نقوم بفحص ما إذا كانت قائمة المجموعات العضلية muscleGroups فارغة.
    // إذا كانت القائمة فارغة، نعيد عنصر Center يحتوي على Text يعرض رسالة "لا توجد بيانات".
    // هذا يمنع محاولة عرض بيانات غير موجودة ويعرض رسالة مناسبة للمستخدم.
    if (muscleGroups.isEmpty) return const Center(child: Text('لا توجد بيانات'));
    
    // استخراج الخريطة الفرعية (Map) للمجموعات الفرعية التي تتبع المجموعة العضلية المحددة _selectedMuscle.
    // إذا لم توجد بيانات للمجموعة المختارة، يتم استخدام {} (خريطة فارغة) كقيمة افتراضية باستخدام عامل ??.
    final subgroupsMap = widget.equipmentDetails[_selectedMuscle] ?? {};
 
    // تحويل مفاتيح الخريطة الفرعية (المجموعات الفرعية) إلى قائمة وتخزينها في المتغير subgroupNames.
    // نوع المتغير subgroupNames هو List<String> لأن المفاتيح تمثل أسماء المجموعات الفرعية كسلاسل نصية.
    final subgroupNames = subgroupsMap.keys.toList();

    return Column
    (
      children: 
      [
        // عرض شريط أفقي للمجموعات العضلية الرئيسية
        // إنشاء ScrollView أفقي لعرض المجموعات العضلية في شريط قابل للتمرير
        SingleChildScrollView
        (
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          child: Row
          (
            // يتم تحويل قائمة muscleGroups إلى مجموعة من Widgets باستخدام الدالة map
            // ثم يتم تحويلها مرة أخرى إلى قائمة باستخدام toList()
            children: muscleGroups.map((muscle) 
            {

              // تعريف متغير isActive من نوع bool ليحدد ما إذا كانت المجموعة الحالية مساوية للمجموعة المختارة (_selectedMuscle)
              final bool isActive = (muscle == _selectedMuscle);

              return GestureDetector
              (
                onTap: () 
                {
                  setState(() 
                  { 
                   // تعيين المجموعة العضلية المختارة (مثلاً "Back") إلى المتغير _selectedMuscle
                    _selectedMuscle = muscle;
                   // إعادة تهيئة حالات التبديل للمجموعات الفرعية تبعاً للمجموعة العضلية المختارة
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
                    // تحويل أول حرف من اسم المجموعة إلى حرف كبير باستخدام toUpperCase،
                    // ثم إضافة باقي الاسم باستخدام substring(1)
                    muscle[0].toUpperCase() + muscle.substring(1),

                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }).toList(),//muscleGroups.map((muscle)  هنحولها بقي الي list 
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
        // Expanded يسمح للعنصر بأن يشغل المساحة المتاحة داخل الـ Column أو الـ Row.
        // هنا Expanded يجعل ListView.builder يمتد ليشغل باقي المساحة المتوفرة في الواجهة.
        Expanded
        (
          // ListView.builder يقوم بإنشاء قائمة ديناميكية بناءً على عدد العناصر.
          // هنا يتم استخدامه لعرض بيانات كل مجموعة فرعية.
          child: ListView.builder
          (
            //عدد العناصر الي هيتم انشائها في ال ليست  هيكون بعدد اسماء ال
            // يعني من الاخر من عددد الاجهزة الي انا حاططها في البينات  هنا يتم استخراجه من طول قائمة أسماء المجموعات الفرعية التي تم الحصول عليها مسبقًا.
            itemCount: subgroupNames.length,

            // itemBuilder هو دالة تُبنى لكل عنصر في القائمة.
            // تستقبل السياق (context) وفهرس العنصر (index).
            itemBuilder: (context, index) 
            {
              // استخراج اسم المجموعة الفرعية بناءً على الفهرس.
              // على سبيل المثال، إذا كانت subgroupNames تحتوي على ['Back', 'Erector Spinae']،
              // عند index = 0 يكون subgroupName = 'Back'.
              final subgroupName = subgroupNames[index];

              // استخراج بيانات المجموعة الفرعية من الخريطة subgroupsMap باستخدام اسم المجموعة الفرعية.
              final subgroupData = subgroupsMap[subgroupName] ?? {};  //لو كانت فارغه طبعا رجع ده المهم ميحصلشي مشكله 

              
              // نفترض أن كل مجموعة فرعية تحتوي على بيانات بمفتاحين: "main" و "sub".
              // استخراج بيانات الأجهزة الأساسية (main Equipment) من المجموعة الفرعية.
              final mainEquipment = subgroupData['main'] ?? {};

              final subEquipment = subgroupData['sub'] ?? {};
              
              // الحصول على حالة التبديل الحالية لهذه المجموعة الفرعية من خريطة _toggleStatus.
              // إذا لم يكن هناك قيمة محددة، يتم استخدام القيمة الافتراضية "none". 
              final toggle = _toggleStatus[subgroupName] ?? "none";

             // بناءً على قيمة toggle، نقوم بتحديد أي من القائمتين سيتم عرضها.
             // إذا كانت toggle تساوي "main" نستخدم mainEquipment.
             // إذا كانت toggle تساوي "sub" نستخدم subEquipment.
             // وإلا يتم استخدام خريطة فارغة.
             // النوع هنا هو Map<String, Map<String, String>> // مثلا وليكن Erector Spinae وتحتها ,main و sub
             // حيث المفتاح هو مسار الجهاز والقيمة هي خريطة تحتوي على تفاصيل الجهاز مثل العنوان والنقاط.
              final Map<String, Map<String, String>> EquipmentsMap =
                  toggle == "main" ? mainEquipment : toggle == "sub" ? subEquipment : {};
              
             // تحويل مفاتيح EquipmentsMap (مسارات الأجهزة) إلى قائمة حتى يمكن استخدامها في التكرار لاحقًا.
              final equipmentList = EquipmentsMap.keys.toList();

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
                        if (subEquipment.isNotEmpty)
                          IconButton
                          (
                            icon: Icon
                            (
                              toggle == "sub" ? Icons.arrow_drop_down : Icons.arrow_right,
                              size: 20,
                              color: Colors.grey,
                            ),
                            
                            // عند الضغط على الزر، يتم استدعاء دالة onPressed.
                            onPressed: () 
                            {
                              setState(() 
                              {
                                 // تعديل حالة التبديل _toggleStatus للمجموعة الفرعية.
                                 // إذا كانت الحالة "sub" حاليًا يتم تغييرها إلى "none" (أي إخفاء القائمة)،
                                 // وإلا يتم تعيينها إلى "sub" (أي عرض قائمة الأجهزة الفرعية).
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
                        if (mainEquipment.isNotEmpty)
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
                                // تعديل حالة التبديل للمجموعة الفرعية:
                                // إذا كانت الحالة "main" يتم تحويلها إلى "none" (أي إخفاء القائمة)،
                                // وإلا يتم تعيينها إلى "main" (أي عرض قائمة الأجهزة الأساسية).
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
                  
                  // شرط للتأكد من أن حالة التبديل (toggle) ليست "none"؛
                  // بمعنى أنه إذا كان المستخدم قد اختار عرض أحد القوائم (سواء "main" أو "sub"),
                  // سيتم بناء الـ ListView.builder لعرض قائمة الأجهزة.
                  // إذا كانت toggle "none"، فلن يتم عرض القائمة.
                  // عرض القائمة إذا تم اختيار عرض أحد المجموعتين (main أو sub)
                  if (toggle != "none")
                    ListView.builder
                    (
                      shrinkWrap: true,

                      // تعيين خاصية physics إلى NeverScrollableScrollPhysics() يعني أن الـ ListView
                      // لن يكون له خاصية التمرير (Scroll) لأنه من المفترض أن يكون جزءاً من قائمة أكبر أو داخل شاشة ثابتة.
                      physics: const NeverScrollableScrollPhysics(),
                     
                      itemCount: equipmentList.length,

                      
                      // itemBuilder: دالة لبناء كل عنصر في القائمة. تأخذ المتغير context وفهرس العنصر eqIndex.
                      itemBuilder: (context, eqIndex) 
                      {
                        // استخراج مسار الجهاز (assetPath) من equipmentList باستخدام الفهرس.
                        // على سبيل المثال، قد يكون assetPath مثل "Gifs/Back/main/main_Workout/Assisted-Pull-up.gif".
                        final assetPath = equipmentList[eqIndex];
                        
                        // الحصول على تفاصيل الجهاز من خريطة EquipmentsMap باستخدام assetPath.
                        // تُعاد تفاصيل الجهاز على شكل خريطة تحوي معلومات مثل العنوان، النقاط، التكرارات، إلخ.
                        final details = EquipmentsMap[assetPath];
                        
                        // التحقق مما إذا كان assetPath موجودًا في مجموعة الأجهزة المختارة (selectedEquipmentPaths)
                        // التي تم تمريرها عبر الـ Widget الأم؛ إذا كانت موجودة، يكون الجهاز مختاراً.
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


//---------------------------------------------SelectedEquipmentsBody------------------------------------------------


// selected_equipments_body.dart

import 'dart:convert'; // استيراد مكتبة dart:convert للتعامل مع الترميز (encoding) وتحويل النصوص إلى بايتات
import 'dart:typed_data'; // استيراد مكتبة dart:typed_data للتعامل مع البيانات الثنائية (bytes) باستخدام Uint8List

import 'package:flutter/material.dart'; // استيراد مكتبة Flutter الأساسية لبناء الواجهات (widgets)
import 'package:nine_workout/ChooseEquipments/Custom_Nav_Bar.dart'; // استيراد شريط التنقل المخصص من مشروع التطبيق
import 'package:nine_workout/ChooseEquipments/Preview_Body.dart'; // استيراد صفحة المعاينة التي تعرض الأجهزة المختارة للمستخدم
import 'package:nine_workout/DataFolder/FlexibilityEquipment.dart'; // استيراد بيانات أجهزة تمارين المرونة
import 'package:nine_workout/DataFolder/IndoorEquipment.dart'; // استيراد بيانات الأجهزة الداخلية
import 'package:nine_workout/DataFolder/WorkoutEquipment.dart'; // استيراد بيانات التمرينات الأساسية
import 'package:supabase_flutter/supabase_flutter.dart'; // استيراد مكتبة Supabase للتعامل مع قاعدة البيانات والتخزين على الإنترنت

import 'equipment_chip_page.dart'; // استيراد صفحة EquipmentChipPage التي تعرض الأجهزة على شكل شرائح (chips)

class SelectedEquipmentsBody extends StatefulWidget 
{
  // المتغيرات التي يتم تمريرها لهذا الـ Widget:
  
  final String workoutId; // معرف التمرين الحالي، وهو معرف يستخدم لتحديد التمرين الذي سيتم ربطه بالأجهزة
  final SupabaseClient supabase; // كائن SupabaseClient للتعامل مع خدمات Supabase مثل المصادقة والتخزين
  final List<String>? initialEquipmentPaths; // قائمة اختيارية تحتوي على مسارات الأجهزة المختارة مسبقًا (إن وجدت)

  const SelectedEquipmentsBody
  ({
    Key? key,
    required this.workoutId, // تمرير workoutId، وهو مطلوب
    required this.supabase, // تمرير كائن supabase، وهو مطلوب
    this.initialEquipmentPaths, // تمرير قائمة مسارات الأجهزة الأولية، إن وُجدت (غير إلزامية)
    //دي بتاعت الاجهزة المختارة قبل كده واتضافت واتحفظت 
  }) : super(key: key);

  @override
  _SelectedEquipmentsBodyState createState() => _SelectedEquipmentsBodyState(); // إنشاء الحالة (state) المرتبطة بهذا الـ Widget
}

class _SelectedEquipmentsBodyState extends State<SelectedEquipmentsBody> 
{
  int _selectedIndex = 0; // مؤشر الصفحة الحالي لشريط التنقل، يبدأ من 0 (أي الصفحة الأولى)
  
  // قائمة عناوين الصفحات التي تظهر في شريط التنقل العلوي
  final List<String> _pageTitles = ['Workout', 'Flexibility', 'Indoor', 'Preview'];
  
  // قائمة لتخزين مسارات الأجهزة المختارة من قبل المستخدم
  final List<String> selectedEquipmentPaths = [];//دي بتاعت الاجهزة الي انت مختارها حاليا ولسه محفظتهاش تختلف عن الي فوق 
  
  // متحكم الصفحات (PageController) الذي يستخدم للتحكم في عملية التنقل بين الصفحات في PageView
  late final PageController _pageController;

  @override
  void initState() //بالعقل كده هنا هن initialize ايه اكيد الاجهزة الي متضافه قبل كده واتحفظت وكمان الصفحة الحالية الي انت فيها
  {
    super.initState(); // استدعاء الدالة initState للـ StatefulWidget الأساس للتأكد من تهيئة كافة المكونات الضرورية

    // التحقق مما إذا كانت هناك مسارات أجهزة مختارة مسبقاً (initialEquipmentPaths)
    // وفي حالة كانت القائمة الحالية للمسارات فارغة، يتم إضافتها إليها
    if (widget.initialEquipmentPaths != null && selectedEquipmentPaths.isEmpty) 
    {
      selectedEquipmentPaths.addAll(widget.initialEquipmentPaths!);
    }
    // تهيئة الـ PageController وتحديد الصفحة الأولية باستخدام المتغير _selectedIndex
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() 
  {
    _pageController.dispose(); // تحرير موارد الـ PageController عند انتهاء استخدام هذا الـ Widget لمنع تسرب الذاكرة
    super.dispose(); // استدعاء الدالة dispose للوالد للتأكد من إتمام عملية التنظيف
  }

  // دالة لتبديل اختيار الجهاز باستخدام assetPath الممرر إليها
void _toggleSelection(String assetPath)   // الدالة تستقبل مُعرِّف الجهاز assetPath كوسيط، وهو يمثل مسار الصورة أو معرف الجهاز
{
  // setState() تُستخدم لتحديث الحالة الداخلية للـ StatefulWidget وإعادة بناء الواجهة لعرض التغييرات
  setState(() 
  {
//بص بالعقل ده معناها من الاخر لو ال مسار بتاع الصورة الي اختارة دلوقتي موجود في قائمة المسارات الي مختارها حاليا ولسه متحفظتشي معناها انه مش عاوز يضيفه لا عاوز يحذفه ف امسحه
    if (selectedEquipmentPaths.contains(assetPath)) 
    {

      selectedEquipmentPaths.remove(assetPath);
    } 
    else //لو لا يبقي دي اول مره يتضاف فيها وضيفه عادي طبعا كل ده قبل الحفظ اصلا 
    {
      // إذا لم تكن القائمة تحتوي على assetPath، فهذا يعني أن الجهاز غير مختار حاليًا
      // إذن يتم إضافته إلى القائمة، مما يُحدد الجهاز (اختيار الجهاز)
      selectedEquipmentPaths.add(assetPath);//لو لا مش متضاف قبل كده واثبتت انه اتداس عليه يبقي ضيفه دلوقتي معناها ان المستخدم لسه مختاره حالا وعاوز يضيفه 
    }
  });
}


  // دالة لرفع ملف نصي عبر Supabase، يتم إنشاء ملف نصي يحتوي على assetPath ورفعه إلى التخزين
 // الدالة _uploadTextFile تهدف إلى رفع ملف نصي يحتوي على assetPath إلى تخزين Supabase.
// تُعيد الدالة قيمة من نوع Future<String?>؛ حيث تعيد assetPath عند نجاح الرفع، أو null عند الفشل.
Future<String?> _uploadTextFile(String assetPath) async 
{
  try 
  {
    // الحصول على المستخدم الحالي عبر Supabase من خلال نظام المصادقة
    final user = widget.supabase.auth.currentUser; // نحصل على بيانات المستخدم الحالي

    // إذا لم يكن هناك مستخدم مسجل (user == null)، نُرجع null لأن العملية لا يمكن إتمامها بدون مستخدم
    if (user == null) return null; // التحقق من وجود مستخدم، وإن لم يوجد يتم إنهاء الدالة هنا

    // إنشاء اسم الملف الذي سيتم رفعه
    // يتم استخدام الوقت الحالي (millisecondsSinceEpoch) لضمان التفرد،
    // ويُضاف معه الجزء الأخير من assetPath (عادة اسم الملف الأصلي) ثم يتم إلحاق لاحقة .txt
    final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}.txt';
    // مثال: "1634567890123_image.png.txt"

    // تحديد مسار التخزين على Supabase
    // يتم دمج معرف المستخدم (user.id)، ثم قسم "workouts"، ومعرف التمرين (widget.workoutId) واسم الملف
    final storagePath = '${user.id}/workouts/${widget.workoutId}/$fileName';
    // مثال: "user123/workouts/workout456/1634567890123_image.png.txt"

    // تحويل assetPath (نص) إلى مجموعة من البايتات (bytes) باستخدام UTF8،
    // ثم تحويلها إلى كائن من نوع Uint8List، وهذا ضروري لعملية رفع البيانات الثنائية (binary upload)
    final bytes = Uint8List.fromList(utf8.encode(assetPath)); //عند رفع الملفات أو البيانات إلى خدمات التخزين مثل Supabase، يجب أن تكون البيانات في شكل ثنائي (bytes) وليس كنص عادي.
    // هنا يتم ترميز النص إلى بايتات حتى يمكن رفعه إلى الـ bucket في Supabase

    // رفع الملف إلى Supabase:
    // يُستخدم widget.supabase.storage للوصول إلى خدمات التخزين،
    // ثم يتم تحديد الـ bucket المسمى 'user-data' باستخدام from('user-data')
    // وأخيراً تُستدعى دالة uploadBinary مع مسار التخزين (storagePath) والبايتات (bytes)
    final response = await widget.supabase.storage  //فائدة response هنا انها بتدل علي نجاح العملية او فشلها عشان بترجع قيمه 
          .from('user-data')
          .uploadBinary(storagePath, bytes);
    // الدالة uploadBinary ترفع الملف بشكل ثنائي وتعيد استجابة (response) تدل على نجاح العملية أو فشلها

    // التحقق مما إذا كانت الاستجابة (response) ليست null، مما يشير إلى نجاح عملية الرفع
    if (response != null) 
    {
      return assetPath; // عند النجاح، تُرجع الدالة assetPath (يمكن استخدامه للتأكيد أو المعالجة لاحقاً) 
      //لو فعلا اترفع تمام ومش null رجعلي بقي العنوان بتاع النص ده تاني للتطبيق بتاعي عشان هستخدمه عشان اعرض حجات تانيه مرتبطه بالعنوان ده
    } 
    else 
    {
      return null; // في حال فشل العملية (response == null)، تُرجع null
    }
  } 
  catch (e) //فعلنا try فوق ف معناها ان اي خطأ تمسكه في التراي دي رجعهولي واطبعهولي هنا ده مش سنيكي بار بالمناسبه 
  {
    // التقاط أي استثناء يحدث أثناء عملية رفع الملف، وطباعة رسالة الخطأ على وحدة التحكم (console)
    debugPrint('Error uploading text file: $e'); // طباعة رسالة الخطأ للمطور لتتبع المشكلة
    return null; // إعادة null في حال حدوث استثناء 
  }
}



/* 
كده الهدف من getEquipmentDetails هو انه يدور في كل المفاتيح او assetpath  
داخل ال FlexibilityEquipment و WorkoutEquipment و IndoorEquipment  
في كل مره المستخدم فيها بيدوس عشان يرفع صورة ف ترجعله النص بتاعها  
ف احنا بندور هل النص ده موجود في كل من البينات دي  
وبعد اما نتاكد بنرجع كل البينات الي متخزنه معاه  
وبخليه متحدد عليه عادي  
والعمليه دي بتحصل في كل مره المستخد بيدوس فيها علي جهاز من الاجهزة عشان يضيفه  
ف يتخزن في supabase  
بعد كده يرجع التطبيق يدور في كل البينات دي

*/

  // دالة للبحث عن تفاصيل الجهاز باستخدام assetPath من بين ثلاث مجموعات بيانات:
  // WorkoutEquipment, FlexibilityEquipment, IndoorEquipment
  //-----بص من الاخر الهدف بتاع map دي انها تعمل لوب تعدي علي كل العناصر الي متخزنه في WorkoutEquipment عشان تلاقي المسار بتاع الصورة الي اتحدد ده
 Map<String, String>? getEquipmentDetails(String assetPath)   //انا فوق خليت بعد ما تترفع الصورة تمام ورجعلي بالمسار بتاعها عشان هستخدمه بعدين حاليا هو البعدين ده هنستخدم المسار ده كمفتاح عشان نعرض بينات تانيه كمان 
{//ال اتنين strings دول هما ال sub و ال main

  // البحث في بيانات التمرين الأساسية (WorkoutEquipment)
  for (final muscle in WorkoutEquipment.keys)  // التجول عبر المفاتيح (المجموعات العضلية) في WorkoutEquipment
  {//workoutequipment.keys هي ال more , arm , leg وهكذا
    final subgroups = WorkoutEquipment[muscle]; // الحصول على المجموعات الفرعية تحت المجموعة العضلية الحالية 
    // ال subgroups مثلا الباي والتراي 
    if (subgroups != null)  // التحقق أن المجموعات الفرعية ليست null
    {
      for (final subgroup in subgroups.keys) // التجول عبر كل مجموعة فرعية داخل المجموعة العضلية// تحتوي هذه الخريطة على أنواع التصنيفات (عادة "main" و "sub").
      {// ال subgroup بس هي ال main وال sub لكن ال subgroups هي الباي والتراي و ال muscle هي ال arm نفسها 

        final categoryMap = subgroups[subgroup]; // الحصول على خريطة التصنيفات داخل المجموعة الفرعية (مثلاً "main" أو "sub")
        if (categoryMap != null)  // التأكد أن خريطة التصنيفات موجودة
        {
          for (final type in categoryMap.keys) // التجول عبر كل نوع (category) ضمن خريطة التصنيفات
          {
            final equipmentMap = categoryMap[type]; // الحصول على خريطة الأجهزة داخل هذا النوع
            // التحقق من أن equipmentMap غير فارغة وتحتوي على المفتاح assetPath
            if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
            {
              return equipmentMap[assetPath]; // إذا وُجد الجهاز ضمن بيانات WorkoutEquipment، تُعاد تفاصيله
            }
          }
        }
      }
    }
  }

  // البحث في بيانات أجهزة المرونة (FlexibilityEquipment)
  for (final muscle in FlexibilityEquipment.keys)  // التجول عبر المفاتيح (المجموعات العضلية) في FlexibilityEquipment
  {
    final subgroups = FlexibilityEquipment[muscle]; // الحصول على المجموعات الفرعية تحت المجموعة العضلية
    if (subgroups != null)  // التأكد من وجود المجموعات الفرعية
    {
      for (final subgroup in subgroups.keys) // التجول عبر كل مجموعة فرعية
      {
        final categoryMap = subgroups[subgroup]; // الحصول على خريطة التصنيفات داخل المجموعة الفرعية
        if (categoryMap != null)  // التأكد أن خريطة التصنيفات ليست null
        {
          for (final type in categoryMap.keys) // التجول عبر كل نوع ضمن خريطة التصنيفات
          {
            final equipmentMap = categoryMap[type]; // الحصول على خريطة الأجهزة في هذا التصنيف
            // التحقق من أن equipmentMap تحتوي على المفتاح assetPath
            if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
            {
              return equipmentMap[assetPath]; // إذا وُجد الجهاز ضمن بيانات FlexibilityEquipment، تُعاد تفاصيله
            }
          }
        }
      }
    }
  }

  // البحث في بيانات الأجهزة الداخلية (IndoorEquipment)
  for (final muscle in IndoorEquipment.keys)  // التجول عبر المفاتيح (المجموعات العضلية) في IndoorEquipment
  {
    final subgroups = IndoorEquipment[muscle]; // الحصول على المجموعات الفرعية تحت كل مجموعة عضلية
    if (subgroups != null)  // التأكد أن المجموعات الفرعية موجودة
    {
      for (final subgroup in subgroups.keys) // التجول عبر كل مجموعة فرعية
      {
        final categoryMap = subgroups[subgroup]; // الحصول على خريطة التصنيفات داخل المجموعة الفرعية
        if (categoryMap != null)  // التأكد من أن خريطة التصنيفات ليست فارغة
        {
          for (final type in categoryMap.keys) // التجول عبر كل نوع موجود في خريطة التصنيفات
          {
            final equipmentMap = categoryMap[type]; // الحصول على خريطة الأجهزة الخاصة بهذا النوع
            // التأكد من أن equipmentMap تحتوي على المفتاح assetPath وإرجاع التفاصيل إذا وُجدت
            if (equipmentMap != null && equipmentMap.containsKey(assetPath)) 
            {
              return equipmentMap[assetPath]; // إذا وُجد الجهاز ضمن بيانات IndoorEquipment، تُعاد تفاصيله
            }
          }
        }
      }
    }
  }
  
  return null; // إرجاع null إذا لم يتم العثور على الجهاز في أية مجموعة بيانات من WorkoutEquipment أو FlexibilityEquipment أو IndoorEquipment
}


  // دالة تغيير الصفحة عند الضغط على زر في شريط التنقل navigation bar
  void _onItemTapped(int index) //خاصه بعناصر ال navigation bar
  {
    setState(() 
    {
      _selectedIndex = index; // تحديث مؤشر الصفحة الحالية إلى الفهرس الجديد
    });

    _pageController.animateToPage
    (
      index, // الانتقال إلى الصفحة المطلوبة وفقًا للفهرس
      duration: const Duration(milliseconds: 300), // مدة الانتقال (300 مللي ثانية)
      curve: Curves.easeInOut, // منحنى الحركة الذي يجعل الانتقال سلساً
    );
  }

  // دالة حذف جهاز من صفحة Preview
  void _deleteEquipmentFromPreview(String assetPath) 
  {
    setState(() {
      selectedEquipmentPaths.remove(assetPath); // إزالة الجهاز من قائمة الأجهزة المختارة
    });
  }

  // دالة إعادة ترتيب الأجهزة من صفحة Preview
  void _reorderEquipmentFromPreview(List<String> newOrder) //بتغيير الترتيب 
  {
    setState(() 
    {
      selectedEquipmentPaths
        ..clear() // مسح القائمة القديمة
        ..addAll(newOrder); // إضافة الترتيب الجديد الذي تم تمريره
    });
  }

  // دالة بناء صفحات التبويبات (Tabs) التي ستظهر في التطبيق
  List<Widget> _buildPages() 
  {
    return 
    [
      EquipmentChipPage
      (
        equipmentDetails: WorkoutEquipment, // تمرير بيانات التمرينات الأساسية لصفحة EquipmentChipPage
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(), // تحويل قائمة المسارات المختارة إلى مجموعة لمنع التكرار المختارة ولسه متحفظتشي مش القديمه
        onToggle: _toggleSelection, // تمرير دالة تبديل الاختيار للتعامل مع النقر على الأجهزة
      ),
      EquipmentChipPage
      (
        equipmentDetails: FlexibilityEquipment, // تمرير بيانات أجهزة المرونة
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
        onToggle: _toggleSelection,
      ),
      EquipmentChipPage
      (
        equipmentDetails: IndoorEquipment, // تمرير بيانات الأجهزة الداخلية
        selectedEquipmentPaths: selectedEquipmentPaths.toSet(),
        onToggle: _toggleSelection,
      ),
      PreviewBody
      (
        equipmentPaths: selectedEquipmentPaths, // تمرير قائمة الأجهزة المختارة لصفحة المعاينة (Preview)
        getEquipmentDetails: getEquipmentDetails, // تمرير دالة البحث عن تفاصيل الجهاز
        onDeleteEquipment: _deleteEquipmentFromPreview, // تمرير دالة حذف الجهاز من صفحة Preview
        onReorderEquipment: _reorderEquipmentFromPreview, // تمرير دالة إعادة ترتيب الأجهزة في صفحة Preview
      ),
    ];
  }

  @override
  Widget build(BuildContext context) 
  {
    final pages = _buildPages(); // بناء قائمة الصفحات باستخدام الدالة _buildPages

    return Column
    (
      children: 
      [
        // شريط التنقل العلوي باستخدام CustomNavBar
        Padding
        (
          padding: const EdgeInsets.symmetric(vertical: 10), // إضافة حشوة عمودية حول شريط التنقل
          child: CustomNavBar
          (
            selectedIndex: _selectedIndex, // تمرير مؤشر الصفحة الحالي إلى شريط التنقل
            titles: _pageTitles, // تمرير عناوين الصفحات التي سيتم عرضها في شريط التنقل
            onItemTapped: _onItemTapped, // تمرير دالة تغيير الصفحة عند الضغط على أيقونة في شريط التنقل
          ),
        ),
        // عرض الصفحات داخل PageView الذي يسمح بالتبديل بينها عن طريق السحب أو النقر على شريط التنقل
        Expanded
        (
          child: PageView
          (
            controller: _pageController, // استخدام الـ PageController للتحكم في تبديل الصفحات
            onPageChanged: (index) 
            {
              setState(() 
              {
                _selectedIndex = index; // تحديث مؤشر الصفحة الحالية عندما يتغير الصفحة
              });
            },
            children: pages, // تمرير قائمة الصفحات التي بُنيت في الدالة _buildPages
          ),
        ),
      ],
    );
  }
}


//---------------------------------------------custom_nav_bar------------------------------------------------

// custom_nav_bar.dart

import 'dart:math'; // استيراد مكتبة الرياضيات للوصول إلى دالة max لحساب أكبر قيمة بين عرضين
import 'package:flutter/material.dart'; // استيراد مكتبة Flutter الأساسية لبناء الواجهات
import 'package:nine_workout/Useless/consts.dart'; // استيراد ملف الثوابت لتعريف الألوان وغيرها

class CustomNavBar extends StatefulWidget // تعريف ويدجت قابل للتغيير (Stateful) باسم CustomNavBar
{
  final int selectedIndex; // المتغير الذي يحمل فهرس الزر المحدد حاليًا للازرار بتاعت النافيجيشان بار تحديدا 
  final List<String> titles; // قائمة عناوين الأزرار في شريط التنقل
  final Function(int) onItemTapped; // دالة الاستدعاء عند الضغط على أي زر، تأخذ الفهرس كمعامل
  //دي طريقة Dart لتعريف نوع (type) الدالة (callback).  لو ما حددناش نوع الراجع (return type)، فـ Dart بتعتبره dynamic بشكل افتراضي.

  // مُنشئ الكلاس مع المعاملات المطلوبة
  const CustomNavBar
  ({
    Key? key, // مفتاح الويجت لتمييزه داخل شجرة الويجت
    required this.selectedIndex, // فهرس الزر المحدد يجب أن يُمرَّر
    required this.titles, // قائمة العناوين يجب أن تُمرَّر
    required this.onItemTapped, // دالة الضغط يجب أن تُمرَّر
  }) : super(key: key); // استدعاء مُنشئ الكلاس الأب مع المفتاح

  @override
  _CustomNavBarState createState() => _CustomNavBarState(); // ربط الويجت بحالته (State)
}

class _CustomNavBarState extends State<CustomNavBar> // تعريف حالة الويجت الخاصة بـ CustomNavBar
{
  final GlobalKey _navBarKey = GlobalKey(); // مفتاح عام للوصول إلى RenderBox الخاص بالحاوية الرئيسية

  late List<GlobalKey> _tabKeys; // قائمة مفاتيح للوصول إلى كل زر بعد إنشائها
  List<double> _tabWidths = []; // قائمة لتخزين عرض كل زر
  List<double> _tabOffsets = []; // قائمة لتخزين إزاحة كل زر من اليسار
  final double _minIndicatorWidth = 80; // الحد الأدنى لعرض مؤشر التحديد شوف دي ممكن هي الي تحل مشكله الانيميشان 

  @override
  void initState() // بالعقل كده ايه الي محتاج تبدائه في اول التطبيق بالنسبه للجزء ده من الكود محتاج تعرف عدد العناصر الي في النافيجيشان بار 
  //محتاج تعرفهم من خلال عدد النصوص الي مدخله للعناوين هتلاقيها في ال selectedequipmentbody عشان تعمل علي اساسهم مفاتيح 
  {
    super.initState(); // استدعاء المُنشئ الأساسي للحالة

    _tabKeys = List.generate(widget.titles.length, (index) => GlobalKey()); // إنشاء مفتاح لكل زر بناءً على عدد العناوين
    
    WidgetsBinding.instance.addPostFrameCallback((_)  // تسجيل دالة تُنفَّذ بعد انتهاء الإطار الأول
    {
      _calculateTabOffsetsAndWidths(); // حساب الإزاحات والعروض بعد رسم الويجت
    });
  }


  void _calculateTabOffsetsAndWidths() // دالة لحساب العروض والإزاحات لكل زر
  {
    final navBarBox =
        _navBarKey.currentContext?.findRenderObject() as RenderBox?; // الحصول على صندوق الرسم للحاوية الرئيسية

    if (navBarBox == null) return; // إذا لم نحصل على الصندوق، نخرج من الدالة

    final navBarPosition = navBarBox.localToGlobal(Offset.zero); // موضع الحاوية على الشاشة

    List<double> widths = []; // قائمة مؤقتة للعروض
    List<double> offsets = []; // قائمة مؤقتة للإزاحات

    for (var key in _tabKeys) // التكرار على كل مفتاح زر
    {
      final box = key.currentContext?.findRenderObject() as RenderBox?; // الحصول على صندوق الرسم للزر

      if (box != null) 
      {
        widths.add(box.size.width + 16); // عرض الزر زائد 16 بيكسل للمساحة الداخلية

        final position = box.localToGlobal(Offset.zero); // موضع الزر على الشاشة

        offsets.add(position.dx - navBarPosition.dx - 8); // حساب الإزاحة النسبية من الحاوية مع طرح 8 بيكسل لهامش
      } 
      else 
      {
        widths.add(0); // إذا لم نجد الصندوق، نضيف صفر
        offsets.add(0); // نفس الشيء للإزاحة
      }
    }
    setState(() 
    {
      _tabWidths = widths; // تحديث حالة العروض
      _tabOffsets = offsets; // تحديث حالة الإزاحات
    });
  }

  Widget _buildTab({required int index, required String text}) // دالة لبناء زر نصي واحد
  {
    return TextButton // استخدام TextButton لزر قابل للضغط
    (
      key: _tabKeys[index], // ربط المفتاح الخاص بهذا الزر
      onPressed: () => widget.onItemTapped(index), // عند الضغط، استدعاء الدالة مع الفهرس
      style: ButtonStyle // تخصيص ستايل الزر
      (
        overlayColor: MaterialStateProperty.all(Colors.transparent), // إزالة لون التراكب الافتراضي عند الضغط
      ),
      child: Text // نص الزر
      (
        text, // النص الممرَّر
        textAlign: TextAlign.center, // محاذاة النص في الوسط
        style: const TextStyle(color: Colors.white, fontSize: 13), // ستايل النص: أبيض وحجم 13
      ),
    );
  }

  @override
  Widget build(BuildContext context) // بناء واجهة الويجت
  {
    return Container // حاوية رئيسية لشريط التنقل
    (
      key: _navBarKey, // ربط المفتاح بالحاوية
      width: 340, // عرض ثابت للشريط
      height: 60, // ارتفاع ثابت للشريط
      decoration: BoxDecoration // تزيين الحاوية
      (
        color: const Color(0xff888181).withOpacity(0.35), // لون رمادي شفاف
        borderRadius: BorderRadius.circular(35), // زوايا مدورة بنصف القطر 35
      ),
      child: Stack // استخدام Stack لوضع المؤشر وخيارات الأزرار فوق بعض
      (
        alignment: Alignment.center, // محاذاة المحتوى في الوسط
        children: 
        [
          // مؤشر الحركة الذي يتحرك حسب الزر المختار
          if (_tabOffsets.isNotEmpty && _tabWidths.isNotEmpty) // إذا تم حساب الإزاحات والعروض
            AnimatedPositioned // عنصر متحرك يغير موقعه مع الرسوم
            (
              left: _tabOffsets[widget.selectedIndex], // الموضع الأفقي بناءً على الفهرس
              duration: const Duration(milliseconds: 275), // مدة الانتقال
              curve: Curves.easeInOut, // منحنى الحركة

              child: Container // حاوية المؤشر
              (
                width: max(_tabWidths[widget.selectedIndex], _minIndicatorWidth), // عرض المؤشر (أكبر بين عرض الزر والحد الأدنى)
                height: 60, // نفس ارتفاع الشريط
                decoration: BoxDecoration // تزيين المؤشر
                (
                  color: myColor, // اللون المحدد في الثوابت
                  borderRadius: BorderRadius.circular(30), // زوايا مدورة بنصف القطر 30
                ),
              ),
            ),

          Row // صف لعرض الأزرار أفقيًا
          (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // توزيع الأزرار بالتساوي
            children: List.generate // إنشاء قائمة من الأزرار بناءً على العناوين
            ( //استخدمنا النصوص بتاعت العناوين الي مدخلها في ال selectedequipmentbody استخدمناها هنا عشان تحددلنا عددهم وتبقي هي العناوين 
              widget.titles.length, // عدد العناصر
              (index) => _buildTab // استدعاء دالة بناء الزر
              (
                index: index, // تمرير الفهرس
                text: widget.titles[index], // تمرير النص
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//---------------------------------------------ChooseEquipmentsLogic------------------------------------------------


// choose_equipments_logic.dart

import 'dart:convert';                    // استيراد مكتبة dart:convert لتحويل النصوص بين صيغ مختلفة (مثل UTF-8)
import 'dart:typed_data';                 // استيراد مكتبة dart:typed_data للتعامل مع مصفوفات البايتات بكفاءة
import 'package:supabase_flutter/supabase_flutter.dart'; // استيراد مكتبة Supabase للتكامل مع خدمة Supabase

class ChooseEquipmentsLogic              // تعريف كلاس لإدارة منطق اختيار ورفع وترتيب الأجهزة
{                                         
  final List<String> selectedEquipmentPaths = []; // قائمة نهائية (final) لتخزين مسارات الأجهزة المختارة لاول مره مش المحفوظه 

  void toggleSelection(String assetPath) // دالة لتبديل حالة اختيار الجهاز حسب مسار الأصل
  {                                       
    if (selectedEquipmentPaths.contains(assetPath)) // إذا كان المسار موجودًا في القائمة
    {                                     
      selectedEquipmentPaths.remove(assetPath);      //   قم بإزالته (إلغاء الاختيار)
    }                                     
    else                                  
    {                                     
      selectedEquipmentPaths.add(assetPath);         //   وإلا قم بإضافته (اختيار الجهاز)
    }                                     
  }                                       

  Future<String?> uploadTextFile          // دالة غير متزامنة لرفع "ملف نصي" يمثل assetPath إلى Supabase Storage
  (
    String assetPath,                     // مسار الأصل الذي نريد رفعه كنص
    {
      required SupabaseClient client,     // عميل Supabase لإجراء العمليات
      required String workoutId,          // معرف التمرين لبناء مسار التخزين
    }
  ) async                               
  {                                       
    try                                  
    {                                     
      final user = client.auth.currentUser;       // الحصول على المستخدم الحالي من عميل Supabase
      if (user == null) return null;              // إذا لم يكن هناك مستخدم مسجل، ارجع null

      final fileName =                           // إنشاء اسم ملف فريد يعتمد على الطابع الزمني واسم الأصل
        '${DateTime.now().millisecondsSinceEpoch}_${assetPath.split('/').last}.txt';
      final storagePath =                        // بناء مسار التخزين داخل البوكت 'user-data'
        '${user.id}/workouts/$workoutId/$fileName';

      final bytes =                             // تحويل نص assetPath إلى بايتات بصيغة UTF-8
        Uint8List.fromList(utf8.encode(assetPath));

      final response = await client.storage     // رفع البايتات إلى Supabase Storage
          .from('user-data')
          .uploadBinary(storagePath, bytes);

      if (response != null)                     // إذا نجح الرفع (response غير null)
      {                                        
        return assetPath;                       //   أرجع assetPath للدلالة على النجاح
      }                                        
      else                                      // وإلا (response null)
      {                                        
        return null;                            //   أرجع null للدلالة على الفشل
      }                                        
    }                                      
    catch (e)                               
    {                                       
      print('Error uploading text file: $e');     // طباعة رسالة الخطأ في الكونسول
      return null;                                 // إرجاع null عند حدوث أي استثناء
    }                                       
  }                                       

  Map<String, String>? getEquipmentDetails // دالة للبحث عن تفاصيل الجهاز في خرائط الأجهزة
  (
    String assetPath,                       // مسار الأصل المراد البحث عنه
    {
      required Map<String, Map<String, Map<String, Map<String, Map<String, String>>>>> workoutEquipment,    // خرائط أجهزة التمارين
      required Map<String, Map<String, Map<String, Map<String, String>>>> flexibilityEquipment,            // خرائط أجهزة المرونة
      required Map<String, Map<String, Map<String, Map<String, String>>>> indoorEquipment,                 // خرائط أجهزة الأماكن المغلقة
    }
  )                                       
  {                                       
    // البحث في workoutEquipment
    for (final muscle in workoutEquipment.keys)           // تكرار على مفاتيح العضلات
    {                                  
      final subgroups = workoutEquipment[muscle];         // خريطة المجموعات الفرعية لكل عضلة
      if (subgroups != null)                              // إذا المجموعة الفرعية غير فارغة
      {                                  
        for (final subgroup in subgroups.keys)            // تكرار على مفاتيح المجموعات الفرعية
        {                              
          final categoryMap = subgroups[subgroup];        // خريطة الفئات داخل كل مجموعة فرعية
          if (categoryMap != null)                        // إذا خريطة الفئة غير فارغة
          {                            
            for (final type in categoryMap.keys)          // تكرار على مفاتيح الأنواع داخل الفئة
            {                          
              final equipmentMap = categoryMap[type];     // خريطة الأجهزة لكل نوع
              if (equipmentMap != null && equipmentMap.containsKey(assetPath)) // إذا وجدت بيانات للأصل
              {                        
                return equipmentMap[assetPath] as Map<String, String>?; // أرجع تفاصيل الجهاز
              }                        
            }                          
          }                            
        }                              
      }                                
    }                                  

    // البحث في flexibilityEquipment (نفس المنطق)
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

    // البحث في indoorEquipment (نفس المنطق)
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

    return null; // إذا لم نجد الأصل في أي خريطة، أرجع null
  }

  void deleteEquipment(String assetPath) // دالة لحذف جهاز من قائمة الاختيارات
  {                                        
    selectedEquipmentPaths.remove(assetPath); // إزالة المسار من القائمة
  }

  void reorderEquipment(List<String> newOrder) // دالة لإعادة ترتيب الأجهزة حسب الترتيب الجديد
  {                                        
    selectedEquipmentPaths                      // استخدام cascade operator لتعديل القائمة
      ..clear()                                // أولاً: مسح القائمة الحالية
      ..addAll(newOrder);                      // ثم: إضافة المسارات بالترتيب الجديد
  }
}


//---------------------------------------------AddEquipmentSelectionPage------------------------------------------------

import 'package:flutter/material.dart'; // استيراد مكتبة Flutter لبناء واجهات المكونات
import 'package:nine_workout/ChooseEquipments/Selected_Equipments_Body.dart'; // استيراد الويجت الخاص بجسم صفحة اختيار الأجهزة
import 'package:supabase_flutter/supabase_flutter.dart'; // استيراد عميل Supabase للتكامل مع قاعدة البيانات والتخزين

class AddEquipmentSelectionPage extends StatefulWidget // تعريف ويدجت بحالة لتسمح بالتحديثات الداخلية
{ 
  final String workoutId; // معرف التمرين الذي سيتم ربط اختيار الأجهزة به
  final List<String>? initialEquipmentPaths; // قائمة اختيارية بمسارات الأجهزة المبدئية إن وُجدت

  const AddEquipmentSelectionPage // مُنشئ الكلاس
  ({
    Key? key, // مفتاح اختياري لتمييز الويجت في شجرة الويجت
    required this.workoutId, // جعل تمرير معرف التمرين إلزامياً
    this.initialEquipmentPaths, // تمرير القائمة المبدئية اختيارياً
  }) : super(key: key); // استدعاء مُنشئ الكلاس الأب مع المفتاح

  @override // تجاوز دالة إنشاء الحالة
  _AddEquipmentSelectionPageState createState() => // ربط الويجت بالكلاس الذي يمثل الحالة
      _AddEquipmentSelectionPageState(); // إنشاء مثيل لحالة الويجت
}

class _AddEquipmentSelectionPageState extends State<AddEquipmentSelectionPage> // تعريف كلاس الحالة المرتبط بالويجت أعلاه
{
  final GlobalKey _bodyKey = GlobalKey(); // مفتاح عام للوصول إلى حالة SelectedEquipmentsBody
  final SupabaseClient supabase = Supabase.instance.client; // الحصول على عميل Supabase الحالي

  void _onSave() // دالة تُنفذ عند الضغط على زر "Save"
  {
    final bodyState = _bodyKey.currentState as dynamic; // الحصول على حالة SelectedEquipmentsBody بصيغة ديناميكية
    final List<String> selectedPaths = // استخراج قائمة المسارات المختارة من حالة الويجت الفرعي
        (bodyState.selectedEquipmentPaths as List<String>).toList(); // تحويلها إلى قائمة جديدة

    Navigator.pop(context, selectedPaths); // إغلاق الصفحة وإرجاع قائمة المسارات المختارة إلى الصفحة السابقة
  }

  @override // تجاوز دالة بناء الواجهة
  Widget build(BuildContext context) // دالة بناء واجهة المستخدم
  {
    return Scaffold // استخدام Scaffold كهيكل رئيسي للصفحة
    (
      appBar: AppBar // شريط التطبيقات في أعلى الصفحة
      (
        title: const Text // عنوان الصفحة
        (
          "Select Equipment", // نص العنوان
          style: TextStyle(fontSize: 22), // حجم الخط للعنوان
        ),

        centerTitle: true, // محاذاة العنوان في الوسط

        actions: // قائمة الأزرار في شريط التطبيقات
        [
          TextButton // زر نصي لحفظ الاختيارات
          (
            onPressed: _onSave, // استدعاء دالة الحفظ عند الضغط

            child: const Text // نص الزر
            (
              'Save', // محتوى الزر
              style: TextStyle // تنسيق نص الزر
              (
                color: Color.fromARGB(255, 97, 96, 96), // لون النص
                fontSize: 14, // حجم الخط
                fontWeight: FontWeight.bold, // ثخانة الخط
              ),
            ),
          ),

          const SizedBox(width: 7), // مسافة أفقية بسيطة بين الزر وحافة الشاشة
        ],
      ),
      body: SelectedEquipmentsBody // جسم الصفحة الرئيسي المخصص لاختيار الأجهزة
      (
        key: _bodyKey, // تمرير المفتاح للوصول إلى الحالة الداخلية
        workoutId: widget.workoutId, // تمرير معرف التمرين من الويجت الأب
        supabase: supabase, // تمرير عميل Supabase لإجراء العمليات الخلفية
        initialEquipmentPaths: widget.initialEquipmentPaths, // تمرير المسارات المبدئية إن وجدت
      ),
    );
  }
}
