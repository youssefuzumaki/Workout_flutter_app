import 'package:flutter/material.dart';

class LoginWays extends StatelessWidget 
{
  final String image;
  final Widget destinationPage;


  const LoginWays
  ({ Key? key, 

    required this.image, 
    required this.destinationPage,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return Container
    (
      width: 43,
      height: 43,

      decoration: BoxDecoration
      (
        border: Border.all
        (
          color: Colors.grey, // لون الحدود
          width: 1.5,        // سمك الحدود
        ),

        borderRadius: BorderRadius.circular(8), // زوايا مستديرة (اختياري)
      ),

      child: IconButton
      (
        icon: Image.asset
        (
          image,
          width: 25,
          height: 25,
        ),

        padding: EdgeInsets.zero, // إزالة الحشوة الداخلية للزر

        onPressed: () => Navigator.push
        (
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        ),
      ),
    );
  }
}