import 'package:flutter/cupertino.dart';

class ShimmerLoading extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _animation = Tween(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return _shimmerGradient.createShader(
              Rect.fromLTRB(
                _animation.value * bounds.width,
                0.0,
                (1 + _animation.value) * bounds.width,
                bounds.height,
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

const _shimmerGradient = LinearGradient(
  colors: [Color(0xFFB0B0B0), Color(0xFFF4F4F4), Color(0xFFB0B0B0)],
  stops: [0.1, 0.5, 0.9],
  begin: Alignment(-1.0, 0.0),

  end: Alignment(1.0, 0.0),

  tileMode: TileMode.clamp,
);
