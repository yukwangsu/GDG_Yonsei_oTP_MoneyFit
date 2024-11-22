import 'package:flutter/material.dart';
import './widgets/goal_widget.dart';
import './widgets/badge_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GoalScreen(),
    );
  }
}

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
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

  List<Map<String, dynamic>> badges = [
    {
      'title': '배지 1',
      'achieved': true,
      'description': '회원가입 완료!',
      'image': 'assets/images/fire.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 2',
      'achieved': true,
      'description': '친구 3명에게 공유하기 완료!',
      'image': 'assets/images/megaphone.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 3',
      'achieved': true,
      'description': '첫 목표 추가 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 4',
      'achieved': false,
      'description': '첫 목표 달성 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 5',
      'achieved': false,
      'description': '첫 뽑기 시도 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 6',
      'achieved': false,
      'description': '첫 뽑기 성공 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 7',
      'achieved': false,
      'description': '11월 목표 달성 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
    },
    {
      'title': '배지 8',
      'achieved': false,
      'description': '2개월 연속 목표 달성 완료!',
      'image': 'assets/images/target.png',
      'whiteImage': 'assets/images/whitemedal.png',
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
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Goal',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 366,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F7),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '업적 배지',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // 더보기 버튼
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                const Text(
                                  '더보기',
                                  style: TextStyle(
                                    color: Color(0xff687d94),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xff687d94),
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/arrow-right.png',
                                  width: 12,
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BadgeWidget(
                                  title: badges[0]['title'],
                                  description: badges[0]['description'],
                                  achieved: badges[0]['achieved'],
                                  image: badges[0]['image'],
                                  whiteImage: badges[0]['whiteImage']),
                              const SizedBox(width: 10),
                              BadgeWidget(
                                  title: badges[1]['title'],
                                  description: badges[1]['description'],
                                  achieved: badges[1]['achieved'],
                                  image: badges[1]['image'],
                                  whiteImage: badges[1]['whiteImage']),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BadgeWidget(
                                  title: badges[2]['title'],
                                  description: badges[2]['description'],
                                  achieved: badges[2]['achieved'],
                                  image: badges[2]['image'],
                                  whiteImage: badges[2]['whiteImage']),
                              const SizedBox(width: 10),
                              BadgeWidget(
                                  title: badges[3]['title'],
                                  description: badges[3]['description'],
                                  achieved: badges[3]['achieved'],
                                  image: badges[3]['image'],
                                  whiteImage: badges[3]['whiteImage']),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3F7),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            const Text(
                              '이번 달 목표',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const Text(
                                    '목표 추가하기',
                                    style: TextStyle(
                                      color: Color(0xff687d94),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xff687d94),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/arrow-right.png',
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
