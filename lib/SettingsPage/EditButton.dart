import 'package:flutter/material.dart';

class NameInputPage extends StatefulWidget 
{
  const NameInputPage({Key? key}) : super(key: key);

  @override
  _NameInputPageState createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> 
{
  
  final TextEditingController _nameController = TextEditingController();

  void _saveName() 
  {
    final String name = _nameController.text.trim();
    Navigator.pop(context, name); // يعيد الاسم إلى الصفحة السابقة
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: const Text('أدخل اسمك'),
      ),
      body: Padding
      (
        padding: const EdgeInsets.all(16.0),

        child: Column
        (
          children: 
          [
            TextField
            (
              controller: _nameController,
              decoration: const InputDecoration
              (
                labelText: 'اسم المستخدم',
                hintText: 'أدخل اسمك هنا',
              ),
            ),

            const SizedBox(height: 20),

            Row
            (
              mainAxisAlignment: MainAxisAlignment.end,
              
              children: 
              [
                TextButton
                (
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton
                (
                  onPressed: _saveName,
                  child: const Text('حفظ'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
