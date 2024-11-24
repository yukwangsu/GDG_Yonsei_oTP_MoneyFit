import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  final String day;
  final int point;
  final bool checked;

  const AttendanceWidget({
    super.key,
    required this.day,
    required this.point,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.0,
      height: 60.0,
      decoration: BoxDecoration(
        color: checked ? const Color(0xFFD2E0FB) : null,
        border: Border.all(
          width: 2.0,
          color: const Color(0xFFD2E0FB),
        ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Stack(
        children: [
          // 체크 된 경우 투명도를 올림
          Opacity(
            opacity: checked ? 0.3 : 1.0,
            child: Column(
              children: [
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/point_icon.png',
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      point.toString(),
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 체크 표시
          if (checked)
            Positioned(
              top: 12.0,
              left: 7.0,
              child: Image.asset('assets/images/attendance_check_icon.png'),
            )
        ],
      ),
    );
  }
}
