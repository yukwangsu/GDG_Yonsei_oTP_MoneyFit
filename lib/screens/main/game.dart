import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 최상단 빈 공간
          SizedBox(
            height: 45.0,
          ),
          // game 글자
          Padding(
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
          SizedBox(
            height: 27.0,
          ),
          // 1. Game 화면 내용 - 출석체크
        ],
      ),
    );
  }
}
