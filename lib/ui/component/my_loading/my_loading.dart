

import 'package:flutter/material.dart';
import 'package:story_app/ui/component/my_loading/spinner_painter.dart';

class MyLoading extends StatefulWidget {
  final double size;
  final Duration duration;
  final List<Color> colors;

  const MyLoading({
    super.key,
    this.size = 60,
    this.duration = const Duration(milliseconds: 1400),
    this.colors = const [
      Color(0xFF00C853),
      Color(0xFF2196F3),
      Color(0xFF00C853),
    ],
  });

  @override
  State<MyLoading> createState() => _StateMyLoading();
}

class _StateMyLoading extends State<MyLoading> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this,duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(animation: _animationController, builder: (context, child) {
        return CustomPaint(
          painter: SpinnerPainter(
            progress : _animationController.value,
            colors : widget.colors,
          ),
        );
      },),
    );
  }
}
