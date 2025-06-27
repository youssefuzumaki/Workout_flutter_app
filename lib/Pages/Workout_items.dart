import 'package:flutter/material.dart';

class workoutItem extends StatelessWidget {
  final List<String> TiTles;
  final int points;
  final int kcal;
  final int times;
  final int Times;
  final List<String> ImageAssets;
  final List<String> ImageAssets2;

  const workoutItem({
    super.key,
    required this.TiTles,
    required this.points,
    required this.kcal,
    required this.times,
    required this.Times,
    required this.ImageAssets,
    required this.ImageAssets2,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 7),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: TiTles.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 0, left: 15, right: 17),
          width: 360,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xff272727).withOpacity(.7),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  ImageAssets2[index],
                  width: 200,
                  height: 120,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TiTles[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$points Points',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Text(
                            '$kcal kcal / $times min',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xff8B8686),
                            ),
                          ),
                        ),
                        Text(
                          '$Times Times this month',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff8B8686),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        ImageAssets[index],
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
