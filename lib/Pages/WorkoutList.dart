import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nine_workout/AddingButtons/AddingContainers.dart';
import 'package:nine_workout/AddingButtons/WorkoutDialog.dart';
import 'package:nine_workout/DataFolder/Dataofworkoutlists.dart';
import 'package:nine_workout/Needes/Notiffication.dart';
import 'package:nine_workout/Needes/Profile.dart';
import 'package:nine_workout/Pages/WorkoutButton.dart';
import 'package:nine_workout/Pages/Workout_items.dart';
import 'package:nine_workout/Pages/equipmentPage.dart';
import 'package:nine_workout/Useless/CustomIconButton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  late ScrollController _scrollController;
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _workouts = [];
  StreamSubscription<List<Map<String, dynamic>>>? _workoutsSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _subscribeToWorkouts();
  }

  void _subscribeToWorkouts() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final stream = _supabase
        .from('workouts')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    _workoutsSubscription = stream.listen((data) {
      setState(() {
        _workouts = data;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _workoutsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _showAddWorkoutDialog() async {
    final workoutName = await showDialog<String>(
      context: context,
      builder: (context) => WorkoutDialog(),
    );
    if (workoutName != null && workoutName.isNotEmpty) {
      try {
        final user = _supabase.auth.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
          );
          return;
        }
        await _supabase.from('workouts').insert({
          'name': workoutName,
          'user_id': user.id,
          'is_default': false,
          'muscle_group': 'custom',
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إضافة التمرين: ${e.toString()}')),
        );
      }
    }
  }

  // التنقل إلى صفحة الأجهزة مع تمرير workoutId كنص
  void _navigateToEquipmentPage(Map<String, dynamic> equipmentPageData, String title, String workoutId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentPage(
          workoutId: workoutId,
          equipment_title: title,
          imageAssets: equipmentPageData['imageAssets'],
          titles: equipmentPageData['titles'],
          equipmentList: equipmentPageData['equipmentList'],
          points: equipmentPageData['points'],
          times: equipmentPageData['times'],
          reps: equipmentPageData['reps'],
        ),
      ),
    );
  }

Future<void> _deleteWorkout(String id) async {
  final user = _supabase.auth.currentUser;
  if (user == null) return;

  // حذف الملفات الموجودة في مجلد التمرين من Storage
  try {
    // مسار المجلد الخاص بالتمرين
    final folderPath = '${user.id}/workouts/$id';
    // استرجاع الملفات داخل المجلد باستخدام معامل path
    final files = await _supabase.storage.from('user-data').list(path: folderPath);
    if (files.isNotEmpty) {
      // بناء قائمة المسارات الكاملة للملفات
      final List<String> filePaths =
          files.map((file) => '$folderPath/${file.name}').toList();
      // استدعاء دالة remove مع تمرير القائمة كمعامل موضعي
     final removeResponse = await _supabase.storage.from('user-data').remove(filePaths);
debugPrint('Files removed: $removeResponse');

    }
  } catch (e) {
    debugPrint('Exception deleting storage files: $e');
  }

  // حذف سجل التمرين من قاعدة البيانات
  try {
    await _supabase.from('workouts').delete().eq('id', id);
    setState(() {
      _workouts.removeWhere((workout) => workout['id'].toString() == id);
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل في حذف التمرين: ${e.toString()}')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            toolbarHeight: 75,
            elevation: 0,
            title: const Center(child: Text('Workout')),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CustomIconButton(
                iconName: Icons.person,
                label: 'مرحبًا!',
                pagename: const Profile(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomIconButton(
                  iconName: Icons.notifications,
                  pagename: const Notiffication(),
                ),
              ),
            ],
            floating: false,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: WorkoutButton(
              onPressed: _showAddWorkoutDialog,
            ),
          ),
          // عرض التمرينات الثابتة من البيانات الثابتة
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final data = workoutData[index];
                final String workoutId = data['id'];
                return GestureDetector(
                  onTap: () => _navigateToEquipmentPage(
                      data['equipmentPageData'], data['name'], workoutId),
                  child: workoutItem(
                    TiTles: [data['name']],
                    points: data['points'],
                    kcal: data['kcal'],
                    times: data['times'],
                    Times: data['timesThisMonth'],
                    ImageAssets: data['imageAssets'],
                    ImageAssets2: data['backgroundAssets'],
                  ),
                );
              },
              childCount: workoutData.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Opacity(
                opacity: 0.3,
                child: Divider(
                  thickness: 2.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // عرض التمرينات المُضافة ديناميكيًا من جدول workouts
          _workouts.isNotEmpty
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final workout = _workouts[index];
                      return KeyedSubtree(
                        key: ValueKey(workout['id']),
                        child: AddingContainers(
                          docId: workout['id'].toString(),
                          title: workout['name'],
                          onDelete: (id) => _deleteWorkout(id),
                        ),
                      );
                    },
                    childCount: _workouts.length,
                  ),
                )
              : const SliverToBoxAdapter(
                  child: Center(child: Text('لم تقم بإضافة أي تمارين بعد')),
                ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 72),
          ),
        ],
      ),
    );
  }
}
