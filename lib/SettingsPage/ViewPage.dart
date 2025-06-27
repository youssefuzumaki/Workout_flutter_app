import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nine_workout/SettingsPage/SettingsLogic.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewPage extends StatefulWidget {
  final String? imageUrl;
  const ViewPage({super.key, required this.imageUrl});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final _supabase = Supabase.instance.client;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _isLoading = true;
      });
      await _uploadImage();
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadImage() async {
    final user = _supabase.auth.currentUser;
    if (user == null || _imageFile == null) return;

    try {
      // توليد اسم ملف فريد لتجنب استبدال الصور السابقة
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_profile.jpg';
      final path = '${user.id}/avatar/$uniqueFileName';

      await _supabase.storage.from('user-data').upload(
        path,
        _imageFile!,
        fileOptions: FileOptions(upsert: true),
      );
      
      // استرجاع الرابط العام للصورة الجديدة
      final imageUrl = _supabase.storage.from('user-data').getPublicUrl(path);
      
      // تحديث سجل المستخدم في جدول profiles بالرابط الجديد
      await _supabase.from('profiles').update
      ({
        'avatar_url': imageUrl,
      }).eq('id', user.id);
      
      if (mounted) {
        Provider.of<ProfileService>(context, listen: false).updateAvatar(imageUrl);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث الصورة بنجاح')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) 
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في الرفع: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصورة الشخصية')),
      body: GestureDetector(
        onTap: _pickImage,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'user-avatar',
                child: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 150,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                          ? NetworkImage(widget.imageUrl!) as ImageProvider
                          : null,
                  child: _imageFile == null && (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 100, color: Colors.grey)
                      : null,
                ),
              ),
              if (_isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
