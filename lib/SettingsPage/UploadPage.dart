import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class UploadService 
{

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> uploadProfileImage(File imageFile) async 
  {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try 
    {
      // توليد اسم ملف فريد باستخدام توقيت الحالي
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_profile.jpg';
      final path = '${user.id}/avatar/$uniqueFileName';
      
      // رفع الصورة مع خيار upsert لنفس الملف، ولكن هنا الملف فريد وبالتالي لن يستبدل أي ملف موجود
      await _supabase.storage.from('user-data').upload
      (
        path,
        imageFile,
        fileOptions: const FileOptions(upsert: true),
      );
      
      // استرجاع الرابط العام للصورة
      return _supabase.storage.from('user-data').getPublicUrl(path);
    } 
    catch (e) 
    {
      throw Exception('فشل الرفع: $e');
    }
  }

  Future<void> updateProfileData(String imageUrl) async 
  {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // تحديث سجل المستخدم في جدول profiles مع الرابط الجديد للصورة
    await _supabase.from('profiles').upsert
    ({
      'id': user.id,
      'avatar_url': imageUrl,
    });
  }
}
