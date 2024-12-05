import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_financemanager/models/category_expenditure.dart';
import 'package:flutter_financemanager/models/comparison_model.dart';
import 'package:flutter_financemanager/models/expenditure_model.dart';
import 'package:flutter_financemanager/models/pie_chart_model.dart';
import 'package:flutter_financemanager/services/game_service.dart';
import 'package:flutter_financemanager/services/notification_service.dart';
import 'package:flutter_financemanager/services/spending_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_expenditure.dart';
import 'package:flutter_financemanager/widgets/edit_comparison_category.dart';
import 'package:flutter_financemanager/widgets/list_border_line.dart';
import 'package:flutter_financemanager/widgets/pie_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 최대 legend 개수
  final int _maxLegendTotalExpenditure = 4;
  // 비교 연령 기본값
  String comparisonTargetAge = '20대';
  // 비교 성별 기본값
  String comparisonTargetGender = '여성';
  // 비교 카테고리 리스트 기본값
  List<String> comparisonCategoryList = [];
  // 최근 지출 저장
  late Future<ExpenditureListModel> recentSpendingHistory;
  // 이번달 카테고리 별 지출 총합 저장
  late Future<CategoryExpenditureListModel> monthlyCategoryExpenditure;
  // 이번달 지출 저장
  int thisMonthTotalSpending = -1;
  // 저번달 지출 저장
  int lastMonthTotalSpending = -1;
  // 이번달과 저번달의 지출 차이
  int expenseDifferenceThisAndLastMonth = 0;

  @override
  void initState() {
    super.initState();

    _requestNotificationPermissions(); // 알림 권한 요청

    // 이번달, 저번달 지출 불러오기
    _getMonthlySpending();

    // 카테고리별 이번달 지출 불러오기
    _getCategoryMonthlySpending();

    // 최근 지출 불러오기
    recentSpendingHistory = SpendingService.getSpending();

    // 지출 비교 카테고리, 나이, 성별 가져오기
    _initPrefs();

    // // 출석 처리
    // GameService.attendance();
  }

  void _requestNotificationPermissions() async {
    //알림 권한 요청
    final status = await NotificationService().requestNotificationPermissions();
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

  // 이번달, 저번달 지출 불러오는 함수
  void _getMonthlySpending() async {
    // 현재 날짜 가져오기(한국 날짜)
    DateTime nowInKorea = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 날짜를 원하는 형식으로 포맷팅
    String year = DateFormat('yyyy').format(nowInKorea);
    String month = DateFormat('MM').format(nowInKorea);
    // 저번 달 계산
    DateTime lastMonthInKorea = DateTime(nowInKorea.year, nowInKorea.month - 1);
    // 저번 달을 원하는 형식으로 포맷팅
    String lastMonthYear = DateFormat('yyyy').format(lastMonthInKorea);
    String lastMonth = DateFormat('MM').format(lastMonthInKorea);

    int thisMonthTotalSpendingTemp =
        await SpendingService.getMonthlySpending(year, month);
    int lastMonthTotalSpendingTemp =
        await SpendingService.getMonthlySpending(lastMonthYear, lastMonth);
    setState(() {
      thisMonthTotalSpending = thisMonthTotalSpendingTemp;
      lastMonthTotalSpending = lastMonthTotalSpendingTemp;
      expenseDifferenceThisAndLastMonth =
          lastMonthTotalSpending - thisMonthTotalSpending;
    });
  }

  // 이번달 카테고리 별 지출 불러오는 함수
  void _getCategoryMonthlySpending() {
    // 현재 날짜 가져오기(한국 날짜)
    DateTime nowInKorea = DateTime.now().toUtc().add(const Duration(hours: 9));
    // 날짜를 원하는 형식으로 포맷팅
    String year = DateFormat('yyyy').format(nowInKorea);
    String month = DateFormat('MM').format(nowInKorea);

    setState(() {
      monthlyCategoryExpenditure =
          SpendingService.getCategoryMonthlySpending(year, month);
    });
  }

  // 비교할 카테고리 가져오기
  void _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // 카테고리
    final prefsCategoryResult = prefs.getStringList('comparisonCategoryList');
    if (prefsCategoryResult == null) {
      setState(() {
        prefs.setStringList('comparisonCategoryList', ['식비', '주거', '이동']);
        comparisonCategoryList = ['식비', '주거', '이동'];
      });
    } else {
      setState(() {
        comparisonCategoryList = prefs.getStringList('comparisonCategoryList')!;
      });
    }
    // 나이
    final prefsAgeResult = prefs.getString('comparisonTargetAge');
    if (prefsAgeResult == null) {
      setState(() {
        prefs.setString('comparisonTargetAge', '20대');
        comparisonTargetAge = '20대';
      });
    } else {
      setState(() {
        comparisonTargetAge = prefs.getString('comparisonTargetAge')!;
      });
    }
    // 성별
    final prefsGenderResult = prefs.getString('comparisonTargetGender');
    if (prefsGenderResult == null) {
      setState(() {
        prefs.setString('comparisonTargetGender', '여성');
        comparisonTargetGender = '여성';
      });
    } else {
      setState(() {
        comparisonTargetGender = prefs.getString('comparisonTargetGender')!;
      });
    }
  }

  // 비교할 카테고리 수정하기
  void _editCategoryPrefs(List<String> selectedCategory) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setStringList('comparisonCategoryList', selectedCategory);
      comparisonCategoryList = selectedCategory;
    });
  }

  // 비교할 나이 수정하기
  void _editAgePrefs(String selectedAge) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('comparisonTargetAge', selectedAge);
      comparisonTargetAge = selectedAge;
    });
  }

  // 비교할 성별 수정하기
  void _editGenderPrefs(String selectedGender) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('comparisonTargetGender', selectedGender);
      comparisonTargetGender = selectedGender;
    });
  }

  int setAgeRange(String age) {
    if (age == '10대' || age == '20대' || age == '30대') {
      return 30;
    } else if (age == '40대') {
      return 40;
    } else if (age == '50대') {
      return 50;
    } else {
      return 60;
    }
  }

  List<int> setPieChartCount(List<CategoryExpenditureModel> list) {
    int spendSum = 0;
    int countSum = 0;
    List<int> countList = [];
    for (int i = 0; i < list.length; i++) {
      spendSum += list[i].totalExpense;
    }
    if (spendSum > 0) {
      for (int i = 0; i < list.length; i++) {
        countList.add((list[i].totalExpense / spendSum * 100).floor());
      }
    }
    for (int i = 0; i < countList.length; i++) {
      countSum += countList[i];
    }
    if (countList.isEmpty) {
      // 지출이 없을 경우 default값 하나를 넣어줌
      countList.add(100);
    } else {
      if (countSum < 100) {
        // 지출이 있는데 countList의 합이 100이 아닌 경우
        countList[0] += 100 - countSum;
      }
    }
    return countList;
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
                    'Home',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 27.0,
            ),

            // 1. Home 화면 내용 - 총 지출
            Padding(
              padding: const EdgeInsets.only(right: 11.0, left: 20.0),
              child: SizedBox(
                height: 235.0,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // 총 지출 분석
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0, right: 9.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          border: Border.all(
                              width: 1.0, color: const Color(0xFFF2F4F7)),
                          borderRadius: BorderRadius.circular(29.0),
                        ),
                        child: Column(
                          children: [
                            // 총 지출 금액
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '총 지출',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          thisMonthTotalSpending < 0
                                              ? ''
                                              : formatCurrency(
                                                  thisMonthTotalSpending),
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Text(
                                        ' 원',
                                        style: TextStyle(
                                            fontSize: 20.0, height: 1.5),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            // 차트, legend
                            SizedBox(
                              height: 123.0,
                              child: FutureBuilder(
                                future: monthlyCategoryExpenditure,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // 데이터가 로드 중일 때 로딩 표시
                                    return const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    // 데이터를 성공적으로 가져왔을 때
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 파이 차트
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25.0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // 파이 차트
                                              SizedBox(
                                                width: 123.0,
                                                child: PieChart(
                                                  pieChartCountList:
                                                      setPieChartCount(snapshot
                                                          .data!
                                                          .monthlyCategoryExpenditureList),
                                                ),
                                              ),
                                              // 차트 가운데를 채우는 원
                                              Container(
                                                width:
                                                    61.0, // Set the diameter of the circle
                                                height:
                                                    61.0, // Same as width to make it a circle
                                                decoration: const BoxDecoration(
                                                  color: Color(
                                                      0xFFF2F4F7), // Set the color of the circle
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40.0,
                                        ),
                                        // 파이 차트 legend
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // monthlyCategoryExpenditureList 길이가 최대 legend 개수보다 많을 경우
                                            if (snapshot
                                                    .data!
                                                    .monthlyCategoryExpenditureList
                                                    .length >
                                                _maxLegendTotalExpenditure)
                                              for (int i = 0;
                                                  i <
                                                      _maxLegendTotalExpenditure;
                                                  i++)
                                                totalExpenditureLegend(
                                                    snapshot.data!
                                                        .monthlyCategoryExpenditureList[i],
                                                    pieChartColorList[i])

                                            // monthlyCategoryExpenditureList 길이가 최대 legend 개수보다 적을 경우
                                            else
                                              for (int i = 0;
                                                  i <
                                                      snapshot
                                                          .data!
                                                          .monthlyCategoryExpenditureList
                                                          .length;
                                                  i++)
                                                totalExpenditureLegend(
                                                    snapshot.data!
                                                        .monthlyCategoryExpenditureList[i],
                                                    pieChartColorList[i])
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // 지날달 대비 절약 금액
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Padding(
                          // 좌측 하단 삼각형을 보이게 하기 위해서 왼쪽에 padding 추가
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Container(
                            height: 55.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 9.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD2E0FB),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0xFFD2E0FB),
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withOpacity(0.2), // 그림자 색상
                                  blurRadius: 5.0, // 흐림 정도
                                  offset: const Offset(0, 2), // 그림자의 위치 (x, y)
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '지난 달보다',
                                  style: TextStyle(fontSize: 11.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 절약한 금액
                                    Text(
                                      thisMonthTotalSpending < 0
                                          ? ''
                                          : (expenseDifferenceThisAndLastMonth) <
                                                  0
                                              ? '${formatCurrency((expenseDifferenceThisAndLastMonth) * -1)} 원 '
                                              : '${formatCurrency(expenseDifferenceThisAndLastMonth)} 원 ',
                                      style: const TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      (expenseDifferenceThisAndLastMonth) > 0
                                          ? '절약 중입니다 \u{1F389}'
                                          : '더 지출 중입니다',
                                      style: const TextStyle(fontSize: 11.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 좌측 하단 삼각형
                        SvgPicture.asset('assets/icons/triangle.svg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 27.0,
            ),

            // 2. Home 화면 내용 - 비교하기
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 256.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29.2),
                  color: const Color(0xFFF2F4F7),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, right: 21.0, left: 21.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  dropDownButtonAge(),
                                  const SizedBox(
                                    width: 7.0,
                                  ),
                                  dropDownButtonGender(),
                                  const SizedBox(
                                    width: 7.0,
                                  ),
                                  const Text(
                                    '과 비교해보기',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              arrowButton('카테고리 수정'),
                            ],
                          ),
                        ),
                        // bar chart 모음
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 21.0, bottom: 20.0, left: 21.0),
                          child: SizedBox(
                            height: 160.0,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child:
                                  // 새로운 코드
                                  FutureBuilder(
                                future: monthlyCategoryExpenditure,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // 데이터가 로드 중일 때 로딩 표시
                                    return const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    // // 데이터를 성공적으로 가져왔을 때
                                    // 가져온 데이터 따로 저장
                                    List<CategoryExpenditureModel>
                                        monthlyCategoryExpenditureList =
                                        snapshot.data!
                                            .monthlyCategoryExpenditureList;
                                    // 가져온 데이터의 카테고리 따로 저장
                                    final List<String> snapshotCategoryList =
                                        [];
                                    for (int i = 0;
                                        i <
                                            monthlyCategoryExpenditureList
                                                .length;
                                        i++) {
                                      snapshotCategoryList.add(
                                          monthlyCategoryExpenditureList[i]
                                              .category);
                                    }
                                    // 만약 특정 카테고리에 소비하지 않아서 가져온 데이터에 해당 카테고리가 없는 경우
                                    // 지출금액을 0으로 설정해서 추가해준다.
                                    for (int i = 0;
                                        i < categoryList.length;
                                        i++) {
                                      if (!snapshotCategoryList.contains(
                                          categoryToUpperMap[
                                              categoryList[i]])) {
                                        monthlyCategoryExpenditureList.add(
                                            CategoryExpenditureModel.fromJson({
                                          "totalExpense": 0,
                                          "category": categoryToUpperMap[
                                              categoryList[i]]
                                        }));
                                      }
                                    }
                                    final int selectedAgeRange =
                                        setAgeRange(comparisonTargetAge);
                                    return Column(
                                      children: [
                                        for (int i = 0;
                                            i <
                                                monthlyCategoryExpenditureList
                                                    .length;
                                            i++)
                                          // 사용자가 설정한 카테고리에 해당하는지 확인
                                          if (comparisonCategoryList.contains(
                                              upperToCategoryMap[
                                                  monthlyCategoryExpenditureList[
                                                          i]
                                                      .category])) ...[
                                            barChart(
                                                upperToCategoryMap[
                                                    monthlyCategoryExpenditureList[
                                                            i]
                                                        .category]!,
                                                monthlyCategoryExpenditureList[
                                                        i]
                                                    .totalExpense,
                                                spendingByAgeCategory[
                                                        selectedAgeRange]![
                                                    monthlyCategoryExpenditureList[
                                                            i]
                                                        .category]!,
                                                max(
                                                    monthlyCategoryExpenditureList[
                                                            0]
                                                        .totalExpense,
                                                    spendingByAgeCategory[
                                                            selectedAgeRange]![
                                                        'MAX']!)),
                                            const SizedBox(
                                              height: 20.0,
                                            )
                                          ]
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // bar chart 범례
                    Positioned(
                      top: 56.0,
                      right: 20.0,
                      child: barChartLegend(),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 27.0,
            ),

            // 3. Home 화면 내용 - 최근 지출
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29.2),
                  color: const Color(0xFFF2F4F7),
                ),
                child: Column(
                  children: [
                    // 최근 지출 text, 지출 추가하기
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, right: 21.0, left: 27.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '최근 지출',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          arrowButton('지출 추가하기'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    // 최근 지출 내역 리스트
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 31.0, bottom: 8.0, right: 18.0),
                      child: FutureBuilder(
                        future: recentSpendingHistory,
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
                            // 데이터를 성공적으로 가져왔을 때
                            return Column(
                              children: [
                                for (int i = 0;
                                    i < snapshot.data!.expenditureList.length;
                                    i++)
                                  expenditureListElement(
                                      snapshot.data!.expenditureList[i])
                              ],
                            );
                          }
                        },
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

  Widget totalExpenditureLegend(CategoryExpenditureModel model, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          // 색
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          // 카테고리
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              upperToCategoryMap[model.category]!,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          // 금액
          Text(
            '${formatCurrency(model.totalExpense)} 원',
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget dropDownButtonAge() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          // shape를 사용해서 BorderRadius 설정.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 1; i < 10; i++) ...[
                      comparisonTargetAgeList(context, '${i}0대'),
                      const ListBorderLine(), //bottom sheet 경계선
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 58.0,
        height: 26.0,
        decoration: BoxDecoration(
          color: const Color(0xFFD2E0FB),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상
              blurRadius: 3.0, // 흐림 정도
              offset: const Offset(0, 2), // 그림자의 위치 (x, y)
            ),
          ],
        ),
        padding:
            const EdgeInsets.only(top: 5.0, right: 7.0, bottom: 5.0, left: 9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparisonTargetAge,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SvgPicture.asset('assets/icons/dropdown_down.svg'),
          ],
        ),
      ),
    );
  }

  Widget dropDownButtonGender() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          // shape를 사용해서 BorderRadius 설정.
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    comparisonTargetGenderList(context, '남성'),
                    const ListBorderLine(), //bottom sheet 경계선
                    comparisonTargetGenderList(context, '여성'),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 58.0,
        height: 26.0,
        decoration: BoxDecoration(
          color: const Color(0xFFD2E0FB),
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상
              blurRadius: 3.0, // 흐림 정도
              offset: const Offset(0, 2), // 그림자의 위치 (x, y)
            ),
          ],
        ),
        padding: const EdgeInsets.only(
            top: 5.0, right: 7.0, bottom: 5.0, left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comparisonTargetGender,
              style: const TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SvgPicture.asset('assets/icons/dropdown_down.svg'),
          ],
        ),
      ),
    );
  }

  Widget barChart(String name, int mine, int comp, int max) {
    double barChartAreaWidth = MediaQuery.of(context).size.width - 40.0 - 21.0;
    return SizedBox(
      width: barChartAreaWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 35.0,
            // 카테고리
            child: Text(
              name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // 158 = 35 + 50 + 60 + 3
                      width: (barChartAreaWidth - 158.0) * (mine / max) + 3.0,
                      height: 13.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8EACCD),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    // 금액
                    SizedBox(
                      width: 50.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatCurrency(mine),
                              overflow: TextOverflow.ellipsis, // 말 줄임표 추가
                              maxLines: 1, // 한 줄로 제한
                              softWrap: false, // 줄 바꿈 비활성화
                              style: const TextStyle(fontSize: 11.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      // 158 = 35 + 50 + 60 + 3
                      width: (barChartAreaWidth - 158.0) * (comp / max) + 3.0,
                      height: 13.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 50.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatCurrency(comp),
                              overflow: TextOverflow.ellipsis, // 말 줄임표 추가
                              maxLines: 1, // 한 줄로 제한
                              softWrap: false, // 줄 바꿈 비활성화
                              style: const TextStyle(fontSize: 11.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget arrowButton(String text) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (text == '지출 추가하기') {
          var addExpenditureResult = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenditure();
            },
          );
          if (addExpenditureResult != null && addExpenditureResult) {
            // 지출을 추가했으므로 홈화면에 지출이 추가된 것을 반영
            setState(() {
              // 1. 최근 지출 내역 추가
              recentSpendingHistory = SpendingService.getSpending();
            });
            // 2. 총 지출 내역 추가
            _getMonthlySpending();

            // 3. 카테고리별 지출 수정
            _getCategoryMonthlySpending();

            // 3. 지출 비교 내역 수정?
          }
        } else if (text == '카테고리 수정') {
          var selectedComparisonCategoryResult = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return EditComparisonCategory(
                currentCategoryList: comparisonCategoryList,
              );
            },
          );
          if (selectedComparisonCategoryResult != null) {
            _editCategoryPrefs(selectedComparisonCategoryResult);
          }
        }
      },
      child: Row(
        children: [
          Text(
            text,
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

  // 최근 소비 기록
  Widget expenditureListElement(ExpenditureModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // 소비 카테고리
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.circular(7.0)),
                padding: const EdgeInsets.only(
                    top: 3.0, right: 6.0, bottom: 3.0, left: 6.0),
                child: Row(
                  children: [
                    // SvgPicture.asset(model.svgIcon),
                    Image.asset(
                      'assets/images/select_category/${categoryIconNameMap[upperToCategoryMap[model.upperCategoryType]]}.png',
                      width: 22.0,
                      height: 22.0,
                      fit: BoxFit.contain, // 이미지가 정사각형 영역에 비율을 유지하며 맞춰짐
                    ),
                    const SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      upperToCategoryMap[model.upperCategoryType]!,
                      style: const TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              // 소비 날짜
              Text(
                // yyyy-MM-ddTHH:mm:ss 중에 MM-dd이 부분만 보이도록 설정
                '${model.dateTime.substring(5, 7)}/${model.dateTime.substring(8, 10)}',
                style: const TextStyle(
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          // 소비 금액
          Row(
            children: [
              SizedBox(
                width: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        '-${formatCurrency(model.expenseAmount)}',
                        overflow: TextOverflow.ellipsis, // 말 줄임표 추가
                        maxLines: 1, // 한 줄로 제한
                        softWrap: false, // 줄 바꿈 비활성화
                        textAlign: TextAlign.right, // 텍스트를 오른쪽 정렬
                        style: const TextStyle(
                            fontSize: 13.0, color: Color(0xFFFF0000)),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                ' 원',
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 나이 선택 리스트
  Widget comparisonTargetAgeList(BuildContext context, String listContent) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // default Padding을 0으로 설정
      title: Text(
        listContent,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      // 비교할 나이를 선택했을 때
      onTap: () {
        _editAgePrefs(listContent);
        Navigator.pop(context);
      },
    );
  }

  Widget comparisonTargetGenderList(BuildContext context, String listContent) {
    return ListTile(
      contentPadding: EdgeInsets.zero, // default Padding을 0으로 설정
      title: Text(
        listContent,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      // 비교할 성별을 선택했을 때
      onTap: () {
        _editGenderPrefs(listContent);
        Navigator.pop(context);
      },
    );
  }

  Widget barChartLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                  color: const Color(0xFF8EACCD),
                  borderRadius: BorderRadius.circular(3.0)),
            ),
            const SizedBox(
              width: 7.0,
            ),
            const Text(
              '나',
              style: TextStyle(
                fontSize: 11.0,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            Container(
              width: 12.0,
              height: 12.0,
              decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(3.0)),
            ),
            const SizedBox(
              width: 7.0,
            ),
            const Text(
              '평균',
              style: TextStyle(
                fontSize: 11.0,
                height: 1.2,
              ),
            ),
          ],
        )
      ],
    );
  }
}
