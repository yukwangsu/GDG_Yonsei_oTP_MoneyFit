import 'package:flutter/material.dart';
import 'package:flutter_financemanager/services/goal_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_goal.dart';
import 'package:flutter_financemanager/widgets/badge_widget.dart';
import 'package:flutter_financemanager/widgets/goal_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  bool showBadgeMore = false; // 업적 배지 더보기 저장 변수

  @override
  void initState() {
    super.initState();

    // 현재 날짜 가져오기(한국 날짜)
    DateTime nowInKorea = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 날짜를 원하는 형식으로 포맷팅
    String formattedDate = DateFormat('yyyy-MM').format(nowInKorea);
    // GoalService.getGoalService(formattedDate);
  }

  // 업적 배지 더보기를 눌렀을 때
  void showBadgeMode() {
    setState(() {
      showBadgeMore = !showBadgeMore;
    });
  }

  List<Map<String, dynamic>> goals = [
    {
      'title': '목표 1',
      'description': '식비 지출',
      'goal': 800000,
      'progress': 854000,
    },
    {
      'title': '목표 2',
      'description': '쇼핑 지출',
      'goal': 600000,
      'progress': 200000,
    },
    {
      'title': '목표 3',
      'description': '간식 비용',
      'goal': 200000,
      'progress': 157000,
    },
  ];

  void _updateGoalAmount(int index, int newGoal) {
    setState(() {
      goals[index]['goal'] = newGoal;
    });
  }

  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void _showEditAmountDialog(BuildContext context, int index) {
    final TextEditingController controller = TextEditingController(
      text: goals[index]['goal'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '목표 금액 수정',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '새 목표 금액 입력',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFd9d9d9),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      final int? newGoal = int.tryParse(controller.text);
                      if (newGoal != null) {
                        _updateGoalAmount(index, newGoal);
                      }
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFd2e0fb),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('확인'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '삭제 확인',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '정말 삭제하시겠습니까?',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업창 닫기
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFd9d9d9),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('아니요'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 팝업창 닫기
                      _deleteGoal(index); // 삭제 수행
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFd2e0fb),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('예'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
            // Home 글자
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                children: [
                  Text(
                    'Goal',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 27.0,
            ),

            // 1. 업적 배지
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                // height: 366,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F7),
                  borderRadius: BorderRadius.circular(29.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 업적 배지 텍스트, 더보기
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, right: 21.0, left: 27.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '업적 배지',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // 더보기 버튼
                          showBadgeModeButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13.0),
                    // 배지들
                    Column(
                      children: [
                        Wrap(
                          spacing: 15.0,
                          runSpacing: 15.0,
                          children: [
                            for (int i = 0;
                                i < (showBadgeMore ? badgeList.length : 4);
                                i++)
                              BadgeWidget(
                                title: badgeList[i]['title']!,
                                description: badgeList[i]['description']!,
                                achieved: true,
                                image: badgeList[i]['image']!,
                                whiteImage: badgeList[i]['whiteImage']!,
                              )
                          ],
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

            const SizedBox(
              height: 27.0,
            ),

            // 2. 이번 달 목표
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F7),
                  borderRadius: BorderRadius.circular(29.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, right: 21.0, left: 27.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '이번 달 목표',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          addGoalButton(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 13.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        children: List.generate(goals.length, (index) {
                          final goal = goals[index];
                          return GoalWidget(
                            title: goal['title'],
                            description: goal['description'],
                            progress: goal['progress'],
                            goal: goal['goal'],
                            onDelete: () => _showDeleteDialog(context, index),
                            onEdit: () => _showEditAmountDialog(context, index),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
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

  Widget showBadgeModeButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showBadgeMode();
      },
      child: Row(
        children: [
          Text(
            showBadgeMore ? '간략히 보기' : '더보기',
            style: const TextStyle(
              fontSize: 13.0,
              color: Color(0xFF687D94),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF687D94), // 밑줄 색상 설정
            ),
          ),
          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    );
  }

  Widget addGoalButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        var addGoalResult = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AddGoal();
          },
        );
        if (addGoalResult != null && addGoalResult) {
          // 목표를 추가했으므로 반영
          print('목표 추가 성공!!!');
          setState(() {
            // 목표 불러오기
            // recentSpendingHistory = SpendingService.getSpending();
          });
        }
      },
      child: Row(
        children: [
          const Text(
            '목표 추가하기',
            style: TextStyle(
              fontSize: 13.0,
              color: Color(0xFF687D94),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF687D94), // 밑줄 색상 설정
            ),
          ),
          SvgPicture.asset('assets/icons/arrow_right.svg'),
        ],
      ),
    );
  }
}
