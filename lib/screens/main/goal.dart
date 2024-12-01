import 'package:flutter/material.dart';
import 'package:flutter_financemanager/models/badge_model.dart';
import 'package:flutter_financemanager/models/goal_model.dart';
import 'package:flutter_financemanager/services/goal_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_goal.dart';
import 'package:flutter_financemanager/widgets/ask_delete_goal.dart';
import 'package:flutter_financemanager/widgets/badge_widget.dart';
import 'package:flutter_financemanager/widgets/edit_goal.dart';
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
  late Future<BadgeListModel> earnedBadgeList; // 획득한 배지들 저장하는 변수
  late Future<GoalListModel> goalList; // 목표들 저장하는 변수

  @override
  void initState() {
    super.initState();

    // 현재 날짜 가져오기(한국 날짜)
    DateTime nowInKorea = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 날짜를 원하는 형식으로 포맷팅
    String formattedDate = DateFormat('yyyy-MM').format(nowInKorea);

    // 목표 불러오기
    goalList = GoalService.getGoalService(formattedDate);

    // 획득한 배지 불러오기
    earnedBadgeList = GoalService.getBadgeService();
  }

  // 목표 다시 불러오는 함수
  void _reloadGoal() async {
    // 현재 날짜 가져오기(한국 날짜)
    DateTime nowInKorea = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 날짜를 원하는 형식으로 포맷팅
    String formattedDate = DateFormat('yyyy-MM').format(nowInKorea);
    setState(() {
      goalList = GoalService.getGoalService(formattedDate);
    });
  }

  // 업적 배지 더보기를 눌렀을 때
  void showBadgeMode() {
    setState(() {
      showBadgeMore = !showBadgeMore;
    });
  }

  // 휴지통을 눌렀을 경우
  _onClickdeleteGoalButton(int id) async {
    // 삭제할건지 다시 한 번 물어보는 창 띄움
    final deleteGoalResult = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskDeleteGoal(id: id);
      },
    );
    // 삭제를 눌렀을 경우
    if (deleteGoalResult != null && deleteGoalResult) {
      // 목표를 다시 불러옴
      _reloadGoal();
    }
  }

  // 금액 수정을 눌렀을 경우
  _onClickEditGoalButton(int id) async {
    // 목표 금액을 수정하는 창 띄움
    final deleteGoalResult = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditGoal(id: id);
      },
    );
    // 변경을 눌렀을 경우
    if (deleteGoalResult != null && deleteGoalResult) {
      // 목표를 다시 불러옴
      _reloadGoal();
    }
  }

  // List<Map<String, dynamic>> goals = [
  //   {
  //     'title': '목표 1',
  //     'description': '식비 지출',
  //     'goal': 800000,
  //     'progress': 854000,
  //   },
  //   {
  //     'title': '목표 2',
  //     'description': '쇼핑 지출',
  //     'goal': 600000,
  //     'progress': 200000,
  //   },
  //   {
  //     'title': '목표 3',
  //     'description': '간식 비용',
  //     'goal': 200000,
  //     'progress': 157000,
  //   },
  // ];

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
                    FutureBuilder(
                        future: earnedBadgeList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // 데이터가 로드 중일 때 로딩 표시
                            return const SizedBox(
                              height: 295.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // 오류가 발생했을 때
                            return SizedBox(
                                height: 295.0,
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            // 불러온 데이터 저장하기
                            final List<BadgeModel> resultEarnedBadgeList =
                                snapshot.data!.badgeList;
                            final List<String> resultEarnedBadgeTypeList = [];
                            // 불러온 데이터 중 획득한 배지 이름(type)만 리스트에 저장
                            for (int i = 0;
                                i < resultEarnedBadgeList.length;
                                i++) {
                              resultEarnedBadgeTypeList
                                  .add(resultEarnedBadgeList[i].badgeType);
                            }
                            return Column(
                              children: [
                                Wrap(
                                  spacing: 15.0,
                                  runSpacing: 15.0,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (showBadgeMore
                                                ? badgeList.length
                                                : 4);
                                        i++)
                                      BadgeWidget(
                                        title: badgeList[i]['title']!,
                                        description: badgeList[i]
                                            ['description']!,
                                        achieved: resultEarnedBadgeTypeList
                                                .contains(badgeList[i]['name'])
                                            ? true
                                            : false,
                                        image: badgeList[i]['image']!,
                                        whiteImage: badgeList[i]['whiteImage']!,
                                      )
                                  ],
                                )
                              ],
                            );
                          }
                        }),
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
                        child:
                            // 목표들
                            FutureBuilder(
                          future: goalList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 데이터가 로드 중일 때 로딩 표시
                              return const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              // 오류가 발생했을 때
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // 불러온 데이터 저장하기
                              final List<GoalModel> resultGoalList =
                                  snapshot.data!.goalList;
                              // 목표 index
                              int goalIndex = 1;
                              return Column(children: [
                                ...resultGoalList.map((goal) {
                                  return GoalWidget(
                                    index: goalIndex++,
                                    category: upperToCategoryMap[
                                        goal.upperCategoryType]!,
                                    spentAmount: goal.spentAmount,
                                    targetSpendingAmount: goal.expenseLimit,
                                    onDelete: () {
                                      _onClickdeleteGoalButton(goal.id);
                                    },
                                    onEdit: () {
                                      _onClickEditGoalButton(goal.id);
                                    },
                                  );
                                })
                              ]);
                            }
                          },
                        ),
                      ),
                    ]),
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

  // 배지 더보기-간략히보기 버튼
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

  // 목표 추가 버튼
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
          // 목표를 다시 불러옴
          _reloadGoal();
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
