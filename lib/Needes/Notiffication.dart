import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

// تهيئة مكتبة الإشعارات
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Notiffication extends StatelessWidget {
  const Notiffication({super.key});

  // دالة لطلب إذن الإشعارات
  Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      final status = await Permission.notification.request();
      final scaffoldContext = Navigator.of(context, rootNavigator: true).context;

      if (status.isGranted) 
      {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar
        (
          const SnackBar(content: Text('تم السماح بالإشعارات! 🎉')),
        );
        await _showTestNotification(); // إرسال إشعار تجريبي
      } else {
        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
          const SnackBar(content: Text('الإذن مطلوب لتلقي الإشعارات ⚠️')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  // دالة لإرسال إشعار تجريبي
  Future<void> _showTestNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'default_channel',
      'الإشعارات العامة',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'اختبار إشعار 🚀',
      'مرحبًا! هذا إشعار تجريبي.',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('السماح بالإشعارات'),
      content: const Text('هل تريد تلقي إشعارات حول التمارين الجديدة؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('لاحقًا'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _requestNotificationPermission(context);
            Navigator.pop(context);
          },
          child: const Text('السماح'),
        ),
      ],
    );
  }
}