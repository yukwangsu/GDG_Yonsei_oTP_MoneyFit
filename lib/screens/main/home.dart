import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_financemanager/models/comparison_model.dart';
import 'package:flutter_financemanager/models/expenditure_model.dart';
import 'package:flutter_financemanager/models/pie_chart_model.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_expenditure.dart';
import 'package:flutter_financemanager/widgets/edit_comparison_category.dart';
import 'package:flutter_financemanager/widgets/list_border_line.dart';
import 'package:flutter_financemanager/widgets/pie_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<String> comparisonCategoryList = ['식비', '주거', '이동'];

  // // 추후 api사용 수정
  // late Future<List<PieModel>> pieChartList;
  // api사용 전 임시 변수
  List<PieModel> pieChartList = [
    PieModel(count: 12, color: Colors.red, content: '생활', spend: 300000),
    PieModel(count: 18, color: Colors.blue, content: '교통', spend: 200000),
    PieModel(count: 23, color: Colors.grey, content: '의료', spend: 100000),
    PieModel(count: 31, color: Colors.amber, content: '교육', spend: 70000),
    PieModel(count: 6, color: Colors.green, content: '기타', spend: 50000),
    PieModel(count: 4, color: Colors.cyan, content: '식비', spend: 50000),
    PieModel(count: 6, color: Colors.purple, content: '기타2', spend: 9000),
  ];

  // // 추후 api사용 수정
  // late Future<ComparisonModel> comparisonAverage;
  // api사용 전 임시 변수
  ComparisonModel comparisonAverage = ComparisonModel(
    averageSpendMap: {
      '쇼핑': 300000,
      '이동': 80000,
      '식비': 600000,
      '의료': 40000,
      '생활': 300000,
      '여행': 50000,
      '주거': 500000,
      '선물': 100000,
      '자녀': 0,
      '학습': 30000,
      '취미': 100000,
      '기타': 40000,
    },
    max: 600000,
  );
  ComparisonModel mySpend = ComparisonModel(
    averageSpendMap: {
      '쇼핑': 200000,
      '이동': 40000,
      '식비': 400000,
      '의료': 6000,
      '생활': 100000,
      '여행': 60000,
      '주거': 530000,
      '선물': 30000,
      '자녀': 0,
      '학습': 20000,
      '취미': 10000,
      '기타': 70000,
    },
    max: 530000,
  );

  // // 추후 api사용 수정
  // late Future<List<ExpenditureModel>> pieChartList;
  // api사용 전 임시 변수
  List<ExpenditureModel> expenditureList = [
    ExpenditureModel(
        svgIcon: 'assets/icons/category_shopping_icon.svg',
        category: '쇼핑',
        date: '2024.11.12',
        spend: 50000),
    ExpenditureModel(
        svgIcon: 'assets/icons/category_shopping_icon.svg',
        category: '쇼핑',
        date: '2024.11.12',
        spend: 555555),
  ];

  @override
  void initState() {
    super.initState();
    setPieChartColor(pieChartList);
    setPieChartCount(pieChartList);
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

  void setPieChartColor(List<PieModel> list) {
    for (int i = 0; i < list.length; i++) {
      list[i].color = pieChartColorList[i % pieChartColorList.length];
    }
  }

  void setPieChartCount(List<PieModel> list) {
    int spendSum = 0;
    int countSum = 0;
    for (int i = 0; i < list.length; i++) {
      spendSum += list[i].spend;
    }
    for (int i = 0; i < list.length; i++) {
      list[i].count = (list[i].spend / spendSum * 100).floor();
    }
    for (int i = 0; i < list.length; i++) {
      countSum += list[i].count;
    }
    if (countSum < 100) {
      list[0].count += 100 - countSum;
    }
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
                            const Padding(
                              padding: EdgeInsets.only(top: 18.0, left: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '총 지출',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 7.0,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.0),
                                        child: Text(
                                          '1,253,500',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Text(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 파이 차트
                                  Padding(
                                    padding: const EdgeInsets.only(left: 36.0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // 파이 차트
                                        SizedBox(
                                          width: 123.0,
                                          child: PieChart(
                                            pieChartList: pieChartList,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // pieChartList의 개수가 최대 legend 개수보다 많을 경우
                                      if (pieChartList.length >
                                          _maxLegendTotalExpenditure)
                                        for (int i = 0;
                                            i < _maxLegendTotalExpenditure;
                                            i++)
                                          totalExpenditureLegend(
                                              pieChartList[i])

                                      // pieChartList의 개수가 최대 legend 개수보다 적을 경우
                                      else
                                        for (int i = 0;
                                            i < pieChartList.length;
                                            i++)
                                          totalExpenditureLegend(
                                              pieChartList[i])
                                    ],
                                  )
                                ],
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
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '지난 달보다',
                                  style: TextStyle(fontSize: 11.0),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 절약한 금액
                                    Text(
                                      '100,000 원 ',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '절약하셨네요 ',
                                      style: TextStyle(fontSize: 11.0),
                                    ),
                                    // 이모지
                                    Text(
                                      '\u{1F389}',
                                      style: TextStyle(fontSize: 11.0),
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
                height: 211.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29.2),
                  color: const Color(0xFFF2F4F7),
                ),
                child: Stack(
                  children: [
                    Column(
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
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0;
                                    i < comparisonCategoryList.length;
                                    i++) ...[
                                  barChart(
                                    comparisonCategoryList[i],
                                    mySpend.averageSpendMap[
                                        comparisonCategoryList[i]]!,
                                    comparisonAverage.averageSpendMap[
                                        comparisonCategoryList[i]]!,
                                    max(comparisonAverage.max, mySpend.max),
                                  ),
                                ]
                              ],
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
                              fontSize: 12.0,
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
                      child: Column(
                        children: [
                          for (int i = 0; i < expenditureList.length; i++)
                            expenditureListElement(expenditureList[i])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalExpenditureLegend(PieModel model) {
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
                color: model.color,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          // 카테고리
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              model.content,
              style: const TextStyle(fontSize: 11.0),
            ),
          ),
          // 금액
          Text(
            '${formatCurrency(model.spend)} 원',
            style: const TextStyle(fontSize: 11.0),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        width: 60.0,
        height: 155.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 30.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        mine.toString(),
                        style: const TextStyle(fontSize: 7.0),
                      ),
                      Container(
                        width: 13.0,
                        height: 105 * (mine / max),
                        decoration: const BoxDecoration(
                          color: Color(0xFF8EACCD),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        comp.toString(),
                        style: const TextStyle(fontSize: 7.0),
                      ),
                      Container(
                        width: 13.0,
                        height: 105 * (comp / max),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 3.0,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 10.0),
            )
          ],
        ),
      ),
    );
  }

  Widget arrowButton(String text) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (text == '지출 추가하기') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenditure();
            },
          );
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
            setState(() {
              comparisonCategoryList = selectedComparisonCategoryResult;
            });
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

  Widget expenditureListElement(ExpenditureModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(model.svgIcon),
              const SizedBox(
                width: 17.0,
              ),
              Text(
                model.category,
                style: const TextStyle(
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                model.date,
                style: const TextStyle(
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              SizedBox(
                width: 63.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        '-${formatCurrency(model.spend)}',
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
      onTap: () {
        setState(() {
          comparisonTargetAge = listContent;
        });
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
      onTap: () {
        setState(() {
          comparisonTargetGender = listContent;
        });
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
                fontSize: 10.0,
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
                fontSize: 10.0,
                height: 1.2,
              ),
            ),
          ],
        )
      ],
    );
  }
}
