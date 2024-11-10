import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_financemanager/models/pie_chart_model.dart';

class PieChart extends StatefulWidget {
  final List<PieModel> pieChartList;
  const PieChart({
    super.key,
    required this.pieChartList,
  });

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with TickerProviderStateMixin {
  late AnimationController animationController;
  // List<PieModel> model = [
  //   PieModel(count: 12, color: Colors.red.withOpacity(1)),
  //   PieModel(count: 18, color: Colors.blue.withOpacity(1)),
  //   PieModel(count: 23, color: Colors.grey.withOpacity(1)),
  //   PieModel(count: 31, color: Colors.amber.withOpacity(1)),
  //   PieModel(count: 6, color: Colors.green.withOpacity(1)),
  //   PieModel(count: 4, color: Colors.cyan.withOpacity(1)),
  //   PieModel(count: 6, color: Colors.purple.withOpacity(1)),
  // ];
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
              painter:
                  _PieChart(widget.pieChartList, animationController.value),
            );
          },
        ),
      ],
    );
  }
}

class _PieChart extends CustomPainter {
  final List<PieModel> data;
  final double value;

  _PieChart(this.data, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.white;

    // Set radius to fully utilize the size of the canvas without extra padding
    double radius = size.width / 2;
    double startPoint = 0.0;

    for (int i = 0; i < data.length; i++) {
      double count = data[i].count.toDouble();
      count = (count * value + count) - data[i].count;

      double startAngle = 2 * math.pi * (count / 100);
      double nextAngle = 2 * math.pi * (count / 100);
      circlePaint.color = data[i].color;

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
