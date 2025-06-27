import 'package:flutter/material.dart';
import 'package:nine_workout/Needes/Notiffication.dart';
import 'package:nine_workout/Useless/CustomIconButton.dart';
import 'package:nine_workout/Useless/consts.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String imageAsset;
  final double titlesize;

  const DetailsPage({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.titlesize,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isPaused = false;

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    // التأكد من وجود مسار صورة صالح، وإن لم يكن يتم استخدام صورة بديلة
    final String imagePath = (widget.imageAsset.isNotEmpty)
        ? widget.imageAsset
        : 'assets/placeholder.png';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // إضافة maxLines و overflow للعنوان
            Text(
              widget.title,
              style: TextStyle(fontSize: widget.titlesize),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(flex: 2),
            // زر pause/play لتبديل حالة التشغيل
            IconButton(
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: togglePause,
            ),
            // زر التعديل الحالي مع CustomIconButton
            CustomIconButton(
              iconName: Icons.edit,
              pagename: Notiffication(),
            ),
          ],
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(
            color: Color(0xff707070),
            thickness: 2,
            height: 2,
            indent: 15,
            endIndent: 15,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض صورة التمرين مع إطار أنيق
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // لون الحواف
                  width: 5, // عرض الحواف
                ),
                borderRadius: BorderRadius.circular(45), // نصف قطر الحواف لتناسق الشكل
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20, width: 20),
            // عناصر المؤشر تحت الصورة
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: myColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20, width: 20),
            const Divider(
              color: Color(0xff707070),
              thickness: 2,
              indent: 80,
              endIndent: 80,
            ),
            const SizedBox(height: 20, width: 20),
            // لوحة عرض معلومات إضافية (مثال)
            Container(
              width: 280,
              height: 70,
              decoration: BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 7),
                  Container(
                    width: 71,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Weights',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8B8686),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 71,
                    height: 31,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Reps',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff8B8686),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // الوظيفة عند الضغط على الزر
                      },
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ),
                  const SizedBox(width: 7),
                ],
              ),
            ),
            const SizedBox(height: 15, width: 20),
            Container(
              width: 270,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 48,
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        '9/17',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 4, width: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 17.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Weights',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '15',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Reps',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 35.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Sets',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7, width: 20),
            Container(
              width: 270,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Container(
                    width: 65,
                    height: 48,
                    decoration: BoxDecoration(
                      color: myColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        '9/17',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 17.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Weights',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '15',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Reps',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '10',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 35.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Sets',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '4',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 140, width: 20),
          ],
        ),
      ),
    );
  }
}
