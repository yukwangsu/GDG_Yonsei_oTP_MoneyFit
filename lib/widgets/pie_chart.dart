import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_financemanager/models/pie_chart_model.dart';
import 'package:flutter_financemanager/variables.dart';

class PieChart extends StatefulWidget {
  final List<int> pieChartCountList;
  const PieChart({
    super.key,
    required this.pieChartCountList,
  });

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            if (animationController.value < 0.1) {
              return const SizedBox();
            }
            return CustomPaint(
              size: const Size(123.0, 123.0),
              painter: _PieChart(
                  widget.pieChartCountList, animationController.value),
            );
          },
        ),
      ],
    );
  }
}

class _PieChart extends CustomPainter {
  final List<int> data;
  final double value;

  _PieChart(this.data, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.white;

    // Set radius to fully utilize the size of the canvas without extra padding
    double radius = size.width / 2;
    double startPoint = 0.0;

    for (int i = 0; i < data.length; i++) {
      double count = data[i].toDouble();
      count = (count * value + count) - data[i];

      double startAngle = 2 * math.pi * (count / 100);
      double nextAngle = 2 * math.pi * (count / 100);
      circlePaint.color = i > 3 ? pieChartColorList[4] : pieChartColorList[i];

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2), radius: radius),
          -math.pi / 2 + startPoint,
          nextAngle,
          true,
          circlePaint);
      startPoint = startPoint + startAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
