import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GoalWidget extends StatelessWidget {
  final int index;
  final String category;
  final int spentAmount;
  final int targetSpendingAmount;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GoalWidget({
    super.key,
    required this.index,
    required this.category,
    required this.spentAmount,
    required this.targetSpendingAmount,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverGoal = spentAmount > targetSpendingAmount;

    return Column(
      children: [
        GoalText(
          index: index,
          category: category,
          targetSpendingAmount: targetSpendingAmount,
          isOverGoal: isOverGoal,
          onDelete: onDelete,
          onEdit: onEdit,
        ),
        GoalStatus(
            spentAmount: spentAmount,
            targetSpendingAmount: targetSpendingAmount,
            isOverGoal: isOverGoal),
        const SizedBox(height: 20),
      ],
    );
  }
}

class GoalText extends StatelessWidget {
  final int index;
  final String category;
  final int targetSpendingAmount;
  final bool isOverGoal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const GoalText({
    super.key,
    required this.index,
    required this.category,
    required this.targetSpendingAmount,
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
        color: Colors.white,
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
              '목표 $index',
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
              // 1. 카테고리 제목
              Text(
                '$category 지출 ',
                style: TextStyle(
                  color: isOverGoal ? const Color(0xFFA9B2BC) : Colors.black,
                  fontSize: 12,
                ),
              ),
              // 2. 목표 금액
              GestureDetector(
                onTap: () {
                  onEdit();
                },
                child: Text(
                  formatNumber(targetSpendingAmount),
                  style: TextStyle(
                    color: isOverGoal ? const Color(0xFFA9B2BC) : Colors.black,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              // 3. 원으로 제한하기
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
  final int spentAmount;
  final int targetSpendingAmount;
  final bool isOverGoal;

  const GoalStatus({
    super.key,
    required this.spentAmount,
    required this.targetSpendingAmount,
    required this.isOverGoal,
  });

  @override
  Widget build(BuildContext context) {
    final double progressFactor = targetSpendingAmount > 0
        ? 1 - (spentAmount / targetSpendingAmount).clamp(0.0, 1.0)
        : 0.0;

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
                    ? '${formatNumber(spentAmount)}원 사용 / ${formatNumber(spentAmount - targetSpendingAmount)}원 초과'
                    : '${formatNumber(spentAmount)}원 사용 / ${formatNumber(targetSpendingAmount - spentAmount)}원 남음',
                style: TextStyle(
                  fontSize: 11,
                  color: isOverGoal ? Colors.red : Colors.black,
                  fontWeight: isOverGoal ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '${formatNumber(targetSpendingAmount)}원',
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
