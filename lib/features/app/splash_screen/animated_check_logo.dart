import 'package:flutter/material.dart';

class AnimatedCheckLogo extends StatefulWidget {
  const AnimatedCheckLogo({Key? key}) : super(key: key);

  @override
  _AnimatedCheckLogoState createState() => _AnimatedCheckLogoState();
}

class _AnimatedCheckLogoState extends State<AnimatedCheckLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _circleAnimation,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 100,
            color: Colors.white,
          ),
          ScaleTransition(
            scale: _checkAnimation,
            child: const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
