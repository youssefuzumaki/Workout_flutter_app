// custom_nav_bar.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nine_workout/Useless/consts.dart';

class CustomNavBar extends StatefulWidget
{

  final int selectedIndex;
  final List<String> titles;
  final Function(int) onItemTapped;

  // قائمة المفاتيح الخاصة بكل زر (يمكن إنشاؤها داخل هذا الكلاس أو تمريرها من الخارج)
  const CustomNavBar
  ({
    Key? key,
    required this.selectedIndex,
    required this.titles,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> 
{
  final GlobalKey _navBarKey = GlobalKey();

  late List<GlobalKey> _tabKeys;

  List<double> _tabWidths = [];

  List<double> _tabOffsets = [];

  final double _minIndicatorWidth = 80;

  @override
  void initState() 
  {
    super.initState();
    _tabKeys = List.generate(widget.titles.length, (index) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback
    ((_) 
    {
      _calculateTabOffsetsAndWidths();
    });
  }

  void _calculateTabOffsetsAndWidths() 
  {
    final navBarBox =
        _navBarKey.currentContext?.findRenderObject() as RenderBox?;

    if (navBarBox == null) return;

    final navBarPosition = navBarBox.localToGlobal(Offset.zero);

    List<double> widths = [];

    List<double> offsets = [];

    for (var key in _tabKeys) 
    {
      final box = key.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) 
      {
        widths.add(box.size.width + 16);
        final position = box.localToGlobal(Offset.zero);
        offsets.add(position.dx - navBarPosition.dx - 8);
      } 
      else 
      {
        widths.add(0);
        offsets.add(0);
      }
    }
    setState(() 
    {
      _tabWidths = widths;
      _tabOffsets = offsets;
    });
  }

  Widget _buildTab({required int index, required String text}) 
  {
    return TextButton
    (
      key: _tabKeys[index],
      onPressed: () => widget.onItemTapped(index),

      style: ButtonStyle
      (
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Text
      (
        text,
        textAlign: TextAlign.center,

        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      key: _navBarKey,
      width: 340,
      height: 60,

      decoration: BoxDecoration
      (
        color: const Color(0xff888181).withOpacity(0.35),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Stack
      (
        alignment: Alignment.center,

        children: 
        [
          // مؤشر الحركة الذي يتحرك حسب الزر المختار
          if (_tabOffsets.isNotEmpty && _tabWidths.isNotEmpty)
            AnimatedPositioned
            (
              left: _tabOffsets[widget.selectedIndex],
              duration: const Duration(milliseconds: 275),
              curve: Curves.easeInOut,

              child: Container
              (
                width: max(_tabWidths[widget.selectedIndex], _minIndicatorWidth),
                height: 60,
                decoration: BoxDecoration
                (
                  color: myColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

          Row
          (
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: List.generate
            (
              widget.titles.length,
              (index) => _buildTab
              (
                index: index,
                text: widget.titles[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
