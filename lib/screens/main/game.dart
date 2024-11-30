import 'package:flutter/material.dart';
import 'package:flutter_financemanager/services/game_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/attendance_widget.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int weekday = DateTime.now()
      .toUtc()
      .add(const Duration(hours: 9))
      .weekday; // 오늘 요일 가져오기

  // 추후 삭제
  // int rewardForFiveDays = -1; // 5일 연속 출석 최대 보상 저장
  int myPoint = 3632; // 나의 포인트
  final int gachaCost = 1000; // 뽑기 비용
  final int prizeBoxChance = 2; // 당첨 박스가 존재할 확률(2 -> 1/2)
  bool isPrizeBoxPresent = false; // 당첨 박스 존재 유무
  int prizeBoxId = -1; // 당첨 상자 번호
  bool isGachaAvailable = false; // 뽑기가 가능한지
  //

  String mode =
      'intro'; // intro: 처음 화면, gacha: 뽑기 화면, fail: 실패 화면, success: 성공 화면

  @override
  void initState() {
    super.initState();

    // 추후 삭제
    // initRewardForFiveDays();
    checkGachaAvailable();
    initPrizeBoxPresent();
    //

    // 보유 포인트 불러오기
    // GameService.getLeftPoint();

    // 출석 포인트 증정
    // GameService.attendance();

    // 뽑기
    // GameService.gachaService();

    // 포인트 증가
    // GameService.addPoint();
  }

  // void initRewardForFiveDays() {
  //   setState(() {
  //     for (int i = 0; i < 5; i++) {
  //       rewardForFiveDays += attendanceReward[
  //           (weekday + i) > 7 ? weekday + i - 7 : weekday + i]!;
  //     }
  //   });
  // }

  void checkGachaAvailable() async {
    // 보유 포인트 불러오기
    // myPoint = 3632; // 임시
    if (myPoint >= gachaCost) {
      setState(() {
        isGachaAvailable = true;
      });
    } else {
      setState(() {
        isGachaAvailable = false;
      });
    }
  }

  // 당첨 박스 존재 유무 설정
  void initPrizeBoxPresent() {
    isPrizeBoxPresent = Random().nextInt(prizeBoxChance) == 0;
  }

  // 뽑기 시작 버튼을 눌렀을 때
  void onClickGachaStartButton() {
    setState(() {
      // 화면 모드 변경
      mode = 'gacha';
      // 확률
      if (isPrizeBoxPresent) {
        // 당첨 박스가 존재할 경우
        prizeBoxId = Random().nextInt(5);
      } else {
        // 당첨 박스가 존재하지 않을 경우
        prizeBoxId = -1;
      }
      // 정답
      print('당첨 박스 존재 유무: $isPrizeBoxPresent');
      print('당첨 박스 번호: $prizeBoxId');
      // 당첨 박스 존재 유무 초기화
      initPrizeBoxPresent();
    });
  }

  // 뽑기 상자를 선택했을 때
  void selectGachaBox(int number) {
    // 뽑기 비용 차감(추후 api로 대체)
    myPoint -= gachaCost;
    // 다음 뽑기 가능한지 확인
    checkGachaAvailable();
    if (number == prizeBoxId) {
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
                      Text(
                        '$myPoint P',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 5; i++)
                            AttendanceWidget(
                              // weekday + i 가 7보다 클 경우 -7을 해줌.
                              day: dayText[(weekday + i) > 7
                                  ? weekday + i - 7
                                  : weekday + i]!,
                              // point: attendanceReward[(weekday + i) > 7
                              //     ? weekday + i - 7
                              //     : weekday + i]!,
                              point: attendanceReward[i + 1]!,
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
                            : gachaFail(),
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
    return Column(
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
                  selectGachaBox(i);
                },
                child: Image.asset('assets/images/gacha_box.png'),
              ),
          ],
        ),
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
}
