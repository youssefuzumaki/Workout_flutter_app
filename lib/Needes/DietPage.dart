import 'package:flutter/material.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('DietPage'),
        Image.asset('assets/workout_page_componant/Group 36.png'),
      ],
    );
  }
}