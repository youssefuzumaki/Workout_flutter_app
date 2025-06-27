import 'package:flutter/material.dart';

class WorkoutDialog extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();

  WorkoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Workout'),
      content: TextField(
        style: const TextStyle(fontSize: 15, color: Colors.black),
        controller: titleController,
        decoration: const InputDecoration
        (

          
          labelText: 'Workout Title',
        ),
      ),
      actions: 
      [
        TextButton
        (
          onPressed: () 
          {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, titleController.text);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
