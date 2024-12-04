import 'package:flutter/material.dart';
import 'package:flutter_financemanager/services/game_service.dart';

class AttendanceWidget extends StatelessWidget {
  final String day;
  final int point;
  final bool checked;
  final bool isCheckable;
  final Function onClickAttendance;

  const AttendanceWidget({
    super.key,
    required this.day,
    required this.point,
    required this.checked,
    required this.isCheckable,
    required this.onClickAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 오늘 유효한 출석체크를 했을 경우 -> 포인트 지급
        if (isCheckable) {
          onClickAttendance();
        }
      },
      child: Container(
        width: 55.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: checked ? const Color(0xFFD2E0FB) : const Color(0xFFF2F4F7),
          border: Border.all(
            width: isCheckable ? 3.0 : 2.0,
            color:
                isCheckable ? const Color(0xFF72A2FF) : const Color(0xFFD2E0FB),
          ),
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [
            if (isCheckable)
              BoxShadow(
                color: Colors.black.withOpacity(0.7), // 그림자 색상
                blurRadius: 5.0, // 흐림 정도
                offset: const Offset(0, 3), // 그림자의 위치 (x, y)
              ),
          ],
        ),
        child: Stack(
          children: [
            // 체크 된 경우 투명도를 올림
            Opacity(
              opacity: checked ? 0.3 : 1.0,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  // n일차 연속
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  // 보상 금액
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
      ),
    );
  }
}
