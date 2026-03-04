
import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final double size;

  const AnimatedWeatherIcon({Key? key, this.size = 200}) : super(key: key);

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
      duration: const Duration(seconds: 50),
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
        // Valeurs animées
        final dayProgress = (_controller.value * .9) % 1.0; // 0 à 1 pour jour/nuit
        final isDay = dayProgress < 0.5;
        final sunMoonProgress = _controller.value * 2 * 3.14159;

        // Position du soleil/lune (arc dans le ciel)
        final verticalPosition = sin(sunMoonProgress) * 0.4 + 0.5;
        final horizontalPosition = sin(sunMoonProgress + 1.57) * 0.3 + 0.5;

        // Couleurs du ciel qui changent
        final skyColor = isDay
            ? Color.lerp(Colors.blue.shade300, Colors.orange.shade200, (dayProgress * 2))
            : Color.lerp(Colors.deepPurple.shade900, Colors.indigo.shade900, ((dayProgress - 0.5) * 2));

        // Taille et opacité des étoiles
        final starOpacity = isDay ? 0.0 : (sin(_controller.value * 10) * 0.3 + 0.3);

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                skyColor!,
                isDay ? Colors.blue.shade900 : Colors.black,
              ],
              stops: const [0.3, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: (isDay ? Colors.yellow : Colors.white).withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Étoiles (uniquement la nuit)
              if (!isDay)
                ...List.generate(20, (index) {
                  final randomX = (index * 0.23) % 1.0;
                  final randomY = (index * 0.47) % 1.0;
                  final twinkle = sin(_controller.value * 5 + index) * 0.5 + 0.5;

                  return Positioned(
                    left: widget.size * randomX,
                    top: widget.size * randomY,
                    child: Container(
                      width: 2 + twinkle * 2,
                      height: 2 + twinkle * 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(starOpacity * twinkle),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),

              // Nuages qui défilent
              Positioned(
                left: -widget.size * 0.2 + (_controller.value * widget.size * 0.5) % (widget.size * 1.4),
                top: widget.size * 0.2,
                child: Opacity(
                  opacity: isDay ? 0.6 : 0.2,
                  child: Container(
                    width: widget.size * 0.4,
                    height: widget.size * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // Deuxième nuage
              Positioned(
                left: -widget.size * 0.5 + (_controller.value * widget.size * 0.3) % (widget.size * 1.8),
                top: widget.size * 0.5,
                child: Opacity(
                  opacity: isDay ? 0.4 : 0.1,
                  child: Container(
                    width: widget.size * 0.3,
                    height: widget.size * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              // Soleil ou Lune (position animée)
              Positioned(
                left: widget.size * horizontalPosition - widget.size * 0.15,
                top: widget.size * verticalPosition - widget.size * 0.15,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: isDay ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, double value, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14159,
                      child: Container(
                        width: widget.size * 0.2,
                        height: widget.size * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDay
                              ? Colors.yellow.shade500
                              : Colors.grey.shade300,
                          boxShadow: [
                            BoxShadow(
                              color: (isDay ? Colors.yellow : Colors.white).withOpacity(0.1),
                              blurRadius: 30 * (isDay ? value : 1 - value),
                              spreadRadius: 10 * (isDay ? value : 1 - value),
                            ),
                          ],
                          gradient: !isDay
                              ? RadialGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade500,
                            ],
                          )
                              : null,
                        ),
                        child: isDay
                            ? Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                          size: widget.size * 0.15,
                        )
                            : Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.brightness_2,
                              color: Colors.white,
                              size: widget.size * 0.15,
                            ),
                            // Cratères de la lune
                            Positioned(
                              left: widget.size * 0.05,
                              top: widget.size * 0.05,
                              child: Container(
                                width: widget.size * 0.03,
                                height: widget.size * 0.03,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Petits nuages supplémentaires
              if (isDay)
                ...List.generate(3, (index) {
                  final cloudX = (_controller.value * 0.5 + index * 0.3) % 1.0;
                  return Positioned(
                    left: widget.size * cloudX,
                    top: widget.size * 0.1 + index * 20.0,
                    child: Container(
                      width: widget.size * 0.1,
                      height: widget.size * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}