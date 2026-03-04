import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingGauge extends StatelessWidget {
  final double progress;
  final double size;

  const LoadingGauge({
    Key? key,
    required this.progress,
    this.size = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: size,
        lineWidth: 15,
        percent: progress,
        center: Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        progressColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey.shade300,
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animationDuration: 100,
        curve: Curves.easeOut,
      ),
    );
  }
}