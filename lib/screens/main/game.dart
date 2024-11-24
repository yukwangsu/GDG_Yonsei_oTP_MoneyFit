import 'package:flutter/material.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/attendance_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int weekday = DateTime.now().weekday;

  @override
  void initState() {
    super.initState();
  }

  String formatCurrency(int amount) {
    String amountStr = amount.toString();
    StringBuffer result = StringBuffer();

    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      result.write(amountStr[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        result.write(',');
      }
    }
    return result.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 최상단 빈 공간
          const SizedBox(
            height: 45.0,
          ),
          // game 글자
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Row(
              children: [
                Text(
                  'Game',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 27.0,
          ),

          // 1. Game 화면 내용 - 포인트, 출석체크
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(29.2),
                color: const Color(0xFFF2F4F7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 텍스트
                    const Padding(
                      padding: EdgeInsets.only(top: 18.0),
                      child: Text(
                        '나의 포인트',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    // 보유 포인트
                    Text(
                      '${formatCurrency(3632)} P',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    // 연속 출석 안내 문구
                    Row(
                      children: [
                        const Text(
                          '5일 연속 출석하면 최대',
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Image.asset('assets/images/point_icon.png'),
                        const SizedBox(
                          width: 3.0,
                        ),
                        const Text(' '),
                      ],
                    ),
                    const SizedBox(
                      height: 14.0,
                    ),
                    // 요일별 출석
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 5; i++)
                          AttendanceWidget(
                            // weekday + i 가 7보다 클 경우 -7을 해줌.
                            day: dayText[(weekday + i) > 7
                                ? weekday + i - 7
                                : weekday + i]!,
                            point: attendanceReward[(weekday + i) > 7
                                ? weekday + i - 7
                                : weekday + i]!,
                            checked: i == 0 ? true : false,
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 27.0,
          ),
        ],
      ),
    );
  }
}
