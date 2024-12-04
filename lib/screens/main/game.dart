import 'package:flutter/material.dart';
import 'package:flutter_financemanager/models/check_attendance.dart';
import 'package:flutter_financemanager/services/game_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/attendance_widget.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int weekday = DateTime.now()
      .toUtc()
      .add(const Duration(hours: 9))
      .weekday; // 오늘 요일 가져오기
  late Future<int> userPoint; // 보유 포인트 저장
  // late Future<int> consecutiveDays; // 연속 출석일 저장
  late Future<CheckAttendanceModel> checkAttendance;
  bool isGachaAvailable = false; // 뽑기가 가능한지 저장
  bool isWaitingGachaResult = false; // 뽑기 결과를 기다리는지 저장
  final int gachaCost = 1000; // 뽑기 비용
  String mode =
      'intro'; // intro: 처음 화면, gacha: 뽑기 화면, fail: 실패 화면, success: 성공 화면

  // 선물상자 흔들거리는 효과
  late AnimationController _controller;
  late Animation<double> _animation;

  // 출석체크 버튼을 눌렀을 경우
  _onClickAttendanceButton() async {
    await GameService.attendance(); // 포인트 지급 요청
    setState(() {
      // 출석 정보 다시 불러오기
      checkAttendance = GameService.checkFirstAttendance();
      // 현재 보유하고 있는 포인트를 가져오고 뽑기 가능여부를 판단
      checkPointAndGacha();
    });
  }

  @override
  void initState() {
    super.initState();

    // 현재 보유하고 있는 포인트를 가져오고 뽑기 가능여부를 판단
    checkPointAndGacha();

    // 오늘 첫 출석인지 확인
    checkAttendance = GameService.checkFirstAttendance();

    // 선물상자 흔들거리는 효과
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000), // 흔들림 애니메이션의 지속 시간
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 0.9),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 0.9),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 0.9),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 0.0), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -14.0), weight: 0.7),
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 14.0), weight: 0.7),
      TweenSequenceItem(tween: Tween(begin: 14.0, end: 0.0), weight: 0.7),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -16.0), weight: 0.6),
      TweenSequenceItem(tween: Tween(begin: -16.0, end: 16.0), weight: 0.6),
      TweenSequenceItem(tween: Tween(begin: 16.0, end: 0.0), weight: 0.6),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.4),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.4),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.4),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: -18.0, end: 18.0), weight: 0.2),
      TweenSequenceItem(tween: Tween(begin: 18.0, end: 0.0), weight: 0.2),
    ]).animate(_controller);
  }

  // 현재 보유하고 있는 포인트를 가져오고 뽑기 가능여부를 판단
  void checkPointAndGacha() async {
    // 보유 포인트 불러오기
    int resultPoint = await checkPoint();
    setState(() {
      // 뽑기 가능 여부 판단
      isGachaAvailable = resultPoint >= gachaCost ? true : false;
    });
  }

  // 보유 포인트를 불러와서 반환
  Future<int> checkPoint() async {
    userPoint = GameService.getLeftPoint();
    return userPoint;
  }

  // 뽑기 시작 버튼을 눌렀을 때
  void onClickGachaStartButton() {
    setState(() {
      // 화면 모드 변경
      mode = 'gacha';
    });
  }

  // 뽑기 상자를 선택했을 때
  void selectGachaBox(int number) async {
// 상자 흔들거리는 화면 보여주기 시작
    setState(() {
      mode = 'waitingGachaResult';
    });

    // 뽑기 api호출
    bool resultGacha = await GameService.gachaService();

    if (resultGacha) {
      // 당첨된 경우 1초 뒤에 결과 보여줌
      await Future.delayed(const Duration(seconds: 1));
    } else {
      // 당첨이 아닌 경우 결과를 3초 뒤에 보여줌
      await Future.delayed(const Duration(seconds: 3));
    }

    // 다음 뽑기 가능한지 확인, 보유 포인트 다시 불러옴
    checkPointAndGacha();

    // 뽑기 결과 처리
    if (resultGacha) {
      // 당첨됐을 경우
      print('당첨!!!');
      setState(() {
        mode = 'gacha_success';
      });
    } else {
      // 실패했을 경우
      print('실패ㅠㅠㅠ');
      setState(() {
        mode = 'gacha_fail';
      });
    }
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
      body: SingleChildScrollView(
        child: Column(
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
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
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

                      FutureBuilder(
                        future: userPoint,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // 데이터가 로드 중일 때 로딩 표시
                            return const Text(
                              ' P',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // 오류가 발생했을 때
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // 불러온 데이터 저장하기
                            final int resultUserPoint = snapshot.data!;
                            return GestureDetector(
                              onDoubleTap: () async {
                                // 1000포인트 증가(테스트용)
                                await GameService.addPoint();
                                checkPointAndGacha();
                              },
                              child: Text(
                                '${formatCurrency(resultUserPoint)} P',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                        },
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
                          const Text(
                            '200',
                            style: TextStyle(
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      // 요일별 출석

                      FutureBuilder(
                        future: checkAttendance,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // 데이터가 로드 중일 때 로딩 표시
                            return const SizedBox(
                              height: 60.0,
                            );
                          } else if (snapshot.hasError) {
                            // 오류가 발생했을 때
                            return SizedBox(
                              height: 60.0,
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            // 불러온 데이터 저장하기
                            final CheckAttendanceModel checkAttendanceResult =
                                snapshot.data!;

                            // 이전에 5일 연속 출석했고 오늘(출석 6일차) 보상을 안 받았을 때
                            if (checkAttendanceResult.doesGetPointsToday ==
                                    false &&
                                checkAttendanceResult
                                        .consecutiveDaysBeforeGetAttendancePoints ==
                                    5) {
                              // 오늘이 몇 번째 칸인지 저장
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    AttendanceWidget(
                                      // // weekday + i 가 7보다 클 경우 -7을 해줌.
                                      // day: dayText[(weekday + i) > 7
                                      //     ? weekday + i - 7
                                      //     : weekday + i]!,
                                      day: '${i + 1}일차',
                                      point: attendanceReward[i + 1]!,
                                      checked: false, // 5일 출석을 다 했기 때문에 모두 체크 X
                                      isCheckable: (i == 0),
                                      onClickAttendance:
                                          _onClickAttendanceButton,
                                    )
                                ],
                              );
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    AttendanceWidget(
                                      // // weekday + i 가 7보다 클 경우 -7을 해줌.
                                      // day: dayText[(weekday + i) > 7
                                      //     ? weekday + i - 7
                                      //     : weekday + i]!,
                                      day: '${i + 1}일차',
                                      point: attendanceReward[i + 1]!,
                                      checked: i + 1 <=
                                              checkAttendanceResult
                                                  .consecutiveDaysBeforeGetAttendancePoints
                                          ? true
                                          : false,
                                      isCheckable: (!checkAttendanceResult
                                              .doesGetPointsToday &&
                                          i ==
                                              checkAttendanceResult
                                                  .consecutiveDaysBeforeGetAttendancePoints),
                                      onClickAttendance:
                                          _onClickAttendanceButton,
                                    )
                                ],
                              );
                            }
                          }
                        },
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
              height: 15.0,
            ),

            // 2. Game 화면 내용 - 선물 뽑기
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29.2),
                  color: const Color(0xFFF2F4F7),
                ),
                child: mode == 'intro'
                    ? gachaIntro()
                    : mode == 'gacha'
                        ? gacha()
                        : mode == 'gacha_success'
                            ? gachaSuccess()
                            : mode == 'gacha_fail'
                                ? gachaFail()
                                : gachaWaitingResult(),
              ),
            ),

            const SizedBox(
              height: 27.0,
            ),
          ],
        ),
      ),
    );
  }

  // 1. intro 화면
  Widget gachaIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 22.0,
        ),
        // 텍스트
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/point_icon.png'),
            const SizedBox(
              width: 3.0,
            ),
            Text(
              '$gachaCost 사용해서 선물 뽑고',
              style: const TextStyle(
                fontSize: 13.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          '기프티콘 받기',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13.0),
        // 선물 상자
        Image.asset('assets/images/gacha_intro_icon.png'),
        const SizedBox(height: 13.0),
        // 뽑기 버튼
        gachaButton('게임 시작하기'),
        const SizedBox(
          height: 22.0,
        ),
      ],
    );
  }

  // 2. gacha 화면
  Widget gacha() {
    return Stack(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 22.0,
              ),
              // 텍스트
              const Text(
                '오늘의 행운을 상상하며',
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                '선물을 뽑아주세요!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30.0),
              // 뽑기 상자
              Wrap(
                spacing: 25.0,
                children: [
                  for (int i = 0; i < 3; i++)
                    GestureDetector(
                      onTap: () {
                        // // 이미 박스를 선택하지 않았을 경우에만 인식
                        // if (!isWaitingGachaResult) {
                        //   selectGachaBox(i);
                        // }
                        selectGachaBox(i);
                      },
                      child: Image.asset('assets/images/gacha_box.png'),
                    ),
                ],
              ),
              const SizedBox(height: 30.0),
              Wrap(
                spacing: 28.0,
                children: [
                  for (int i = 3; i < 5; i++)
                    GestureDetector(
                      onTap: () {
                        // // 이미 박스를 선택하지 않았을 경우에만 인식
                        // if (!isWaitingGachaResult) {
                        //   selectGachaBox(i);
                        // }
                        selectGachaBox(i);
                      },
                      child: Image.asset('assets/images/gacha_box.png'),
                    ),
                ],
              ),
            ],
          ),
        ),

        // // 뽑기 결과를 기다릴 때
        // if (isWaitingGachaResult)
        //   Container(
        //     child: const Center(child: CircularProgressIndicator()),
        //   ),
      ],
    );
  }

  // 3. 뽑기 성공 화면
  Widget gachaSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        // 텍스트
        const Text(
          '\u{1F389} 당첨!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          '이메일로 3~5일 이내에 기프티콘 발송해드릴게요!',
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
        const SizedBox(height: 13.0),
        // 선물 상자
        Stack(
          children: [
            // 효과 1
            Positioned(
                top: 5.0,
                left: 15.0,
                child: Image.asset('assets/images/gacha_success_effect.png')),
            // 효과 2
            Positioned(
                bottom: 10.0,
                right: 20.0,
                child: Image.asset('assets/images/gacha_success_effect.png')),
            // 사진
            SizedBox(
                height: 185.0,
                width: 280.0,
                child: Image.asset('assets/images/gacha_success.png')),
          ],
        ),
        const SizedBox(height: 10.0),
        // 뽑기 버튼
        gachaButton('이어서 게임하기'),
      ],
    );
  }

  // 4. 뽑기 실패 화면
  Widget gachaFail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        // 텍스트
        const Text(
          '이번에는 아쉽게도 꽝..',
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          '다시 도전해보세요!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13.0),
        // 선물 상자
        Image.asset('assets/images/gacha_fail.png'),
        const SizedBox(height: 10.0),
        // 뽑기 버튼
        gachaButton('이어서 게임하기'),
      ],
    );
  }

  // 5. 뽑기 결과 대기 화면(상자가 흔들거리는 효과)
  Widget gachaWaitingResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        // 텍스트
        const Text(
          '두구두구두구',
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        const Text(
          '결과 대기 중..',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13.0),
        // 선물 상자
        _buildGachaBox(),
      ],
    );
  }

  // 뽑기 시작 버튼
  Widget gachaButton(String content) {
    return Opacity(
      opacity: isGachaAvailable ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: () {
          if (isGachaAvailable) {
            onClickGachaStartButton();
          } else {
            // 보유 포인트 부족
          }
        },
        child: Container(
          width: 216.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: const Color(0xFFD6E2FA),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // 그림자 색상
                blurRadius: 5.0, // 흐림 정도
                offset: const Offset(0, 2), // 그림자의 위치 (x, y)
              ),
            ],
          ),
          child: Center(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFF565555),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 뽑기 상자 위젯
  Widget _buildGachaBox() {
    _controller.reset();
    _controller.forward();
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0), // X축으로 흔들림 효과
          child: child,
        );
      },
      child: SizedBox(
          height: 185.0,
          width: 280.0,
          child: Image.asset('assets/images/gacha_success.png')),
    );
  }
}
