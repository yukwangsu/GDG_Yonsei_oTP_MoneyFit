import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_financemanager/services/goal_service.dart';
import 'package:flutter_financemanager/services/spending_service.dart';
import 'package:flutter_financemanager/variables.dart';
import 'package:flutter_financemanager/widgets/add_expenditure_select_category.dart';
import 'package:flutter_financemanager/widgets/number_input_format.dart';
import 'package:flutter_financemanager/widgets/select_button.dart';
import 'package:intl/intl.dart';

class AskDeleteGoal extends StatefulWidget {
  final int id;

  const AskDeleteGoal({
    super.key,
    required this.id,
  });

  @override
  State<AskDeleteGoal> createState() => _AskDeleteGoalState();
}

class _AskDeleteGoalState extends State<AskDeleteGoal> {
  @override
  void initState() {
    super.initState();
  }

  // 삭제 버튼을 눌렀을 때
  void onClickDeleteButton() async {
    // 목표 삭제하는 api 호출
    final deleteGoalResult = await GoalService.deleteGoalService(widget.id);
    Navigator.of(context).pop(deleteGoalResult);
    // Navigator.of(context).pop(true); // 임시
  }

  // 취소 버튼을 눌렀을 때
  void onClickCancelButton() {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Dialog: 희려진 부분도 모두 포함
      child: Dialog(
        child: Container(
          width: 301.0,
          height: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, right: 33.0, bottom: 20.0, left: 33.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '목표 삭제하기',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '목표 n을 삭제하시겠습니까?',
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cancelButton(),
                    const SizedBox(
                      width: 18.0,
                    ),
                    deleteButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 삭제 버튼
  Widget deleteButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: const Color(0xFFD2E0FB),
        radius: 5,
        text: '확인',
        textColor: Colors.black,
        textSize: 13.0,
        onPress: () {
          onClickDeleteButton();
        },
      ),
    );
  }

  // 취소 버튼
  Widget cancelButton() {
    return Expanded(
      child: SelectButton(
        height: 31.0,
        padding: 33.0,
        bgColor: const Color(0xFFD9D9D9),
        radius: 5,
        text: '취소',
        textColor: Colors.black,
        textSize: 13.0,
        onPress: () {
          onClickCancelButton();
        },
      ),
    );
  }
}
