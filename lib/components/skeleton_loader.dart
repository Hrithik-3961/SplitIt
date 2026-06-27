import 'package:flutter/material.dart';
import 'package:splitit/constants/values.dart';

class SkeletonLoader extends StatefulWidget {
  final int itemCount;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.itemCount = 5,
    this.width = double.infinity,
    this.height = 70,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Values.shimmerAnimationDuration,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.key,
      padding: Values.defaultPadding,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) => Padding(
        padding: Values.defaultPaddingSmall,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    (0.1 + _animation.value * 0.2).clamp(0.0, 1.0),
                    (0.5 + _animation.value * 0.2).clamp(0.0, 1.0),
                    (0.9 + _animation.value * 0.2).clamp(0.0, 1.0),
                  ],
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[100]!,
                    Colors.grey[300]!,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
