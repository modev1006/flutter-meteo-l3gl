import 'package:flutter/material.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final double size;

  const AnimatedWeatherIcon({Key? key, this.size = 100}) : super(key: key);

  @override
  _AnimatedWeatherIconState createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.shade100.withOpacity(0.6),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.wb_sunny,
              color: Colors.white,
              size: 60,
            ),
          ),
        );
      },
    );
  }
}