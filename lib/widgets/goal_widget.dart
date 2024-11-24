import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GoalWidget extends StatelessWidget {
  final String title;
  final String description;
  final int progress;
  final int goal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GoalWidget({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.goal,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverGoal = progress > goal;

    return Column(
      children: [
        GoalText(
          title: title,
          description: description,
          goal: goal,
          isOverGoal: isOverGoal,
          onDelete: onDelete,
          onEdit: onEdit,
        ),
        GoalStatus(progress: progress, goal: goal, isOverGoal: isOverGoal),
        const SizedBox(height: 20),
      ],
    );
  }
}

class GoalText extends StatelessWidget {
  final String title;
  final String description;
  final int goal;
  final bool isOverGoal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GoalText({
    super.key,
    required this.title,
    required this.description,
    required this.goal,
    required this.isOverGoal,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFf3f4f7),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 목표 텍스트
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Text(
              title,
              style: TextStyle(
                color: isOverGoal
                    ? const Color(0xFFA9B2BC)
                    : const Color(0xFF55677b),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 목표 내용
          Row(
            children: [
              Text(
                '$description ',
                style: TextStyle(
                  color: isOverGoal ? const Color(0xFFA9B2BC) : Colors.black,
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  onEdit();
                },
                child: Text(
                  formatNumber(goal),
                  style: TextStyle(
                    color: isOverGoal ? const Color(0xFFA9B2BC) : Colors.black,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' 원으로 제한하기',
                style: TextStyle(
                  color: isOverGoal ? const Color(0xFFA9B2BC) : Colors.black,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // 목표 삭제 아이콘
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: onDelete,
              child: Image.asset(
                'assets/images/delete_icon.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoalStatus extends StatelessWidget {
  final int progress;
  final int goal;
  final bool isOverGoal;

  const GoalStatus({
    super.key,
    required this.progress,
    required this.goal,
    required this.isOverGoal,
  });

  @override
  Widget build(BuildContext context) {
    final double progressFactor =
        goal > 0 ? 1 - (progress / goal).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(
            color: const Color(0xFFDDDDDD),
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progressFactor,
            child: Container(
              decoration: BoxDecoration(
                color: isOverGoal
                    ? const Color(0xFFFFC7C8)
                    : const Color(0xFFd2e0fb),
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOverGoal
                    ? '${formatNumber(progress)}원 사용 / ${formatNumber(progress - goal)}원 초과'
                    : '${formatNumber(progress)}원 사용 / ${formatNumber(goal - progress)}원 남음',
                style: TextStyle(
                  fontSize: 11,
                  color: isOverGoal ? Colors.red : Colors.black,
                  fontWeight: isOverGoal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '${formatNumber(goal)}원',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xff565555),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
