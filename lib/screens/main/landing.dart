import 'package:flutter/material.dart';
import 'package:flutter_financemanager/screens/main/game.dart';
import 'package:flutter_financemanager/screens/main/goal.dart';
import 'package:flutter_financemanager/screens/main/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;

  // 각 화면을 관리하는 리스트
  final List<Widget> _screens = [
    const HomeScreen(),
    const GoalScreen(),
    const GameScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex], // 선택한 화면을 표시
        bottomNavigationBar: SizedBox(
          height: 76.0,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory, // 터치 효과 제거
            ),
            child: BottomNavigationBarTheme(
              data: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white, // 배경색을 흰색으로 설정
                selectedItemColor: Color(0xFF687D94), // 선택된 아이템 색상
                unselectedItemColor: Color(0xFF9FA9B3), // 선택되지 않은 아이템 색상
                selectedLabelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold), // 선택된 라벨 크기 11px
                unselectedLabelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold), // 선택되지 않은 라벨 크기 11px
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/home_icon.svg',
                          color: _selectedIndex == 0
                              ? const Color(0xFF687D94)
                              : const Color(0xFF9FA9B3),
                        ),
                        const SizedBox(height: 5), // icon과 label 사이 간격
                      ],
                    ),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/goals_icon.svg',
                          color: _selectedIndex == 1
                              ? const Color(0xFF687D94)
                              : const Color(0xFF9FA9B3),
                        ),
                        const SizedBox(height: 5), // icon과 label 사이 간격
                      ],
                    ),
                    label: '목표',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/game_icon.svg',
                          color: _selectedIndex == 2
                              ? const Color(0xFF687D94)
                              : const Color(0xFF9FA9B3),
                        ),
                        const SizedBox(height: 5), // icon과 label 사이 간격
                      ],
                    ),
                    label: '게임',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
