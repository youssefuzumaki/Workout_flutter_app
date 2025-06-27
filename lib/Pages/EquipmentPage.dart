import 'package:flutter/material.dart';
import 'package:nine_workout/Needes/Profile.dart';
import 'package:nine_workout/Pages/DetailsPage.dart';
import 'package:nine_workout/Useless/consts.dart';

class EquipmentPage extends StatefulWidget {
  final String workoutId;
  final String equipment_title;
  final List<String> imageAssets;
  final List<String> titles;
  final List<String> equipmentList;
  final List<String> points;
  final List<String> times;
  final List<String> reps;

  const EquipmentPage({
    super.key,
    required this.workoutId,
    required this.equipment_title,
    required this.imageAssets,
    required this.titles,
    required this.equipmentList,
    required this.points,
    required this.times,
    required this.reps,
  });

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // إجمالي العناصر = 2 + عدد عناصر المعدات:
    // index 0: Header (شبيه الـ app bar)
    // index 1: زر الإضافة مع الصورة الزخرفية (باستخدام Positioned لرفع الزر)
    // index >=2: باقي العناصر
    int totalCount = widget.equipmentList.length + 2;
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            // الهيدر (شبيه الـ app bar) جزء من المحتوى
            return Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Container(
                height: 40,
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  widget.equipment_title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            );
          } else if (index == 1) {
            // زر الإضافة مع الصورة الزخرفية، حيث نستخدم Positioned لرفع الزر
            return Container(
              height: 0,
              // لا يأخذ مساحة فعلية في التخطيط
              child: Stack(
                clipBehavior: Clip.none,
                children: 
                [
                  Positioned(
                    top: -125,
                    right: -80,
                    child: GestureDetector
                    (
                     onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    ),
                      child: Image.asset
                      (
                        'assets/workout_page_componant/Group 45.png',
                        width: 215,
                        height: 215,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                 
                ],
              ),
            );
          } else {
            int dataIndex = index - 2;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage
                    (
                      titlesize: 20,
                      title: widget.titles[dataIndex],
                      imageAsset: widget.imageAssets[dataIndex],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                    top: 5, left: 15, right: 17, bottom: 5),
                width: MediaQuery.of(context).size.width - 32,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xff272727).withOpacity(.5),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9, ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              widget.imageAssets[dataIndex],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.titles[dataIndex],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.reps[dataIndex]} Reps',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xff8B8686),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${widget.times[dataIndex]} Times',
                              style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xff8B8686),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 15,
                      bottom: 10,
                      child: Text(
                        widget.points[dataIndex],
                        style: const TextStyle(
                          fontSize: 14,
                          color: myColor,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: myColor,
                              offset: Offset(1, 1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}