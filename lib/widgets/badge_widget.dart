import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool achieved;
  final String image;
  final String whiteImage;

  const BadgeWidget({
    super.key,
    required this.title,
    required this.description,
    required this.achieved,
    required this.image,
    required this.whiteImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: achieved ? Colors.white : const Color(0xFFf3f4f7),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 7.0),
            child: Text(
              title,
              style: TextStyle(
                color: achieved ? Colors.black : const Color(0xFF9fa9b3),
                fontSize: 12,
              ),
            ),
          ),
          Image.asset(
            achieved ? image : whiteImage,
            height: 80,
            width: 80,
          ),
          Text(
            description,
            style: TextStyle(
              color: achieved ? Colors.black : const Color(0xFF9fa9b3),
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}
