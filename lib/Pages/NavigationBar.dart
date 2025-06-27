import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nine_workout/Needes/DietPage.dart';
import 'package:nine_workout/Needes/Exist.dart';
import 'package:nine_workout/Needes/Profile.dart';
import 'package:nine_workout/Pages/WorkoutList.dart';
import 'package:nine_workout/SettingsPage/SettingsPage.dart';
import 'package:nine_workout/Useless/consts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  double overlayOpacity = .8;

  final List<Widget> _pages = 
  [
    const WorkoutList(),
    const DietPage(),
    const Profile(), 
    const SettingsPage(), 
  ];

  void _onItemTapped(int index) 
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DoubleSwipeExit(
      child: Scaffold(
        body: Stack(
          children: [
            _pages[_selectedIndex],
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 20),
                    child: Container(
                      width: 315,
                      height: 63,
                      decoration: BoxDecoration(
                        color: Color(0xff888181).withOpacity(0.1),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 1,
                            child: Image.asset(
                              'assets/workout_page_componant/Component 8 – 1.png',
                              width: 315,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Opacity(
                            opacity: .2,
                            child: Image.asset(
                              'assets/workout_page_componant/Path 32.png',
                              width: 400,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildIconWithOverlay(
                                icon: Icons.fitness_center,
                                index: 0,
                                imagePath: 'assets/workout_page_componant/boutton hilight.png',
                              ),
                              _buildIconWithOverlay(
                                icon: FontAwesomeIcons.apple,
                                index: 1,
                                imagePath: 'assets/workout_page_componant/boutton hilight.png',
                              ),
                              _buildIconWithOverlay(
                                icon: Icons.text_rotate_up_sharp,
                                index: 2,
                                imagePath: 'assets/workout_page_componant/boutton hilight.png',
                              ),
                              _buildIconWithOverlay(
                                icon: Icons.settings,
                                index: 3,
                                imagePath: 'assets/workout_page_componant/boutton hilight.png',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithOverlay({
    required IconData icon,
    required int index,
    required String imagePath,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_selectedIndex == index)
          Positioned(
            bottom: 0,
            child: Opacity(
              opacity: overlayOpacity,
              child: Image.asset(
                imagePath,
                width: 75,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        IconButton(
          icon: Icon(
            icon,
            color: _selectedIndex == index ? myColor : Colors.white,
          ),
          onPressed: () => _onItemTapped(index),
        ),
      ],
    );
  }
}
